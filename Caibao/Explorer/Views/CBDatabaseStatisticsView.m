//
//  CBDatabaseStatisticsView.m
//  Caibao
//
//  Created by Looping on 14/9/3.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDatabaseStatisticsView.h"

@interface CBDatabaseStatisticsView ()

@property (nonatomic, weak) IBOutlet UILabel *rowCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *columnCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *sizeCountLabel;

@end

@implementation CBDatabaseStatisticsView

+ (instancetype)instance {    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
}

- (void)displayWithModel:(StatisticModel *)statistic {
    [_rowCountLabel setText:[@(statistic.rowCount) stringValue]];
    [_columnCountLabel setText:[@(statistic.columnCount) stringValue]];
    [_sizeCountLabel setText:[[@(statistic.sizeCount) stringValue] stringByAppendingString:@" B"]];
}

@end
