//
//  CBDataDetailViewController.m
//  Caibao
//
//  Created by Looping on 14/9/1.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDataDetailViewController.h"
#import "CBStorageManager.h"
#import "CBDataModifyViewController.h"

@interface CBDataDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) id object;
@property (nonatomic) NSArray *properties;

@end

@implementation CBDataDetailViewController

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _object = object;
        _properties = [CBStorageManager allPropertyKeysForObject:_object];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:[NSString stringWithFormat:@"%@: %@", NSStringFromClass([_object class]), [[CBStorageManager sharedManager] storageKeyForObject:_object]]];
    
    CGRect frame = self.view.frame;
    
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];

    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _properties ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _properties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CBDataDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *key = _properties[indexPath.row];
    
    [cell.textLabel setText:key];
    [cell.detailTextLabel setText:[[_object valueForKeyPath:key] description]];
    
    return cell ? : [UITableViewCell new];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _properties[indexPath.row];
    CBDataModifyViewController *modifyController = [[CBDataModifyViewController alloc] initWithObject:[_object valueForKeyPath:key] name:key];
    
    [modifyController setSaveValueBlock:^(id value) {
        [_object setValue:value forKeyPath:key];
        [[CBStorageManager sharedManager] saveObject:_object];
        
        if (_updateObjectBlock) {
            _updateObjectBlock(_object);
        }
    }];
    
    [self.navigationController pushViewController:modifyController animated:YES];
}

@end
