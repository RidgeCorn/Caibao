//
//  JMTest5Model.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JSONModel.h"

@protocol JMTest5Model

@end

@interface JMTest5Model : JSONModel

@property (nonatomic) NSString <Index> *name;
@property (nonatomic)NSInteger age;

@end
