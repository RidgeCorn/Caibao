//
//  CBDataDetailViewController.h
//  Caibao
//
//  Created by Looping on 14/9/1.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CBUpdateObjectBlock)(id object);

@interface CBDataDetailViewController : UIViewController
@property (nonatomic, copy) CBUpdateObjectBlock updateObjectBlock;

- (instancetype)initWithObject:(id)object;

@end
