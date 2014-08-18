//
//  ExampleTableViewController.m
//  Caibao
//
//  Created by Looping on 14/8/10.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "AddNoteViewController.h"
#import <FLEXManager.h>
#import "Caibao.h"
#import "Note.h"

@interface ExampleTableViewController ()

@property (nonatomic) NSMutableArray *notes;

@end

@implementation ExampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Caibao Example"];
    
    [self.tableView setTableFooterView:[UIView new]];

    [self.navigationItem setLeftBarButtonItem:({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"FLEX" style:UIBarButtonItemStylePlain target:self action:@selector(openFLEX)];
        buttonItem;
    })];
    
    [self.navigationItem setRightBarButtonItem:({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNote:)];
        buttonItem;
    })];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNotes];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NoteCell";
    UITableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( !noteCell) {
        noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    Note *note = [_notes objectAtIndex:indexPath.row];
    
    [noteCell.textLabel setText:note.content];
    
    [noteCell.detailTextLabel setText:[({NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"MM-dd hh:mm:ss"]; formatter;}) stringFromDate:note.date]];
    
    return noteCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self addNote:[_notes objectAtIndex:indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [_notes objectAtIndex:indexPath.row];

    [note cb_removeFromDatabase];

    [_notes removeObject:note];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark - load notes

- (void)loadNotes {
    _notes = [[[CBStorageManager sharedManager] allObjectsForClass:[Note class]] mutableCopy];
    
    _notes = [[_notes sortedArrayUsingComparator:^NSComparisonResult(Note *note1, Note *note2) {
        return [note1.date timeIntervalSince1970] < [note2.date timeIntervalSince1970];
    }] mutableCopy];
}

#pragma mark - add note

- (void)addNote:(Note *)note {
    if ( ![note isKindOfClass:[Note class]]) {
        note = nil;
    }
    
    AddNoteViewController *controller = [[AddNoteViewController alloc] initWithNote:note];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
}

#pragma mark - Flex debug
- (void)openFLEX {
    [[FLEXManager sharedManager] showExplorer];
}

@end
