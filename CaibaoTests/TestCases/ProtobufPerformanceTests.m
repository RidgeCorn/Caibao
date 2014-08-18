//
//  ProtobufPerformanceTests.m
//  Caibao
//
//  Created by Looping on 14/8/14.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PerformanceTests.h"

@interface ProtobufPerformanceTests : XCTestCase

@property (nonatomic) TestsBuilder *pbTestsBuilder;

@end

@implementation ProtobufPerformanceTests

- (void)setUp {
    [super setUp];
    [[[CBStorageManager sharedManager] databaseForClass:[Tests class]] setEncoder: ^NSData * (LevelDBKey * key, id object) {
        return ((Tests *)object).data;
    }];
    
    [[[CBStorageManager sharedManager] databaseForClass:[Tests class]] setDecoder: ^id (LevelDBKey * key, id data) {
        return [Tests parseFromData:data];
    }];
    
    [self configTestsData];
}

- (void)tearDown {
//    [[CBStorageManager sharedManager] deleteAllDatabasesInCurrentPath];
    [super tearDown];
}

- (void)testPerformance {
    
}

- (void)configTestsData {
    NSLog(@"Preparing test data");

    if ( !_pbTestsBuilder) {
        _pbTestsBuilder = [Tests builder];
        [_pbTestsBuilder setName:@"Caibao"];
        [_pbTestsBuilder setAge:[[NSDate date] timeIntervalSince1970]];
    }
    
    ///
    TestsTestBuilder *testbuilder = [TestsTest builder];
    [testbuilder setName:@"test"];
    [testbuilder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest *test = [testbuilder build];
    
    TestsTest3GBuilder *test3gBuilder = [TestsTest3G builder];
    [test3gBuilder setName:@"test3g"];
    [test3gBuilder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest3G *test3g = [test3gBuilder build];
    
    TestsTest3GSBuilder *test3gsBuilder = [TestsTest3GS builder];
    [test3gsBuilder setName:@"test3gs"];
    [test3gsBuilder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest3GS *test3gs = [test3gsBuilder build];
    
    TestsTest4Builder *test4Builder = [TestsTest4 builder];
    [test4Builder setName:@"test4"];
    [test4Builder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest4 *test4 = [test4Builder build];
    
    TestsTest4SBuilder *test4sBuilder = [TestsTest4S builder];
    [test4sBuilder setName:@"test4s"];
    [test4sBuilder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest4S *test4s = [test4sBuilder build];
    
    TestsTest5Builder *test5Builder = [TestsTest5 builder];
    [test5Builder setName:@"test5"];
    [test5Builder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest5 *test5 = [test5Builder build];
    
    TestsTest5S_5CBuilder *test5s5cBuilder = [TestsTest5S_5C builder];
    [test5s5cBuilder setName:@"test5s5c"];
    [test5s5cBuilder setAge:[[NSDate date] timeIntervalSince1970]];
    TestsTest5S_5C *test5s5c = [test5s5cBuilder build];
    
    ///
    
    for (NSInteger index = 0; index < CBTESTOBJECTSIZE; index ++) {
        [_pbTestsBuilder addTest:test];
        [_pbTestsBuilder addTest3G:test3g];
        [_pbTestsBuilder addTest3Gs:test3gs];
        [_pbTestsBuilder addTest4:test4];
        [_pbTestsBuilder addTest4S:test4s];
        [_pbTestsBuilder addTest5:test5];
        [_pbTestsBuilder addTest5S5C:test5s5c];
    }
}


#if __clang_major__ >= 6

- (void)testParseObjectPerformance {
    Tests *tests = [_pbTestsBuilder build];
    NSLog(@"%@", [tests dictionaryWithValuesForKeys:[CBStorageManager allPropertyKeysForObject:tests]]);

    __block NSData *data = tests.data;
    
    NSLog(@"Start measure testing");
    NSLog(@"%d", data.length);
    
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [Tests parseFromData:data];
        }
    }];
}

- (void)testWriteObjectPerformance {
    __block Tests *tests = [_pbTestsBuilder build];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [tests cb_save];
            [tests cb_removeStorageKey];
            //            NSLog(@"saved %@ \nwith key %@", tests, tests.cb_storageKey);
        }
    }];
}

- (void)testReadObjectPerformance {
    Tests *tests = [_pbTestsBuilder build];
    
    [tests cb_save];
    
    NSLog(@"Start measure testing");
    [self measureBlock:^{
        for (NSInteger index = 0; index < CBTESTOBJECTSCOUNT; index ++) {
            [Tests cb_instance];
            //            NSLog(@"instance %@", [Tests cb_instance]);
        }
    }];
}

- (void)testFindDuplicateObjectPerformance {
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        TestsBuilder * builder = [_pbTestsBuilder clone];
        [builder setName:[@(times) stringValue]];
        Tests *tests = [builder build];
        [tests cb_save];
    }
    
    Tests *tests = [_pbTestsBuilder build];
    
    [tests cb_save];
    
    NSLog(@"Start measure testing");
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[tests class]]);
    [self measureBlock:^{
        NSInteger count = [[tests cb_duplicateObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}

- (void)testFindSimilarObjectPerformance {
    for (NSInteger times = CBTESTOBJECTSCOUNT; times > 0; times --) {
        TestsBuilder * builder = [_pbTestsBuilder clone];
        //        [builder setName:[@(times) stringValue]];
        Tests *tests = [builder build];
        [tests cb_save];
    }
    
    TestsBuilder * builder = [_pbTestsBuilder clone];
    
    Tests *tests = [builder build];
    
    [tests cb_save];
    
    NSLog(@"Start measure testing");
    NSLog(@"With object count %d", [[CBStorageManager sharedManager] countOfObjectsForClass:[tests class]]);
    [builder clear];
    [builder setName:_pbTestsBuilder.name];
    [builder setAge:_pbTestsBuilder.age];
    tests = [builder build];
    
    [self measureBlock:^{
        NSInteger count = [[tests cb_similarObjectKeys] count];
        NSLog(@"%d found", count);
    }];
}
#endif

@end
