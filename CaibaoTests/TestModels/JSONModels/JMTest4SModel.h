//
//  JMTest4SModel.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JSONModel.h"

@protocol JMTest4SModel

@end

@interface JMTest4SModel : JSONModel

@property (nonatomic) NSString <Index> *name;
@property (nonatomic)NSInteger age;

@end
