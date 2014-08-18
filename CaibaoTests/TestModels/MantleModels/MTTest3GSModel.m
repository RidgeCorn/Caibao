//
//  MTTestModel.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "MTTest3GSModel.h"

@implementation MTTest3GSModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

- (instancetype)init {
    if (self = [super init]) {
        _name = NSStringFromClass([self class]);
        _age = 0;
    }
    
    return self;
}

@end
