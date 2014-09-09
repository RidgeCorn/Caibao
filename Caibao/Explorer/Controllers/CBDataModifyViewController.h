//
//  CBDataModifyViewController.h
//  Caibao
//
//  Created by Looping on 14/9/2.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CBSaveModifiedObjectBlock)(id object);

@interface CBDataModifyViewController : UIViewController
@property (nonatomic, copy) CBSaveModifiedObjectBlock saveValueBlock;

- (instancetype)initWithObject:(id)object name:(NSString *)name;

@end
