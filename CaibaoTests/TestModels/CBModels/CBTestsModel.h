//
//  CBTestsModel.h
//  Caibao
//
//  Created by Looping on 14/8/5.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBTestModel.h"
#import "CBTest3GModel.h"
#import "CBTest3GSModel.h"
#import "CBTest4Model.h"
#import "CBTest4SModel.h"
#import "CBTest5Model.h"
#import "CBTest5S_5CModel.h"

@interface CBTestsModel : NSObject <NSCoding>

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
