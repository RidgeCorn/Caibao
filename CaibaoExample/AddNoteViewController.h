//
//  AddNoteViewController.h
//  Caibao
//
//  Created by Looping on 14/8/10.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

typedef void(^SaveNoteBlock)(id object);

@interface AddNoteViewController : UIViewController
@property (nonatomic, copy) SaveNoteBlock saveNoteBlock;

- (instancetype)initWithNote:(Note *)note;

@end
