//
//  MultiTableView.h
//  OPX
//
//  Created by inxs tech on 13/07/14.
//  Copyright (c) 2014
//

#import <UIKit/UIKit.h>
#define kScrollBaseViewTag 1000
#define kScrollViewTag (kScrollBaseViewTag + 500)
#define kTableViewTag (kScrollViewTag + 500)
#define kScrollViewLeftIndicatorTag (kTableViewTag + 500)
#define kScrollViewRightIndicatorTag (kScrollViewLeftIndicatorTag + 500)
#define kTableHeaderTag (kScrollViewRightIndicatorTag + 500)


typedef NS_ENUM(NSInteger, UITableViewColumnScrollPosition) {
    UITableViewColumnScrollPositionNone,
    UITableViewColumnScrollPositionLeft,
    UITableViewColumnScrollPositionRight,
};                // scroll so row of interest is compl

@class MultiTableView;

@protocol MultiTableViewDelegate <NSObject>

- (BOOL)multiTableVerticalScrollIndicatorForColumn:(NSInteger)column;
- (CGFloat)multiTableWidth:(CGFloat)width widthForColumn:(NSInteger)column;
- (CGFloat)multiTableContentWidth:(CGFloat)width widthForContent:(NSInteger)column;
- (UIView *)multiTableView:(MultiTableView *)tableView viewForHeader:(NSInteger)column;
- (CGFloat)multiTableView:(MultiTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath ofColumn:(NSInteger)column;

@optional
- (void)multiTableView:(MultiTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withColumn:(NSInteger)column WithView:(UIView*)row;
- (CGFloat)heightForFooterInMultiTableView:(MultiTableView*) multiTableView;
- (UIView *)multiTableView:(MultiTableView *)tableView viewForHeaderInSection:(NSInteger)section withCol:(NSInteger)col;
- (CGFloat)multiTableView:(MultiTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)multiTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section withCol:(NSInteger)col;
- (CGFloat)multiTableView:(MultiTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)footerViewForMultiTableView:(MultiTableView*) mutliTableView;
- (void)multiTableDidScroll;
@end

@protocol MultiTableViewDataSource <NSObject>
@optional
- (NSInteger)numberOfSectionsInTableView:(MultiTableView *)tableView;
- (void)multiTableView:(MultiTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withColumn:(NSInteger)column;
@required
- (NSInteger)multiTableView:(MultiTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)multiTableView:(MultiTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withCol:(NSInteger)column;
@end

@protocol PullToRefreshDelegate <NSObject>
@optional
-(void)performPullToRefreshOperation;
-(void)performLoadMoreOperation;
@end

@interface MultiTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *emptyMessage;
@property(nonatomic, weak)id<MultiTableViewDataSource>dataSource;
@property(nonatomic, weak)id<MultiTableViewDelegate>delegate;
@property (nonatomic, strong) UIView *bgView;

@property int rowIDForCenterTable;
@property BOOL isFromChainsPage;
@property BOOL isIdeaHubListView;
- (instancetype)initWithFrame:(CGRect)frame withCols:(NSInteger)cols;
- (void)reloadData;
- (void)reframeBaseViews;
- (NSArray *)visibleCells;
- (NSArray *)visibleCellsForColom:(int)colom;
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToColumn:(NSInteger)col atScrollPosition:(UITableViewColumnScrollPosition)scrollPosition animated:(BOOL)animated;
- (UIView *)reuseHeaderForColoumn:(NSUInteger)coloumn;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation forcolum:(int)colom;
- (void)reloadRow:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forcolum:(int)colom;
- (id)initWithFrame:(CGRect)frame withCols:(NSInteger)cols withSeperatorStyle:(UITableViewCellSeparatorStyle)seperatorStyle;
//Pull to refresh
@property (nonatomic, weak) id <PullToRefreshDelegate> pullToRefreshDelegate;
@property (nonatomic) BOOL restrictPullToRefresh;
-(void)pullToRefreshCompleted;
- (void)scrollEnabled:(BOOL)enabled;
- (UITableView *)tableForColumn:(NSInteger)column;
@end
