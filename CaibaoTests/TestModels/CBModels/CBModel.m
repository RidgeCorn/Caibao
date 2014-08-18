//
//  CBModel.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBModel.h"
#import "Caibao.h"

@implementation CBModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self = [super init] cb_initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self cb_encodeWithCoder:aCoder];
}

- (BOOL)isEqual:(id)object {
    return [self cb_isEqual:object];
}

- (BOOL)isSimilar:(id)object {
    return [self cb_isSimilar:object];
}

@end
