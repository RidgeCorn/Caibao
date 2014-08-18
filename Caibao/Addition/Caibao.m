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

+ (NSArray *)cb_instanceWithCount:(NSInteger)count {
    return [StorageManager objectsForClass:[self class] withCount:count];
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

- (NSArray *)cb_allPropertyKeys {
    return [CBStorageManager allPropertyKeysForObject:self];
}

#pragma mark - NSCoding

- (id)cb_initWithCoder:(NSCoder *)aDecoder {
    if (self) {
        for (NSString *propertyKey in [self cb_allPropertyKeys]) {
            [self setValue:[aDecoder decodeObjectForKey:propertyKey] forKeyPath:propertyKey];
        }
    } else {
        NSAssert(NO, @"Please call [super init] first!");
    }
    
    return self;
}

- (void)cb_encodeWithCoder:(NSCoder *)aCoder {
    for (NSString *propertyKey in [self cb_allPropertyKeys]) {
        [aCoder encodeObject:[self valueForKeyPath:propertyKey] forKey:propertyKey];
    }
}

@end
