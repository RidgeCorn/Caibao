//
//  CBDataModifyTableViewController.m
//  Caibao
//
//  Created by Looping on 14/9/2.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "Caibao.h"
#import "CBDataModifyViewController.h"

@interface CBDataModifyViewController ()

@property (nonatomic) id object;
@property (nonatomic) id modifiedValue;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *attribute;
@property (nonatomic) Class objectClass;

@end

@implementation CBDataModifyViewController

- (instancetype)initWithObject:(id)object name:(NSString *)name attribute:(NSString *)attribute {
    if (self = [super init]) {
        _object = object;
        _name = name;
        _attribute = attribute;
        NSString *tmpAttriName = [_attribute componentsSeparatedByString:@","][0];
        
        if ([tmpAttriName hasPrefix:@"T@"]) {
            _objectClass = NSClassFromString([tmpAttriName substringWithRange:NSMakeRange(3, [tmpAttriName length]-4)]);
        }
        
        if ( !_object && _objectClass) {
            _object = [[_objectClass alloc] init];
            
            if ( !_object) {
                if ([_objectClass instancesRespondToSelector:@selector(initWithString:)]) {
                    _object = [[_objectClass alloc] initWithString:@""];
                } else if ([_objectClass instancesRespondToSelector:@selector(initWithBool:)]) {
                    _object = [[_objectClass alloc] initWithBool:NO];
                }
            }
        }
        
        _modifiedValue = _object;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"Modify %@", _name]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([_object isKindOfClass:[NSString class]] || [_object isKindOfClass:[NSNumber class]] || [_object isKindOfClass:[NSURL class]]) {
        [self.view addSubview:({
            CGRect frame = self.view.frame;
            
            frame.size.height /= 2;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:frame];
            [textView setText:[CBStorageManager descriptionForObject:_object withAttribute:_attribute]];
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
            [notSupportLabel setText:[NSString stringWithFormat:@"%@\n\nModify this object (%@) is currently \nNOT SUPPORT.", [_object class], _object]];
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
    } else if ([_object isKindOfClass:[NSNumber class]]) {
        NSString *tmpAttriName = [_attribute componentsSeparatedByString:@","][0];
        NSString *typeName = @"";
        if ( ![tmpAttriName hasPrefix:@"T@"]) {
            typeName = [tmpAttriName substringWithRange:NSMakeRange(1, [tmpAttriName length]-1)];
        }
        NSString *text = ((UITextView *)[self.view viewWithTag:10000]).text;
        if ([typeName isEqualToString:@"i"] || [typeName isEqualToString:@"s"] || [typeName isEqualToString:@"l"] || [typeName isEqualToString:@"I"] || [typeName isEqualToString:@"S"] || [typeName isEqualToString:@"L"]) {
            _modifiedValue = @([text integerValue]);
        } else if ([typeName isEqualToString:@"q"] || [typeName isEqualToString:@"Q"]) {
            _modifiedValue = @([text longLongValue]);
        } else if ([typeName isEqualToString:@"f"]) {
            _modifiedValue = @([text floatValue]);
        } else if ([typeName isEqualToString:@"d"]) {
            _modifiedValue = @([text doubleValue]);
        } else if ([typeName isEqualToString:@"B"]) {
            _modifiedValue = @([text boolValue]);
        } else if ([typeName isEqualToString:@"c"] || [typeName isEqualToString:@"C"]) {
            _modifiedValue = @([text characterAtIndex:0]);
        }
    } else if ([_object isKindOfClass:[NSURL class]]) {
        _modifiedValue = [NSURL URLWithString:((UITextView *)[self.view viewWithTag:10000]).text];
    } else if ([_object isKindOfClass:[NSDate class]]) {
        _modifiedValue = ((UIDatePicker *)[self.view viewWithTag:10001]).date;
    }

    if (_saveValueBlock) {
        _saveValueBlock(_modifiedValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
