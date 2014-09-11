//
//  CBStorageManager.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LevelDB.h>

@interface CBStorageManager : NSObject

@property (nonatomic, readonly, getter = databasePath) NSString *databasePath; // Default is "NSCachesDirectory()/com.ridgecorn.CaibaoStorage.default"
@property (nonatomic, getter = databaseDirectory, setter = setDatabaseDirectory:) NSString *databaseDirectory; // Default is "NSCachesDirectory()"
@property (nonatomic, getter = databaseGroupName, setter = setDatabaseGroupName:) NSString *databaseGroupName; // Default is "com.ridgecorn.CaibaoStorage.default"
@property (nonatomic, getter = databaseOptions, setter = setDatabaseOptions:) LevelDBOptions _defaultDatabaseOptions; // Default using [LevelDB makeOptions]


+ (instancetype)sharedManager;


- (LevelDB *)databaseForClass:(Class)cls withPath:(NSString *)path andOptions:(LevelDBOptions)opts;
- (LevelDB *)databaseForClass:(Class)cls withPath:(NSString *)path;
- (LevelDB *)databaseForClass:(Class)cls;


- (void)closeDatabaseForClass:(Class)cls withPath:(NSString *)path;
- (void)closeDatabaseForClass:(Class)cls;
- (void)closeAllDatabases;


- (void)saveObject:(id)obj withPath:(NSString *)path;
- (void)saveObject:(id)obj;
- (void)saveObjectsWithPaths:(NSDictionary *)objsWithPaths;
- (void)saveObjects:(NSArray *)objs;


- (NSArray *)allKeysForClass:(Class)cls withPath:(NSString *)path filteredByPredicate:(NSPredicate *)predicate;
- (NSArray *)allKeysForClass:(Class)cls withPath:(NSString *)path;
- (NSArray *)allKeysForClass:(Class)cls;

- (NSString *)storageKeyForObject:(id)obj;
- (void)updateStorageKey:(NSString *)key forObject:(id)obj;
- (void)removeStorageKeyForObject:(id)obj;


- (void)deleteAllDatabasesInPath:(NSString *)path;
- (void)deleteDatabaseForClass:(Class)cls inPath:(NSString *)path;
- (void)deleteAllDatabasesInCurrentPath;


- (NSArray *)objectsForClass:(Class)cls withCount:(NSInteger)count;
- (id)objectForClass:(Class)cls;
- (NSArray *)allObjectsForClass:(Class)cls;


- (NSArray *)allKeysForDuplicateObject:(id)obj withPath:(NSString *)path;
- (NSArray *)allKeysForDuplicateObject:(id)obj;

- (NSArray *)allKeysForSimilarObject:(id)obj withPath:(NSString *)path;
- (NSArray *)allKeysForSimilarObject:(id)obj;

- (NSInteger)countOfObjectsForClass:(Class)cls withPath:(NSString *)path;
- (NSInteger)countOfObjectsForClass:(Class)cls;

- (void)removeObject:(id)obj withPath:(NSString *)path;
- (void)removeObject:(id)obj;
- (void)removeAllObjectsForClass:(Class)cls withPath:(NSString *)path;
- (void)removeAllObjectsForClass:(Class)cls;


+ (NSDictionary *)allPropertiesForObject:(id)obj;
+ (BOOL)isObject:(id)obj1 equalTo:(id)obj2;
+ (BOOL)isObject:(id)obj1 similarTo:(id)obj2;

- (void)showExplorer;

@end
