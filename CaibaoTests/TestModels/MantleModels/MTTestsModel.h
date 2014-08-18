//
//  MTTestsModel.h
//  Caibao
//
//  Created by Looping on 14/8/5.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MTLJSONAdapter.h>
#import "MTTestModel.h"
#import "MTTest3GModel.h"
#import "MTTest3GSModel.h"
#import "MTTest4Model.h"
#import "MTTest4SModel.h"
#import "MTTest5Model.h"
#import "MTTest5S_5CModel.h"

@interface MTTestsModel : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *name;
@property (nonatomic)NSInteger age;

@property (nonatomic) NSMutableArray *test;
@property (nonatomic) NSMutableArray *test3g;
@property (nonatomic) NSMutableArray *test3gs;
@property (nonatomic) NSMutableArray *test4;
@property (nonatomic) NSMutableArray *test4s;
@property (nonatomic) NSMutableArray *test5;
@property (nonatomic) NSMutableArray *test5s_5c;

@end
