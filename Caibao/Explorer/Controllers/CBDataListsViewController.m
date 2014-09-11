//
//  CBDataListsViewController.m
//  Caibao
//
//  Created by Looping on 14/9/1.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDataListsViewController.h"
#import "CBStorageManager.h"
#import "CBDataListView.h"
#import "CBDataDetailViewController.h"
#import "CBDatabaseStatisticsView.h"

#define CBDataExplorerStatisticsViewHeight 64.f

@interface CBDataListsViewController () <CBDataListViewDataSource, CBDataListViewDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *properties;
@property (nonatomic) NSMutableArray *objectIDs;
@property (nonatomic) NSMutableArray *objectValues;
@property (nonatomic) CBDataListView *listView;
@property (nonatomic) NSArray *objects;
@property (nonatomic) BOOL reloadData;
@property (nonatomic) CBDatabaseStatisticsView *statisticsView;

@end

@implementation CBDataListsViewController

- (instancetype)initWithDatabaseName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        _reloadData = NO;
        [self loadData];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:_name];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self loadListView];
    
    [self loadStatisticsView];
}

- (void)loadListView {
    CGRect frame = self.view.frame;
    
    frame.origin.y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    frame.size.height -= frame.origin.y + CBDataExplorerStatisticsViewHeight;
    
    _listView = [CBDataListView instance];
    [_listView updateFrame:frame];
    [self.view addSubview:_listView];
    _listView.datasource = self;
    _listView.delegate = self;
}

- (void)loadStatisticsView {
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

    frame.origin.y += _listView.frame.size.height;
    frame.size.height = CBDataExplorerStatisticsViewHeight;
    
    _statisticsView = [CBDatabaseStatisticsView instance];
    [_statisticsView setFrame:frame];
    
    StatisticModel *statistic = [StatisticModel new];
    
    NSString *folderPath = [CBStorageManager sharedManager].databasePath;
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    statistic.rowCount = _objectIDs.count;
    statistic.columnCount = _properties.count;
    statistic.sizeCount = fileSize;
    
    [_statisticsView displayWithModel:statistic];
    
    [self.view addSubview:_statisticsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_reloadData) {
        _reloadData = NO;
        [self loadData];
    }
    
    if (_listView) {
        [_listView reloadData];
    }
}

- (void)loadData {
    _objects = [[CBStorageManager sharedManager] allObjectsForClass:NSClassFromString(_name)];
    
    _properties = [CBStorageManager allPropertiesForObject:[NSClassFromString(_name) new]];
    
    _objectIDs = [@[] mutableCopy];
    
    _objectValues = [@[] mutableCopy];
    
    NSMutableArray *values = [@[] mutableCopy];
        
    for (id object in _objects) {
        [_objectIDs addObject:[@([[[[CBStorageManager sharedManager] storageKeyForObject:object] componentsSeparatedByString:@"_"][1] integerValue]) stringValue]];
        
        values = [@[] mutableCopy];
        
        for (NSString *property in _properties) {
            [values addObject:[object valueForKeyPath:property] ?: @""];
        }
        
        [_objectValues addObject:values];
    }
}

#pragma mark - Table View Data Source

- (NSUInteger)numberOfSectionsInListView:(CBDataListView *)listView {
    return _objectIDs ? 1 : 0;
}

- (CGFloat)listView:(CBDataListView *)listView contentTableCellWidth:(NSUInteger)column {
    return 200.f;
}

- (CGFloat)listView:(CBDataListView *)listView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    return 64.f;
}

- (NSArray *)arrayDataForRowHeaderInListView:(CBDataListView *)listView {
    return [_properties allKeys] ?: @[];
}

- (NSArray *)arrayDataForColumnHeaderInListView:(CBDataListView *)listView InSection:(NSUInteger)section {
    return _objectIDs ?: @[];
}

- (NSArray *)arrayDataForContentInListView:(CBDataListView *)listView InSection:(NSUInteger)section {
    return _objectValues ?: @[];
}

#pragma mark - Table View Delegate

- (void)listView:(CBDataListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBDataDetailViewController *detailController = [[CBDataDetailViewController alloc] initWithObject:_objects[indexPath.row]];
    [detailController setUpdateObjectBlock:^(id object) {
        _reloadData = YES;
    }];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

@end
