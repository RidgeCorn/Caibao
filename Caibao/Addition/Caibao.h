//
//  Caibao.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBStorageManager.h"

@interface NSObject (Caibao)

+ (instancetype)cb_instance;
+ (NSArray *)cb_instanceWithCount:(NSInteger)count;

- (void)cb_save;

- (NSString *)cb_storageKey;
- (void)cb_updateStorageKey:(NSString *)key;
- (void)cb_removeStorageKey;

- (NSArray *)cb_duplicateObjectKeys;
- (NSArray *)cb_similarObjectKeys;

- (BOOL)cb_isEqual:(id)object;
- (BOOL)cb_isSimilar:(id)object;

- (void)cb_removeFromDatabase;

- (id)cb_initWithCoder:(NSCoder *)aDecoder;
- (void)cb_encodeWithCoder:(NSCoder *)aCoder;

- (NSString *)cb_descriptionForProperty:(NSDictionary *)property;

@end
