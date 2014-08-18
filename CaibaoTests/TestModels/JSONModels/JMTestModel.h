//
//  JMTestModel.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JSONModel.h"

@protocol JMTestModel

@end

@interface JMTestModel : JSONModel

@property (nonatomic) NSString <Index> *name;
@property (nonatomic)NSInteger age;

@end
