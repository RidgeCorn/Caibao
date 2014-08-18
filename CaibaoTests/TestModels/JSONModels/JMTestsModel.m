//
//  JMTestsModel.m
//  Caibao
//
//  Created by Looping on 14/8/5.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JMTestsModel.h"
#import "Caibao.h"

@implementation JMTestsModel

- (instancetype)init {
    if (self = [super init]) {
        _name = NSStringFromClass([self class]);
        _age = 0;
        
        _test = [@[] mutableCopy];
        
        _test3g = [@[] mutableCopy];
        
        _test3gs = [@[] mutableCopy];
        
        _test4 = [@[] mutableCopy];
        
        _test4s = [@[] mutableCopy];
        
        _test5 = [@[] mutableCopy];
        
        _test5s_5c = [@[] mutableCopy];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self cb_initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self cb_encodeWithCoder:aCoder];
}

@end
