//
//  NSKeyedArchiverPerformanceTests.m
//  Caibao
//
//  Created by Looping on 14/8/14.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PerformanceTests.h"

@interface NSKeyedArchiverPerformanceTests : XCTestCase

@property (nonatomic) CBTestModel *test;
@property (nonatomic) CBTest3GModel *test3g;
@property (nonatomic) CBTest3GSModel *test3gs;
@property (nonatomic) CBTest4Model *test4;
@property (nonatomic) CBTest4SModel *test4s;
@property (nonatomic) CBTest5Model *test5;
@property (nonatomic) CBTest5S_5CModel *test5s_5c;
@property (nonatomic) CBTestsModel *tests;

@end

@implementation NSKeyedArchiverPerformanceTests

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

- (void)testParseObjectPerformance {
    NSLog(@"%@", [_tests dictionaryWithValuesForKeys:[CBStorageManager allPropertyKeysForObject:_tests]]);
    __block NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_tests];
    
    NSLog(@"Start measure testing");
    NSLog(@"%d", data.length);
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }];
}

- (void)testWriteObjectPerformance {
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [_tests cb_save];
            [_tests cb_removeStorageKey];
            //            NSLog(@"saved %@ \nwith key %@", ptests, ptests.cb_storageKey);
        }
    }];
}

- (void)testReadObjectPerformance {
    [_tests cb_save];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [CBTestsModel cb_instance];
            //            NSLog(@"instance %@", [CBTestsModel cb_instance]);
        }
    }];
}

- (void)testFindDuplicateObjectPerformance {
    [_tests cb_save];
    
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        [_tests setAge:times];
        [_tests cb_removeStorageKey];
        [_tests cb_save];
    }
    
    NSLog(@"Start measure testing");
    
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[CBTestsModel class]]);
    [self measureBlock:^{
        NSInteger count = [[_tests cb_duplicateObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}

- (void)testFindSimilarObjectPerformance {
    [_tests cb_save];
    
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        [_tests setName:[@(times) stringValue]];
        [_tests cb_removeStorageKey];
        [_tests cb_save];
    }
    
    CBTestsModel *checker = [CBTestsModel new];
    checker.age = _tests.age;
    checker.name = nil;
    checker.test = nil;
    checker.test3g = nil;
    checker.test3gs = nil;
    checker.test4 = nil;
    checker.test4s = nil;
    checker.test5 = nil;
    checker.test5s_5c = nil;
    
    NSLog(@"Start measure testing");
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[CBTestsModel class]]);
    [self measureBlock:^{
        NSInteger count = [[checker cb_similarObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}
#endif


@end
