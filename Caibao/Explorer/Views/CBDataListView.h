//
//  CBDataListView.h
//  Caibao
//
//  Created by Looping on 14/9/2.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBDataListViewDataSource;
@protocol CBDataListViewDelegate;

@interface CBDataListView : UIView

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat rowHeaderHeight;
@property (nonatomic, assign) CGFloat columnHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat separatorLineWidth;
@property (nonatomic, strong) UIColor *headerBGColor;
@property (nonatomic, strong) UIColor *footerBGColor;
@property (nonatomic, strong) UIColor *separatorLineColor;
@property (nonatomic, strong) UIColor *separatorBGColor1;
@property (nonatomic, strong) UIColor *separatorBGColor2;

@property (nonatomic, weak) id<CBDataListViewDataSource> datasource;
@property (nonatomic, weak) id<CBDataListViewDelegate> delegate;

+ (instancetype)instance;

- (void)updateFrame:(CGRect)frame;
- (void)reloadData;

@end

@protocol CBDataListViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForRowHeaderInListView:(CBDataListView *)listView;
- (NSArray *)arrayDataForColumnHeaderInListView:(CBDataListView *)listView InSection:(NSUInteger)section;
- (NSArray *)arrayDataForContentInListView:(CBDataListView *)listView InSection:(NSUInteger)section;

@optional
- (NSUInteger)numberOfSectionsInListView:(CBDataListView *)listView;
- (CGFloat)listView:(CBDataListView *)listView contentTableCellWidth:(NSUInteger)column;
- (CGFloat)listView:(CBDataListView *)listView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (CGFloat)rowHeaderHeightInListView:(CBDataListView *)listView;

@end

@protocol CBDataListViewDelegate <NSObject>

- (void)listView:(CBDataListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
