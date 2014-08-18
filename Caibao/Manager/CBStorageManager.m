//
//  CBStorageManager.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBStorageManager.h"
#import <objc/runtime.h>


static char _storageKey;


static NSString * const cbDefaultStorageSeparatedString = @"_";


static NSString *_defaultDatabaseDirectory;
static NSString *_defaultDatabaseGroupName = @"com.ridgecorn.CaibaoStorage.default";
static NSString *_defaultDatabasePrefix = @"cb";
static LevelDBOptions _defaultDatabaseOptions;


static NSArray * CBAllPropertyKeys(const id obj) {
    static NSMutableDictionary *cachedPropertyKeys;
    
    if ( !cachedPropertyKeys) {
        cachedPropertyKeys = [@{} mutableCopy];
    }
    
    NSMutableArray *propertyKeys = [cachedPropertyKeys objectForKey:NSStringFromClass([obj class])];
    
    if ( !propertyKeys) {
        propertyKeys = [@[] mutableCopy];
        u_int count;
        objc_property_t *properties= class_copyPropertyList([obj class], &count);
        
        for (int i = 0; i < count; i++) {
            const char *property = property_getName(properties[i]);
            NSString *propertyKey = [NSString  stringWithCString:property encoding:NSUTF8StringEncoding];
            [propertyKeys addObject:propertyKey];
        }
        
        [cachedPropertyKeys setObject:propertyKeys forKey:NSStringFromClass([obj class])];
    }

    return propertyKeys;
}

static BOOL CBIsObjsEquals(const id obj1, const id obj2, const BOOL ignoreNilValue) {
    BOOL isEqual = YES;
    
    NSArray *propertyKeys = CBAllPropertyKeys(obj1);

    if ([propertyKeys count]) {
        for (NSString *key in propertyKeys) {
            id value1 = [obj1 valueForKey:key];
            id value2 = [obj2 valueForKey:key];
            
            if (value1) {
                if ( !([value1 isKindOfClass:[value2 class]] && CBIsObjsEquals(value1, value2, ignoreNilValue))) {
                    isEqual = NO;
                    break;
                }
            } else if ( !ignoreNilValue && value2) {
                isEqual = NO;
                break;
            }
        }
    } else {
        isEqual = [obj1 isEqual:obj2];
    }
    
    return isEqual;
}

static NSString * CBGenDatabasePath() {
    return [_defaultDatabaseDirectory stringByAppendingPathComponent:_defaultDatabaseGroupName];
}

static NSString * CBGenDatabaseFileName(const Class cls) {
    return NSStringFromClass(cls);
}

static NSString * CBGenAppPath() {
    return NSHomeDirectory();
}

static NSString * CBPathForCachesDirectory() {
    static NSString *pathForCachesDirectory;
    
    if ( !pathForCachesDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        pathForCachesDirectory = [paths lastObject];
    }
    
    return pathForCachesDirectory;
}

static LevelDBOptions CBGenDatabaseOptions() {
    return [LevelDB makeOptions];
}

static NSString * CBGenDatabaseFilePath(const Class cls, const NSString *path) {
    return [path stringByAppendingPathComponent:CBGenDatabaseFileName(cls)];
}

static NSString * CBGenDatabaseFileKey(const Class cls, const NSString *path) {
    return [[path substringFromIndex:[CBGenAppPath() length]] stringByAppendingPathComponent:CBGenDatabaseFileName(cls)];
}

static void CBSetStorageKeyToObject(const id key, const id obj) {
    if (obj) {
        objc_setAssociatedObject(obj, &_storageKey, key, OBJC_ASSOCIATION_COPY);
    }
}

static id CBGetStorageKeyFromObject(const id obj) {
    id key = nil;
    
    if (obj) {
        key = objc_getAssociatedObject(obj, &_storageKey);
    }
    
    return key;
}

static NSString * CBGenDatabaseStorageKey(const id obj) {
    id key = CBGetStorageKeyFromObject(obj);
    NSInteger index = [key integerValue] + 1;
    
    CBSetStorageKeyToObject(key = [NSString stringWithFormat:@"%ld", (long)index], obj);
    
    return [NSString stringWithFormat:@"%@%@%011ld", _defaultDatabasePrefix, cbDefaultStorageSeparatedString, (long)index];
}

@interface CBStorageManager ()

@property (nonatomic) NSMutableDictionary *LDBPool;

@end

@implementation CBStorageManager

#pragma mark - Initialization & Configuration

#pragma mark Manager Instance

+ (instancetype)sharedManager {
    static CBStorageManager *manager;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark Manager Init

- (instancetype)init {
    if (self = [super init]) {
        _LDBPool = [@{} mutableCopy];
        
        _defaultDatabaseDirectory = CBPathForCachesDirectory();
        _defaultDatabaseOptions = CBGenDatabaseOptions();
    }
    
    return self;
}

#pragma mark Database Config

- (NSString *)databasePath {
    return CBGenDatabasePath();
}

- (NSString *)databaseDirectory {
    return _defaultDatabaseDirectory;
}

- (void)setDatabaseDirectory:(NSString *)databaseDirectory {
    _defaultDatabaseDirectory = databaseDirectory;
}

- (NSString *)databaseGroupName {
    return _defaultDatabaseGroupName;
}

- (void)setDatabaseGroupName:(NSString *)databaseGroupName {
    _defaultDatabaseGroupName = databaseGroupName;
}

#pragma mark
#pragma mark - DataBase

#pragma mark DataBase instance | Open DataBase

- (LevelDB *)databaseForClass:(Class)cls withPath:(NSString *)path andOptions:(LevelDBOptions)opts {
    NSString *dbFilePath = CBGenDatabaseFilePath(cls, path);
    NSString *dbFileKey = CBGenDatabaseFileKey(cls, path);
    LevelDB *ldb = [_LDBPool objectForKey:dbFileKey];
    
    if ( !ldb) {
        ldb = [[LevelDB alloc] initWithPath:dbFilePath name:CBGenDatabaseFileName(cls) andOptions:opts];
        __block NSString *index = @"0";
        
        [ldb enumerateKeysBackward:YES startingAtKey:nil filteredByPredicate:nil andPrefix:_defaultDatabasePrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
            index = [[NSStringFromLevelDBKey(key) componentsSeparatedByString:cbDefaultStorageSeparatedString] lastObject];
            
            *stop = YES;
        }];
        
        CBSetStorageKeyToObject(index, ldb);
        
        [_LDBPool setObject:ldb forKey:dbFileKey];
    }

    return ldb;
}

- (LevelDB *)databaseForClass:(Class)cls withPath:(NSString *)path {
    return [self databaseForClass:cls withPath:path andOptions:_defaultDatabaseOptions];
}

- (LevelDB *)databaseForClass:(Class)cls {
    return [self databaseForClass:cls withPath:CBGenDatabasePath()];
}

#pragma mark Close Database(s)

- (void)closeDatabaseForClass:(Class)cls withPath:(NSString *)path {
    NSString *dbKey = CBGenDatabaseFileKey(cls, path);
    LevelDB *ldb = [_LDBPool objectForKey:dbKey];
    
    if (ldb) {
        [ldb close];
        [_LDBPool removeObjectForKey:dbKey];
    }
}

- (void)closeDatabaseForClass:(Class)cls {
    [self closeDatabaseForClass:cls withPath:CBGenDatabasePath()];
}

- (void)closeAllDatabases {
    for (LevelDB *ldb in [_LDBPool allValues]) {
        [ldb close];
    }
    
    [_LDBPool removeAllObjects];
}

#pragma mark Delete Database(s)

- (void)deleteAllDatabasesInPath:(NSString *)path {
    [self closeAllDatabases];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)deleteDatabaseForClass:(Class)cls inPath:(NSString *)path {
    [self deleteAllDatabasesInPath:CBGenDatabaseFilePath(cls, path)];
}

- (void)deleteAllDatabasesInCurrentPath {
    [self deleteAllDatabasesInPath:CBGenDatabasePath()];
}

#pragma mark - Object

#pragma mark Save & Update Object(s)

- (void)saveObject:(id)obj withPath:(NSString *)path {
    if (obj) {
        LevelDB *ldb = [self databaseForClass:[obj class] withPath:path];
        NSString *key = [self storageKeyForObject:obj];
        
        if ( !key) {
            key = CBGenDatabaseStorageKey(ldb);

            CBSetStorageKeyToObject(key, obj);
        }
        
        [ldb setObject:obj forKey:key];
    }
}

- (void)saveObject:(id)obj {
    [self saveObject:obj withPath:CBGenDatabasePath()];
}

- (void)saveObjectsWithPaths:(NSDictionary *)objsWithPaths {
    NSArray *paths = [objsWithPaths allKeys];
    NSArray *objss = [objsWithPaths allValues];
    NSInteger count = [objsWithPaths count];
    
    for (NSInteger index = 0; index < count; index ++) {
        id objs = objss[index];
        NSString *path = paths[index];

        for (id obj in objs) {
            [self saveObject:obj withPath:path];
        }
    }
}

- (void)saveObjects:(NSArray *)objs {
    [self saveObjectsWithPaths:@{CBGenDatabasePath():objs}];
}

#pragma mark Storage Key(s)

-  (NSArray *)allKeysForClass:(Class)cls withPath:(NSString *)path filteredByPredicate:(NSPredicate *)predicate {
    NSMutableArray *allKeys = [@[] mutableCopy];
    
    [[self databaseForClass:cls withPath:path] enumerateKeysBackward:NO startingAtKey:nil filteredByPredicate:predicate andPrefix:_defaultDatabasePrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
        [allKeys addObject:NSStringFromLevelDBKey(key)];
    }];
    
    return allKeys;
}

- (NSArray *)allKeysForClass:(Class)cls withPath:(NSString *)path {
    return [self allKeysForClass:cls withPath:path filteredByPredicate:nil];
}

- (NSArray *)allKeysForClass:(Class)cls {
    return [self allKeysForClass:cls withPath:CBGenDatabasePath()];
}

- (NSString *)storageKeyForObject:(id)obj {
    return CBGetStorageKeyFromObject(obj);
}

- (void)updateStorageKey:(NSString *)key forObject:(id)obj {
    CBSetStorageKeyToObject(key, obj);
}

- (void)removeStorageKeyForObject:(id)obj {
    [self updateStorageKey:nil forObject:obj];
}

#pragma mark Fetch Object(s)

- (NSArray *)objectsForClass:(Class)cls withCount:(NSInteger)count {
    __block NSMutableDictionary *results = [@{} mutableCopy];
    
    [[self databaseForClass:cls] enumerateKeysAndObjectsBackward:YES lazily:NO startingAtKey:nil filteredByPredicate:nil andPrefix:_defaultDatabasePrefix usingBlock:^(LevelDBKey *key, id obj, BOOL *stop) {
        
        [results setObject:obj forKey:NSStringFromLevelDBKey(key)];
        
        if (count > 0 && [results count] >= count) {
            *stop = YES;
        }
    }];
    
    NSMutableArray *objects = [@[] mutableCopy];
    
    for (id key in [results allKeys]) {
        id obj = [results objectForKey:key];
        CBSetStorageKeyToObject(key, obj);
        [objects addObject:obj];
    }
    
    return objects;
}

- (id)objectForClass:(Class)cls {
    NSArray *rets = [self objectsForClass:cls withCount:1];
    
    id obj = nil;
    if (rets && [rets count]) {
        obj = [rets firstObject];
    }
    
    return obj;
}

- (NSArray *)allObjectsForClass:(Class)cls {
    return [self objectsForClass:cls withCount:-1];
}

#pragma Find Object(s)

- (NSArray *)allKeysForDuplicateObject:(id)obj withPath:(NSString *)path {
    return [self allKeysForClass:[obj class] withPath:path filteredByPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [CBStorageManager isObject:obj equalTo:evaluatedObject];
    }]];
}

- (NSArray *)allKeysForDuplicateObject:(id)obj {
    return [self allKeysForDuplicateObject:obj withPath:CBGenDatabasePath()];
}

- (NSArray *)allKeysForSimilarObject:(id)obj withPath:(NSString *)path {
    return [self allKeysForClass:[obj class] withPath:path filteredByPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [CBStorageManager isObject:obj similarTo:evaluatedObject];
    }]];
}

- (NSArray *)allKeysForSimilarObject:(id)obj {
    return [self allKeysForSimilarObject:obj withPath:CBGenDatabasePath()];
}

- (NSInteger)countOfObjectsForClass:(Class)cls withPath:(NSString *)path {
    __block NSInteger count = 0;
    
    [[self databaseForClass:cls withPath:path] enumerateKeysBackward:NO startingAtKey:nil filteredByPredicate:nil andPrefix:_defaultDatabasePrefix usingBlock:^(LevelDBKey *key, BOOL *stop) {
        count ++;
    }];
    
    return count;
}

- (NSInteger)countOfObjectsForClass:(Class)cls {
    return [self countOfObjectsForClass:cls withPath:CBGenDatabasePath()];
}

#pragma mark Remove Object(s)

- (void)removeObject:(id)obj withPath:(NSString *)path {
    NSString *key = [self storageKeyForObject:obj];
    
    if (key) {
        [[self databaseForClass:[obj class] withPath:path] removeObjectForKey:key];
        CBSetStorageKeyToObject(nil, obj);
    }
}

- (void)removeObject:(id)obj {
    [self removeObject:obj withPath:CBGenDatabasePath()];
}

- (void)removeAllObjectsForClass:(Class)cls withPath:(NSString *)path {
    [[self databaseForClass:cls withPath:path andOptions:_defaultDatabaseOptions] removeAllObjects];
}

- (void)removeAllObjectsForClass:(Class)cls {
    [self removeAllObjectsForClass:cls withPath:CBGenDatabasePath()];
}

#pragma mark - Tool Kit

+ (NSArray *)allPropertyKeysForObject:(id)obj {
    return CBAllPropertyKeys(obj);
}

+ (BOOL)isObject:(id)obj1 similarTo:(id)obj2 {
    return CBIsObjsEquals(obj1, obj2, YES);
}

+ (BOOL)isObject:(id)obj1 equalTo:(id)obj2 {
    return CBIsObjsEquals(obj1, obj2, NO);
}

@end
