//
//  NSJSONSerializationPerformanceTests.m
//  Caibao
//
//  Created by Looping on 14/8/14.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PerformanceTests.h"

//#define USINGMTLTESTSMODEL

@interface NSJSONSerializationPerformanceTests : XCTestCase

#ifdef USINGMTLTESTSMODEL
@property (nonatomic) MTTestModel *test;
@property (nonatomic) MTTest3GModel *test3g;
@property (nonatomic) MTTest3GSModel *test3gs;
@property (nonatomic) MTTest4Model *test4;
@property (nonatomic) MTTest4SModel *test4s;
@property (nonatomic) MTTest5Model *test5;
@property (nonatomic) MTTest5S_5CModel *test5s_5c;
@property (nonatomic) MTTestsModel *tests;
#else
@property (nonatomic) JMTestModel *test;
@property (nonatomic)  JMTest3GModel *test3g;
@property (nonatomic)  JMTest3GSModel *test3gs;
@property (nonatomic)  JMTest4Model *test4;
@property (nonatomic)  JMTest4SModel *test4s;
@property (nonatomic)  JMTest5Model *test5;
@property (nonatomic)  JMTest5S_5CModel *test5s_5c;
@property (nonatomic)  JMTestsModel *tests;
#endif

@end

@implementation NSJSONSerializationPerformanceTests

- (void)setUp {
    [super setUp];

    [[[CBStorageManager sharedManager] databaseForClass:[JMTestsModel class]] setEncoder: ^NSData * (LevelDBKey * key, id object) {
#ifdef USINGMTLTESTSMODEL
        return [NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:object] options:0 error:nil];
#else
        return [NSJSONSerialization dataWithJSONObject:[(JMTestsModel *)object toDictionary] options:0 error:nil];
#endif
    }];
    
    [[[CBStorageManager sharedManager] databaseForClass:[JMTestsModel class]] setDecoder: ^id (LevelDBKey * key, id data) {
#ifdef USINGMTLTESTSMODEL
        return [[MTTestsModel alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] error:nil];
#else
        return [[JMTestsModel alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] error:nil];
#endif
    }];
    
    [self configTestsData];
}

- (void)tearDown {
    [[CBStorageManager sharedManager] deleteAllDatabasesInCurrentPath];
    [super tearDown];
}

- (void)testPerformance {
    
}

#ifdef USINGMTLTESTSMODEL
- (void)configTestsData {
    NSLog(@"Preparing test data");
    
    if ( !_tests) {
        _test = [[MTTestModel alloc] init];
        _test3g = [[MTTest3GModel alloc] init];
        _test3gs = [[MTTest3GSModel alloc] init];
        _test4 = [[MTTest4Model alloc] init];
        _test4s = [[MTTest4SModel alloc] init];
        _test5 = [[MTTest5Model alloc] init];
        _test5s_5c = [[MTTest5S_5CModel alloc] init];
        _tests = [[MTTestsModel alloc] init];
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
//        [_tests.test5 addObject:_test5];
        [_tests.test5s_5c addObject:_test5s_5c];
    }
}

#if __clang_major__ >= 6

- (void)testParseObjectPerformance {
    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:_tests];
    NSLog(@"%@", dict);
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    NSLog(@"Start measure testing");
    NSLog(@"%d", data.length);
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            _tests = [[MTTestsModel alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] error:nil];
//            NSLog(@"%@", _tests);
        }
    }];
}

- (void)testWriteObjectPerformance {
    NSLog(@"Start measure testing");

    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [_tests cb_save];
//            NSLog(@"saved %@ \nwith key %@", _tests, _tests.cb_storageKey);
        }
    }];
}

- (void)testReadObjectPerformance {
    [_tests cb_save];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            _tests = [MTTestsModel cb_instance];
//            NSLog(@"instance %@", _tests);
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
    
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[MTTestsModel class]]);
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
    
    MTTestsModel *checker = [MTTestsModel new];
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
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[MTTestsModel class]]);
    [self measureBlock:^{
        NSInteger count = [[checker cb_similarObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}
#endif

#else
- (void)configTestsData {
    NSLog(@"Preparing test data");
    
    if ( !_tests) {
        _test = [[JMTestModel alloc] init];
        _test3g = [[JMTest3GModel alloc] init];
        _test3gs = [[JMTest3GSModel alloc] init];
        _test4 = [[JMTest4Model alloc] init];
        _test4s = [[JMTest4SModel alloc] init];
        _test5 = [[JMTest5Model alloc] init];
        _test5s_5c = [[JMTest5S_5CModel alloc] init];
        _tests = [[JMTestsModel alloc] init];
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
    NSDictionary *dict = [_tests toDictionary];
    NSLog(@"%@", dict);
    __block NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"Start measure testing");
    NSLog(@"%d", data.length);
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            _tests = [[JMTestsModel alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] error:nil];
//            NSLog(@"%@", _tests);
        }
    }];
}

- (void)testWriteObjectPerformance {
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [_tests cb_save];
            [_tests cb_removeStorageKey];
//                        NSLog(@"saved %@ \nwith key %@", _tests, _tests.cb_storageKey);
        }
    }];
}

- (void)testReadObjectPerformance {
    [_tests cb_save];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [JMTestsModel cb_instance];
//                        NSLog(@"instance %@", [JMTestsModel cb_instance]);
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
    
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[JMTestsModel class]]);
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
    
    JMTestsModel *checker = [JMTestsModel new];
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
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[JMTestsModel class]]);
    [self measureBlock:^{
        NSInteger count = [[checker cb_similarObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}
#endif
#endif
@end
