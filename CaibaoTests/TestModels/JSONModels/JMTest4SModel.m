//
//  JMTest4SModel.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JMTest4SModel.h"

@implementation JMTest4SModel

- (instancetype)init {
    if (self = [super init]) {
        _name = NSStringFromClass([self class]);
        _age = 0;
    }
    
    return self;
}

@end
