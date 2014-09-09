//
//  AddNoteViewController.m
//  Caibao
//
//  Created by Looping on 14/8/10.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "AddNoteViewController.h"
#import "Caibao.h"

@interface AddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic) Note *note;

@end

@implementation AddNoteViewController

- (instancetype)initWithNote:(Note *)note {
    if (self = [super init]) {
        _note = note;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_note) {
        [self setTitle:@"Update Note"];
    } else {
        [self setTitle:@"Add Note"];
    }

    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        buttonItem;
    });
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveNote)];
        buttonItem;
    });
    
    if (_note && _note.content) {
        [_noteTextView setText:_note.content];
    }
    
    [_noteTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveNote {
    if ( !_note) {
        _note = [Note new];
    }

    _note.content = _noteTextView.text;
    _note.date = [NSDate date];
    
    [_note cb_save];
    
    if (_saveNoteBlock) {
        _saveNoteBlock(_note);
    }
    
    [self dismiss];
}

@end
