//
//  CBDatabaseStatisticsView.h
//  Caibao
//
//  Created by Looping on 14/9/3.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticModel.h"

@interface CBDatabaseStatisticsView : UIView

+ (instancetype)instance;

- (void)displayWithModel:(StatisticModel *)statistic;

@end
