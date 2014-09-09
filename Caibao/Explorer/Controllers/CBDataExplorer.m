//
//  CBDataExplorer.m
//  Caibao
//
//  Created by Looping on 14/8/25.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDataExplorer.h"
#import "CBStorageManager.h"
#import "CBDataListsViewController.h"

@interface CBDataExplorer () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSDictionary *databases;
@property (nonatomic) NSArray *paths;

@end

@implementation CBDataExplorer

- (instancetype)initWithDatabases:(NSDictionary *)databases {
    if (self = [super init]) {
        _databases = databases;
        _paths = [databases allKeys];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"Data Explorer"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
#ifdef DEBUG
    CGRect frame = self.view.frame;

    _tableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
#endif

    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        buttonItem;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _paths ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _paths.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CBDatabasesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( !cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *path = _paths[indexPath.row];
    LevelDB *ldb = [_databases objectForKey:path];
    
    [cell.textLabel setText:ldb.name];
    [cell.detailTextLabel setText:path];
    [cell.detailTextLabel setNumberOfLines:1024];
    
    return cell ? : [UITableViewCell new];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LevelDB *ldb = [_databases objectForKey:_paths[indexPath.row]];

    [self.navigationController pushViewController:[[CBDataListsViewController alloc] initWithDatabaseName:ldb.name] animated:YES];
}

#pragma mark - Dismiss

-(void)dismiss {    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
