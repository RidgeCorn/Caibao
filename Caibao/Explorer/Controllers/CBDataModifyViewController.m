//
//  CBDataModifyTableViewController.m
//  Caibao
//
//  Created by Looping on 14/9/2.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDataModifyViewController.h"

@interface CBDataModifyViewController ()

@property (nonatomic) id object;
@property (nonatomic) id modifiedValue;
@property (nonatomic) NSString *name;

@end

@implementation CBDataModifyViewController

- (instancetype)initWithObject:(id)object name:(NSString *)name {
    if (self = [super init]) {
        _object = object;
        _modifiedValue = _object;
        _name = name;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"Modify %@", _name]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([_object isKindOfClass:[NSString class]]) {
        [self.view addSubview:({
            CGRect frame = self.view.frame;
            
            frame.size.height /= 2;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:frame];
            [textView setText:_object];
            [textView setTag:10000];
            [textView becomeFirstResponder];
            
            textView;
        })];
    } else if ([_object isKindOfClass:[NSDate class]]) {
        [self.view addSubview:({
            CGRect frame = self.view.frame;
            frame.origin.y += 125.f;
        
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
            
            [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            [datePicker setDate:_object];
            [datePicker setTag:10001];
            
            datePicker;
        })];
    } else {
        [self.view addSubview:({
            CGRect frame = self.view.frame;
            
            frame.size.height /= 2;
            
            UILabel *notSupportLabel = [[UILabel alloc] initWithFrame:frame];
            [notSupportLabel setText:[NSString stringWithFormat:@"%@\n\nModify this object is currently \nNOT SUPPORT.", _object]];
            [notSupportLabel setNumberOfLines:1024];
            [notSupportLabel setEnabled:NO];
            [notSupportLabel setTextAlignment:NSTextAlignmentCenter];
            
            notSupportLabel;
        })];
    }
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveValue)];
        buttonItem;
    });
}

#pragma mark - Save Value

- (void)saveValue {
    [self.view endEditing:YES];
    
    if ([_object isKindOfClass:[NSString class]]) {
        _modifiedValue = ((UITextView *)[self.view viewWithTag:10000]).text;
    } else if ([_object isKindOfClass:[NSDate class]]) {
        _modifiedValue = ((UIDatePicker *)[self.view viewWithTag:10001]).date;
    }

    if (_saveValueBlock) {
        _saveValueBlock(_modifiedValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
