//
//  JMTest4Model.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JMTest4Model.h"

@implementation JMTest4Model

- (instancetype)init {
    if (self = [super init]) {
        _name = NSStringFromClass([self class]);
        _age = 0;
    }
    
    return self;
}

@end
