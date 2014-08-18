//
//  MTTest5S_5CModel.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "MTLModel.h"
#import <MTLJSONAdapter.h>

@interface MTTest5S_5CModel : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *name;
@property (nonatomic)NSInteger age;

@end
