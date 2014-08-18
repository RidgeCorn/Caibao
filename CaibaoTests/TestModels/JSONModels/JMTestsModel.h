//
//  JMTestsModel.h
//  Caibao
//
//  Created by Looping on 14/8/5.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMTestModel.h"
#import "JMTest3GModel.h"
#import "JMTest3GSModel.h"
#import "JMTest4Model.h"
#import "JMTest4SModel.h"
#import "JMTest5Model.h"
#import "JMTest5S_5CModel.h"

@interface JMTestsModel : JSONModel

@property (nonatomic) NSString <Index> *name;
@property (nonatomic) NSInteger age;

@property (nonatomic) NSMutableArray <JMTestModel> *test;
@property (nonatomic) NSMutableArray <JMTest3GModel> *test3g;
@property (nonatomic) NSMutableArray <JMTest3GSModel> *test3gs;
@property (nonatomic) NSMutableArray <JMTest4Model> *test4;
@property (nonatomic) NSMutableArray <JMTest4SModel> *test4s;
@property (nonatomic) NSMutableArray <JMTest5Model> *test5;
@property (nonatomic) NSMutableArray <JMTest5S_5CModel> *test5s_5c;

@end
