//
//  CBDataListView.h
//  Caibao
//
//  Created by Looping on 14/9/2.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "CBDataListView.h"

@interface CBDataListView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *rowHeaderListView;
@property (nonatomic, weak) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, weak) IBOutlet UITableView *columnHeaderListView;
@property (nonatomic, weak) IBOutlet UITableView *contentListView;
@property (nonatomic, weak) IBOutlet UILabel *columnTitleLabel;

@end

@implementation CBDataListView {
    NSArray *columnWidthsArray;
    
    NSMutableArray *columnHeaderDataArray;
    NSMutableArray *contentDataArray;
}

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    
    _cellWidth = 250.f;
    _cellHeight = 30.f;
    _rowHeaderHeight = 44.f;
    _columnHeaderWidth = 64.f;
    _separatorLineWidth = 1.f;
    _headerBGColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    _footerBGColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    _separatorLineColor = [UIColor whiteColor];
    _separatorBGColor1 = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    _separatorBGColor2 = [UIColor colorWithWhite:0.9 alpha:0.5];

    _columnHeaderListView.dataSource = self;
    _columnHeaderListView.delegate = self;
    _columnHeaderListView.showsHorizontalScrollIndicator = NO;
    _columnHeaderListView.showsVerticalScrollIndicator = NO;
    [_columnHeaderListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_columnHeaderListView setTableFooterView:[UIView new]];
    
    _rowHeaderListView.dataSource = self;
    _rowHeaderListView.delegate = self;
    _rowHeaderListView.showsHorizontalScrollIndicator = NO;
    _rowHeaderListView.showsVerticalScrollIndicator = NO;
    _rowHeaderListView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    [_rowHeaderListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_rowHeaderListView setTableFooterView:[UIView new]];

    _contentScrollView.delegate = self;
    _contentListView.dataSource = self;
    _contentListView.delegate = self;
    [_contentListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_contentListView setTableFooterView:[UIView new]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _updateView];
}

- (void)reloadData {
    [self _resetData];
    [_columnHeaderListView reloadData];
    [_contentListView reloadData];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _separatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [_separatorLineColor CGColor]);
    CGFloat x = _columnHeaderWidth + _separatorLineWidth / 2.0f;
    CGContextMoveToPoint(context, x, 0.0f);
    CGContextAddLineToPoint(context, x, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    [self _updateView];
}

#pragma mark - property

- (void)setDatasource:(id<CBDataListViewDataSource>)datasource {
    if (_datasource != datasource) {
        _datasource = datasource;
        
        [self _resetData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *target = nil;
    if (tableView == _columnHeaderListView) {
        target = _contentListView;
    }else if (tableView == _contentListView) {
        target = _columnHeaderListView;
    }else {
        target = nil;
    }
    
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if ([_delegate respondsToSelector:@selector(listView:didSelectRowAtIndexPath:)]) {
        [_delegate listView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 0;
    
    if ([_rowHeaderListView isEqual:tableView]) {
        heightForRow = [self _contentListViewCellWidth:indexPath.row] + _separatorLineWidth;
    } else {
        heightForRow = [self cellHeightInIndexPath:indexPath];
    }
    
    return heightForRow;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger numberOfSections = [self numberOfSections];
    
    if ([_rowHeaderListView isEqual:tableView]) {
        numberOfSections = 1;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numberOfRows = [self rowsInSection:section];
    
    if ([_rowHeaderListView isEqual:tableView]) {
        numberOfRows = [_datasource arrayDataForRowHeaderInListView:self].count;
    } else {
        numberOfRows = [self rowsInSection:section];
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual: _columnHeaderListView]) {
        return [self _columnHeaderListView:tableView cellForRowAtIndexPath:indexPath];
    } else if ([tableView isEqual: _contentListView]) {
        return [self _contentListView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self _rowHeaderListView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    CGPoint offset = scrollView.contentOffset;
    
    if (scrollView == _columnHeaderListView) {
        target = _contentListView;
    } else if (scrollView == _rowHeaderListView) {
        offset.x = offset.y;
        offset.y = _contentScrollView.contentOffset.y;
        target = _contentScrollView;
    } else if (scrollView == _contentListView) {
        target = _columnHeaderListView;
    } else if (scrollView == _contentScrollView) {
        offset.y = offset.x;
        offset.x = 0;
        target = _rowHeaderListView;
    }
    
    target.delegate = nil;
    target.contentOffset = offset;
    target.delegate = self;
}

#pragma mark - private method

- (void)_resetData {
    [self loadDataSourceData];
    
    _columnTitleLabel.backgroundColor = _headerBGColor;
    [self _loadColumnWidths];
}

- (void)_updateView {
    CGFloat superWidth = self.frame.size.width;
    CGFloat superHeight = self.frame.size.height;
    
    _columnTitleLabel.frame = CGRectMake(0, 0, _columnHeaderWidth, _rowHeaderHeight);
    [_columnTitleLabel setTextAlignment:NSTextAlignmentCenter];
    _rowHeaderListView.frame = CGRectMake(_columnHeaderWidth + _separatorLineWidth, 0, superWidth - _columnHeaderWidth - _separatorLineWidth, _rowHeaderHeight);
    _columnHeaderListView.frame = CGRectMake(0, _rowHeaderHeight + _separatorLineWidth, _columnHeaderWidth, superHeight - _rowHeaderHeight - _separatorLineWidth);
    _contentScrollView.frame = CGRectMake(_columnHeaderWidth + _separatorLineWidth, _rowHeaderHeight + _separatorLineWidth, superWidth - _columnHeaderWidth - _separatorLineWidth - 1, superHeight - _rowHeaderHeight - _separatorLineWidth);
    
    CGFloat width = 0.0f;
    NSUInteger count = [_datasource arrayDataForRowHeaderInListView:self].count;
    for (int i = 1; i <= count + 1; i++) {
        if (i == count + 1) {
            width += _separatorLineWidth;
        }else {
            width += _separatorLineWidth + [self _contentListViewCellWidth:i - 1];
        }
    }
    
    _rowHeaderListView.contentSize = CGSizeMake(_rowHeaderHeight, width);
    _contentScrollView.contentSize = CGSizeMake(width, superWidth - _rowHeaderHeight - _separatorLineWidth);
    _contentListView.frame = CGRectMake(0.f, -64.f, width, superHeight - _rowHeaderHeight - _separatorLineWidth);
}

- (void)_loadColumnWidths {
    NSUInteger columns = [_datasource respondsToSelector:@selector(arrayDataForRowHeaderInListView:)] ? [_datasource arrayDataForRowHeaderInListView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:nil reason:@"number of content columns must more than 0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray array];
    CGFloat widthColumn = 0.0f;
    CGFloat widthP = 0.0f;
    for (int i = 0; i < columns; i++) {
        CGFloat columnWidth = [self _contentListViewCellWidth:i];
        widthColumn += (_separatorLineWidth + columnWidth);
        widthP = widthColumn - columnWidth / 2.0f;
        [tmpAry addObject:[NSNumber numberWithFloat:widthP]];
    }
    columnWidthsArray = [tmpAry copy];
}

- (CGFloat)_contentListViewCellWidth:(NSUInteger)column {
    return [_datasource respondsToSelector:@selector(listView:contentTableCellWidth:)] ? [_datasource listView:self contentTableCellWidth:column] : _cellWidth;
}

- (UITableViewCell *)_columnHeaderListView:(UITableView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"_columnHeaderListViewCell";
    UITableViewCell *cell = [listView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat cellH = [self cellHeightInIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _columnHeaderWidth, cellH)];
    view.clipsToBounds = YES;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:view.frame];
    label.text = [[columnHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    label.center = CGPointMake(_columnHeaderWidth / 2.0f, cellH / 2.0f);
    [label setNumberOfLines:1024];
    [label setTextAlignment:NSTextAlignmentCenter];

    view.backgroundColor = indexPath.row%2 ? _separatorBGColor1 : _separatorBGColor2;
    [view.layer setMasksToBounds:YES];

    [view addSubview:label];
    
    [cell.contentView addSubview:view];
    
    cell.frame = ({ CGRect f = cell.frame; f.size.height += _separatorLineWidth; f; });
    
    return cell;
}

- (UITableViewCell *)_contentListView:(UITableView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger count = [_datasource arrayDataForRowHeaderInListView:self].count;
    static NSString *cellID = @"_contentListViewCell";
    UITableViewCell *cell = [listView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray *ary = [[contentDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    for (int i = 0; i < count; i++) {
        CGFloat cellW = [self _contentListViewCellWidth:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        CGFloat width = [[columnWidthsArray objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW - _separatorLineWidth, cellH)];
        view.center = CGPointMake(width, cellH / 2.0f);
        view.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
        [label setNumberOfLines:1024];
        label.text = [NSString stringWithFormat:@"%@", [ary objectAtIndex:i]];
        label.center = CGPointMake(cellW / 2.0f, cellH / 2.0f);
        [label setTextAlignment:NSTextAlignmentCenter];
        
        view.backgroundColor = indexPath.row%2 ? _separatorBGColor1 : _separatorBGColor2;

        [view addSubview:label];
        
        [cell.contentView addSubview:view];
    }
    
    cell.frame = ({ CGRect f = cell.frame; f.size.height += _separatorLineWidth; f; });

    return cell;
}

- (UITableViewCell *)_rowHeaderListView:(UITableView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"_rowHeaderListViewCell";
    UITableViewCell *cell = [listView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_separatorLineWidth, 212.f, [self _contentListViewCellWidth:indexPath.row] - _separatorLineWidth, _rowHeaderHeight)];
        [label setTag:101];
        [label setNumberOfLines:1024];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.backgroundColor = _headerBGColor;

        [cell.contentView addSubview:label];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    ((UILabel *)[cell.contentView viewWithTag:101]).text = [[_datasource arrayDataForRowHeaderInListView:self] objectAtIndex:indexPath.row];
        
    return cell;
}

#pragma mark - other method

- (NSUInteger)rowsInSection:(NSUInteger)section {
    return [[columnHeaderDataArray objectAtIndex:section] count];
}

- (NSUInteger)numberOfSections {
    NSUInteger sections = [_datasource respondsToSelector:@selector(numberOfSectionsInListView:)] ? [_datasource numberOfSectionsInListView:self] : 1;
    return sections < 1 ? 1 : sections;
}

- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath {
    return [_datasource respondsToSelector:@selector(listView:cellHeightInRow:InSection:)] ? [_datasource listView:self cellHeightInRow:indexPath.row InSection:indexPath.section] : _cellHeight;
}

- (void)loadDataSourceData {
    columnHeaderDataArray = [NSMutableArray array];
    contentDataArray = [NSMutableArray array];
    
    NSUInteger sections = [_datasource numberOfSectionsInListView:self];
    for (int i = 0; i < sections; i++) {
        [columnHeaderDataArray addObject:[_datasource arrayDataForColumnHeaderInListView:self InSection:i]];
        [contentDataArray addObject:[_datasource arrayDataForContentInListView:self InSection:i]];
    }
}

@end
