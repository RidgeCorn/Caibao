//
//  MTTest5S_5CModel.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "MTTest5S_5CModel.h"

@implementation MTTest5S_5CModel

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
