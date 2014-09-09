//
//  CaibaoPerformanceTests.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Caibao.h"
#import "CBTestsModel.h"

#define CBTESTOBJECTSCOUNT 10000
#define CBTESTOBJECTSIZE 1


@interface CaibaoPerformanceTests : XCTestCase

@property (nonatomic) CBTestModel *test;
@property (nonatomic) CBTest3GModel *test3g;
@property (nonatomic) CBTest3GSModel *test3gs;
@property (nonatomic) CBTest4Model *test4;
@property (nonatomic) CBTest4SModel *test4s;
@property (nonatomic) CBTest5Model *test5;
@property (nonatomic) CBTest5S_5CModel *test5s_5c;
@property (nonatomic) CBTestsModel *tests;
@property (nonatomic) NSString *string;
@property (nonatomic) NSData *data;

@end

@implementation CaibaoPerformanceTests

- (void)setUp {
    [super setUp];
    
    [self configTestsData];
}

- (void)tearDown {
    [[CBStorageManager sharedManager] deleteAllDatabasesInCurrentPath];

    [super tearDown];
}

- (void)testPerformance {
    
}

- (void)configTestsData {
    NSLog(@"Preparing test data");
    
    _string = @"Caibao";
    
    _data = [_string dataUsingEncoding:NSUTF8StringEncoding];
    
    if ( !_tests) {
        _test = [[CBTestModel alloc] init];
        _test3g = [[CBTest3GModel alloc] init];
        _test3gs = [[CBTest3GSModel alloc] init];
        _test4 = [[CBTest4Model alloc] init];
        _test4s = [[CBTest4SModel alloc] init];
        _test5 = [[CBTest5Model alloc] init];
        _test5s_5c = [[CBTest5S_5CModel alloc] init];
        _tests = [[CBTestsModel alloc] init];
    }
    
    [_tests.test removeAllObjects];
    [_tests.test3g removeAllObjects];
    [_tests.test3gs removeAllObjects];
    [_tests.test4 removeAllObjects];
    [_tests.test4s removeAllObjects];
    [_tests.test5 removeAllObjects];
    [_tests.test5s_5c removeAllObjects];
    
    for (NSInteger index = 0 ; index < CBTESTOBJECTSIZE; index ++) {
        [_tests.test addObject:_test];
        [_tests.test3g addObject:_test3g];
        [_tests.test3gs addObject:_test3gs];
        [_tests.test4 addObject:_test4];
        [_tests.test4s addObject:_test4s];
        [_tests.test5 addObject:_test5];
        [_tests.test5s_5c addObject:_test5s_5c];
    }
}

#if __clang_major__ >= 6

- (void)testOpenDatabasePerformance {
    [[CBStorageManager sharedManager] closeAllDatabases];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        [[CBStorageManager sharedManager] databaseForClass:[CBTestModel class]];
    }];
}

- (void)testCloseDatabasePerformance {
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        [[CBStorageManager sharedManager] closeDatabaseForClass:[CBTestModel class]];
    }];
}

- (void)testWriteObjectPerformance {
    NSLog(@"Start measure testing");
    
    [self measureBlock:^{
        for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
            [_data cb_save];
        }
    }];
}

- (void)testReadObjectPerformance {
    [_data cb_save];

    NSLog(@"Start measure testing");
    
    [self measureBlock:^{
        for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
            [[_data class] cb_instance];
        }
    }];
}

- (void)testObjectsCountPerformance {
    [_data cb_save];
    
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        _data = [[@(times) stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        [_data cb_removeStorageKey];
        [_data cb_save];
    }
    
    NSLog(@"Start measure testing");
    
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[_data class]]);
    [self measureBlock:^{
        NSInteger count = [[CBStorageManager sharedManager] countOfObjectsForClass:[_data class]];
        NSLog(@"%d found", count);
    }];
}

- (void)testFindAllObjectsPerformance {
    [_data cb_save];
    
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        _data = [[@(times) stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        [_data cb_removeStorageKey];
        [_data cb_save];
    }
    
    NSLog(@"Start measure testing");
    
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[_data class]]);
    [self measureBlock:^{
        NSInteger count = [[[CBStorageManager sharedManager] allKeysForClass:[_data class]] count];
        NSLog(@"%d found", count);
    }];
}

#endif

@end
