//
//  CaibaoLogicalTests.m
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CBTestsModel.h"
#import "Caibao.h"


#define CBALLTESTSOBJECTSCOUNT 17
#define CBALLCUSTOMOBJECTSCOUNT 8
#define CBALLFOUNDATIONOBJECTSCOUNT 9

@interface CaibaoLogicalTests : XCTestCase

@property (nonatomic) CBTestModel *test;
@property (nonatomic) CBTest3GModel *test3g;
@property (nonatomic) CBTest3GSModel *test3gs;
@property (nonatomic) CBTest4Model *test4;
@property (nonatomic) CBTest4SModel *test4s;
@property (nonatomic) CBTest5Model *test5;
@property (nonatomic) CBTest5S_5CModel *test5s_5c;
@property (nonatomic) CBTestsModel *tests;

@end

@implementation CaibaoLogicalTests

- (void)setUp {
    [super setUp];
    
    _test = [[CBTestModel alloc] init];
    _test3g = [[CBTest3GModel alloc] init];
    _test3gs = [[CBTest3GSModel alloc] init];
    _test4 = [[CBTest4Model alloc] init];
    _test4s = [[CBTest4SModel alloc] init];
    _test5 = [[CBTest5Model alloc] init];
    _test5s_5c = [[CBTest5S_5CModel alloc] init];
    _tests = [[CBTestsModel alloc] init];
}

- (void)tearDown {
    [[CBStorageManager sharedManager] deleteAllDatabasesInCurrentPath];
    
    [super tearDown];
}

- (void)testLogical {
    
}

#pragma mark - Common

- (void)saveTestObject:(id)obj {
    [[CBStorageManager sharedManager] saveObject:obj];
}

- (NSString *)storageKeyForObject:(id)obj {
    return [[CBStorageManager sharedManager] storageKeyForObject:obj];
}

- (id)objectForClass:(Class)cls {
    return [[CBStorageManager sharedManager] objectForClass:cls];
}

- (void)removeAllObjectsForClass:(Class)cls {
    [[CBStorageManager sharedManager] removeAllObjectsForClass:[cls class]];
}

- (void)writeAllCustomObjects {
    [self saveTestObject: _test];
    [self saveTestObject: _test3g];
    [self saveTestObject: _test3gs];
    [self saveTestObject: _test4];
    [self saveTestObject: _test4s];
    [self saveTestObject: _test5];
    [self saveTestObject: _test5s_5c];
    [self saveTestObject: _tests];
}

- (void)writeAllObjects {
    [self writeAllCustomObjects];
}

#pragma mark - StorageManager Tests

- (void)testStorageManagerSharedInstance {
    CBStorageManager *manager = [CBStorageManager sharedManager];
    
    XCTAssert([[CBStorageManager sharedManager] isEqual:manager], @"testStorageManagerSharedInstance");
}

- (void)testSaveObject {
    [self saveTestObject:_test];
    
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = _test.name;
    obj.age = _test.age;
    
    XCTAssert([self storageKeyForObject:obj] == nil, @"testSaveObject");
    
    [self saveTestObject:obj];

    XCTAssert( ![[self storageKeyForObject:obj] isEqualToString:[self storageKeyForObject:_test]], @"testSaveObject");

    CBTestModel *recover = [[[CBStorageManager sharedManager] databaseForClass:[CBTestModel class]] objectForKey:[self storageKeyForObject:obj]];
    
    [[CBStorageManager sharedManager] updateStorageKey:[self storageKeyForObject:obj] forObject:recover];
    
    XCTAssert([recover.name isEqualToString:_test.name], @"testSaveObject");
    
    obj.name = @"updated";
    
    [self saveTestObject:obj];

    XCTAssert([[self storageKeyForObject:obj] isEqualToString:[self storageKeyForObject:recover]], @"testSaveObject");
}

- (void)testFindDuplicateObject {
    NSString *string = @"Caibao";
    [string cb_save];
    
    NSArray *keys = [string cb_duplicateObjectKeys];
    XCTAssert([[self storageKeyForObject:string] isEqualToString:keys[0]], @"testFindDuplicateObject");
    
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = @"";
    obj.age = _test.age;
    [self saveTestObject:obj];
    
    CBTestModel *obj2 = [[CBTestModel alloc] init];
    obj2.name = _test.name;
    obj2.age = _test.age;
    [self saveTestObject:obj2];
    NSString *key = [self storageKeyForObject:obj2];
    
    CBTestModel *obj3 = [[CBTestModel alloc] init];
    obj3.name = @"Caibao";
    obj3.age = _test.age;
    [self saveTestObject:obj3];
    
    
    keys = [[CBStorageManager sharedManager] allKeysForDuplicateObject:_test];

    XCTAssert([key isEqualToString:keys[0]], @"testFindDuplicateObject");
    
    [string cb_removeFromDatabase];
    [obj cb_removeFromDatabase];
    [obj2 cb_removeFromDatabase];
    [obj3 cb_removeFromDatabase];
}

- (void)testFindSimilarObject {
    NSString *string = @"Caibao";

    [self saveTestObject:string];
    
    NSArray *keys = [string cb_similarObjectKeys];
    XCTAssert([[self storageKeyForObject:string] isEqualToString:keys[0]], @"testFindSimilarObject");
    
    
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = @"";
    obj.age = _test.age;
    [self saveTestObject:obj];
    
    CBTestModel *obj2 = [[CBTestModel alloc] init];
    obj2.name = _test.name;
    obj2.age = _test.age;
    [self saveTestObject:obj2];
    
    CBTestModel *obj3 = [[CBTestModel alloc] init];
    obj3.name = @"Caibao";
    obj3.age = _test.age;
    [self saveTestObject:obj3];
    
    CBTestModel *obj4 = [[CBTestModel alloc] init];
    obj4.name = @"Caibao";
    obj4.age = 1;
    [self saveTestObject:obj4];

    keys = [[CBStorageManager sharedManager] allKeysForSimilarObject:_test];
    XCTAssert([keys count] == 1, @"testFindSimilarObject");

    _test.name = nil;
    keys = [[CBStorageManager sharedManager] allKeysForSimilarObject:_test];
    XCTAssert([keys count] == 3, @"testFindSimilarObject");

    _test.name = @"Caibao";
    keys = [[CBStorageManager sharedManager] allKeysForSimilarObject:_test];
    XCTAssert([keys count] == 1, @"testFindSimilarObject");

    _test.name = nil;
    _test.age = 1;
    keys = [[CBStorageManager sharedManager] allKeysForSimilarObject:_test];
    XCTAssert([keys count] == 1, @"testFindSimilarObject");
}

- (void)testRemoveAllObjectsForClass {
    [self saveTestObject:_test];
    
    XCTAssert([[[CBStorageManager sharedManager] allObjectsForClass:[CBTestModel class]] count], @"testRemoveAllObjectsForClass");
    
    [self removeAllObjectsForClass:[_test class]];
    
    XCTAssert( ![[CBStorageManager sharedManager] countOfObjectsForClass:[CBTestModel class]], @"testRemoveAllObjectsForClass");
}

- (void)testCountOfObjectsForClass {
    [self saveTestObject:_test];
    
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = @"";
    obj.age = _test.age;
    [self saveTestObject:obj];
    
    CBTestModel *obj2 = [[CBTestModel alloc] init];
    obj2.name = _test.name;
    obj2.age = _test.age;
    [self saveTestObject:obj2];
    
    CBTestModel *obj3 = [[CBTestModel alloc] init];
    obj3.name = @"Caibao";
    obj3.age = _test.age;
    [self saveTestObject:obj3];
    
    CBTestModel *obj4 = [[CBTestModel alloc] init];
    obj4.name = _test.name;
    obj4.age = 0;
    [self saveTestObject:obj4];

    XCTAssert([[CBStorageManager sharedManager] countOfObjectsForClass:[CBTestModel class]] == 5, @"testAllObjectsForClass");
}

- (void)testInstanceWithCount {
    [self saveTestObject:_test];
    
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = @"";
    obj.age = _test.age;
    [self saveTestObject:obj];
    
    CBTestModel *obj2 = [[CBTestModel alloc] init];
    obj2.name = _test.name;
    obj2.age = _test.age;
    [self saveTestObject:obj2];
    
    CBTestModel *obj3 = [[CBTestModel alloc] init];
    obj3.name = @"Caibao";
    obj3.age = _test.age;
    [self saveTestObject:obj3];
    
    CBTestModel *obj4 = [[CBTestModel alloc] init];
    obj4.name = _test.name;
    obj4.age = 0;
    [self saveTestObject:obj4];

    XCTAssert([[[CBStorageManager sharedManager] objectsForClass:[CBTestModel class] withCount:2] count] == 2, @"testInstanceWithCount");
}

- (void)testSaveObjects {
    CBTestsModel *ltests = [CBTestsModel new];
    ltests.name = @"Caibao";
    
    for (NSInteger index = 0 ; index < 100; index ++) {
        [ltests.test addObject:_test];
    }
    
    [ltests cb_save];
    
    [[CBStorageManager sharedManager] saveObjects:ltests.test];
    
    for (id obj in ltests.test) {
        id obj2 = [[[CBStorageManager sharedManager] databaseForClass:[obj class]] objectForKey:[self storageKeyForObject:obj]];
        XCTAssert([obj isEqual:obj2], @"testSaveObjects");
    }
}

- (void)testRemoveFromDatabase {
    [self saveTestObject:_test];
    
    XCTAssert([[_test cb_duplicateObjectKeys] count] == 1, @"testRemoveFromDatabase");

    [[CBStorageManager sharedManager] removeObject:_test];
    
    XCTAssert([[_test cb_duplicateObjectKeys] count] == 0, @"testRemoveFromDatabase");

}

#pragma mark - Catagory Tests
- (void)testSaveObjectUsingCatagory {
    CBTestModel *obj = [[CBTestModel alloc] init];
    obj.name = _test.name;
    obj.age = _test.age;
    XCTAssert([obj cb_storageKey] == nil, @"testSaveObjectWithoutUsingManager");

    [obj cb_save];
    
    CBTestModel *recover = [CBTestModel cb_instance];
    
    XCTAssert([recover.name isEqualToString:_test.name], @"testSaveObjectWithoutUsingManager");
    
    XCTAssert([recover.cb_storageKey isEqualToString:obj.cb_storageKey], @"testSaveObjectWithoutUsingManager");
}

@end
