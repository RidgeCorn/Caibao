//
//  CBDataExplorer.h
//  Caibao
//
//  Created by Looping on 14/8/25.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBDataExplorer : UIViewController

- (instancetype)initWithDatabases:(NSDictionary *)databases;

+ (void)showExplorer;

@end
