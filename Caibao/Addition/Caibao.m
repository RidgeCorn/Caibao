//
//  Caibao.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "Caibao.h"

#define StorageManager [CBStorageManager sharedManager]

@implementation NSObject (Caibao)

+ (instancetype)cb_instance {
    return [StorageManager objectForClass:[self class]];
}

+ (instancetype)cb_instanceWithKey:(NSString *)key {
    return [StorageManager objectForClass:[self class] withKey:key];
}

+ (NSArray *)cb_instancesWithCount:(NSInteger)count {
    return [StorageManager objectsForClass:[self class] withCount:count];
}

+ (NSArray *)cb_instancesWithKeys:(NSArray *)keys {
    return [StorageManager objectsForClass:[self class] withKeys:keys];
}

- (void)cb_save {
    [StorageManager saveObject:self];
}

- (NSString *)cb_storageKey {
    return [StorageManager storageKeyForObject:self];
}

- (void)cb_updateStorageKey:(NSString *)key {
    [StorageManager updateStorageKey:key forObject:self];
}

- (void)cb_removeStorageKey {
    [StorageManager removeStorageKeyForObject:self];
}

- (void)cb_removeFromDatabase {
    [StorageManager removeObject:self];
}

- (NSArray *)cb_duplicateObjectKeys {
    return [StorageManager allKeysForDuplicateObject:self];
}

- (NSArray *)cb_similarObjectKeys {
    return [StorageManager allKeysForSimilarObject:self];
}

#pragma mark -
- (BOOL)cb_isEqual:(id)object {
    return [CBStorageManager isObject:self equalTo:object];
}

- (BOOL)cb_isSimilar:(id)object {
    return [CBStorageManager isObject:self similarTo:object];
}

- (NSDictionary *)cb_allProperties {
    return [CBStorageManager allPropertiesForObject:self];
}

#pragma mark - NSCoding

- (id)cb_initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        for (NSString *propertyKey in [[self cb_allProperties] allKeys]) {
            @try {
                [self setValue:[aDecoder decodeObjectForKey:propertyKey] forKeyPath:propertyKey];
            }
            @catch (NSException *exception) {
                [self setValue:@(false) forKeyPath:propertyKey];
            }
        }
    } else {
        NSAssert(NO, @"Please call [super init] first!");
    }
    
    return self;
}

- (void)cb_encodeWithCoder:(NSCoder *)aCoder {
    for (NSString *propertyKey in [[self cb_allProperties] allKeys]) {
        [aCoder encodeObject:[self valueForKeyPath:propertyKey] forKey:propertyKey];
    }
}

#pragma mark - Description

- (NSString *)cb_descriptionForProperty:(NSDictionary *)property {
    NSString *description = [self description];
    
    if (property && [property count] > 0) {
        NSString *key = [property allKeys][0];        
        description = [CBStorageManager descriptionForObject:[self valueForKeyPath:key] withAttribute:[property valueForKey:key]];
    }
    
    return description;
}

@end
