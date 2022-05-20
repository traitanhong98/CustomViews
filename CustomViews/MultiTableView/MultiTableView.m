//
//  MultiTableView.m
//  OPX
//
//  Created by inxs tech on 13/07/14.
//  Copyright (c) 2014 
//

#import "MultiTableView.h"
#import "ThemeSpinner.h"

#define kPullToRefreshPercentage 0.05
#define kDefaultAnimationDuration 0.4
#define KSpinnerSize 40


@interface MultiTableView ()
@property (nonatomic, assign) NSInteger noOfCols;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, assign) CGFloat footerHeight;

//********** Pull to refresh ***** //

@property (nonatomic) int scrollBeginOffsetY;
@property (nonatomic) int previousOffsetY;
@property (nonatomic) int maxPullToRefreshorigin;
@property (nonatomic) BOOL shoulAllowPullToRefresh;
@property (nonatomic) BOOL isRefreshCallFired;
@property (nonatomic, strong) UIView *animatingView;

//*********************************//

- (UITableView *)tableForColumn:(NSInteger)column;
@end
@implementation MultiTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withCols:(NSInteger)cols withSeperatorStyle:(UITableViewCellSeparatorStyle)seperatorStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.noOfCols = cols;
        // Initialization code
        self.emptyMessage = @"";
        self.isFromChainsPage = NO;
        
        self.isIdeaHubListView=NO;
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        
        self.backgroundColor = [UIColor clearColor];
        CGSize size = CGSizeZero;
        CGFloat headerHeight = 0.0;
        self.animatingView = [[ThemeSpinner alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-KSpinnerSize)/2, 0, KSpinnerSize, KSpinnerSize)];
        [self.bgView addSubview:self.animatingView];
        
        for (int column=0; column < self.noOfCols; column++)
        {
            headerHeight = 0.0;
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(column*lroundf(self.bounds.size.width/self.noOfCols), 0,lroundf(self.bounds.size.width/self.noOfCols), self.bounds.size.height)];
            
            scrollView.tag = kScrollViewTag + column;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.bounces = NO;
            scrollView.directionalLockEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
            scrollView.delegate = self;
            
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, headerHeight, size.width, size.height - headerHeight)];
            table.showsHorizontalScrollIndicator = NO;
            table.showsVerticalScrollIndicator = NO;
            table.tag = kTableViewTag + column;
            table.delegate = self;
            table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            table.dataSource = self;
            table.autoresizesSubviews = YES;
            table.separatorStyle=seperatorStyle;
            table.backgroundColor = [UIColor clearColor];
            table.accessibilityLabel = @"table";
            table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [scrollView addSubview:table];
            [self.bgView addSubview:scrollView];
            table.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
            if (@available(iOS 15.0, *)) {
                [table setSectionHeaderTopPadding:0.0f];
            }
        }
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withCols:(NSInteger)cols
{
    return  [self initWithFrame:frame withCols:cols withSeperatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)scrollEnabled:(BOOL)enabled {
    for (int column=0; column < self.noOfCols; column++)
    {
        UIScrollView *scrollView = [self viewWithTag:kScrollViewTag+column];
        //scrollView.scrollEnabled = NO;
        
        UITableView *tableView = [scrollView viewWithTag:kTableViewTag+column];
        tableView.alwaysBounceVertical = enabled;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    for (int column=0; column < self.noOfCols; column++) {
        UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:kScrollViewTag + column];
        UITableView *table = (UITableView*)[scrollView viewWithTag:kTableViewTag + column];
        UIView *headerView = [self.delegate multiTableView:self viewForHeader:column];
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, scrollView.frame.size.height-headerView.frame.size.height);
    }
}

- (void)reframeBaseViews {
    float preWidth = 0.0;
    CGRect frame = CGRectZero;
    CGSize size = CGSizeZero;
    float headerHeight = 0.0;
    
    
    for (int column=0; column < self.noOfCols; column++)
    {
        headerHeight = 0.0;
        UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:kScrollViewTag + column];
        //Reset frame
        if (column > 0) {
            preWidth += ((UIScrollView*)[self viewWithTag:kScrollViewTag + (column-1)]).frame.size.width;
        }
        frame = scrollView.frame;
        if ([self.delegate respondsToSelector:@selector(multiTableWidth:widthForColumn:)]) {
            frame.size.width = roundf([self.delegate multiTableWidth:self.bounds.size.width widthForColumn:column]);
            frame.origin.x = preWidth;
        }
        scrollView.frame = frame;
        
        //Reset Vertical indicator frame
        UIImageView *imgViewLeft = (UIImageView *)[self viewWithTag:kScrollViewLeftIndicatorTag + column];
        UIImageView *imgViewRight = (UIImageView *)[self viewWithTag:kScrollViewRightIndicatorTag + column];
        
        
        if ([self.delegate respondsToSelector:@selector(multiTableVerticalScrollIndicatorForColumn:)])
        {
            if ([self.delegate multiTableVerticalScrollIndicatorForColumn:column] == NO)
            {
                [imgViewLeft removeFromSuperview];
                [imgViewRight removeFromSuperview];
            }
            else
            {
                imgViewLeft.center = CGPointMake(scrollView.frame.origin.x + 10, 16);
                imgViewRight.center = CGPointMake((scrollView.frame.origin.x  + scrollView.frame.size.width) - 10, 16);
            }
        }
        else
        {
            [imgViewLeft removeFromSuperview];
            [imgViewRight removeFromSuperview];
        }
        
        //Reset content size
        size = frame.size;
        scrollView.contentSize = size;
        if ([self.delegate respondsToSelector:@selector(multiTableContentWidth:widthForContent:)]) {
            size.width = [self.delegate multiTableContentWidth:scrollView.contentSize.width widthForContent:column];
        }
        
        CGSize conSize = size;
        conSize.height = 0;
        scrollView.contentSize = conSize;
//        scrollView.userInteractionEnabled = NO;
        
        if ([self.delegate respondsToSelector:@selector(multiTableView:viewForHeader:)]) {
            UIView *headerView = [self.delegate multiTableView:self viewForHeader:column];
            UIView *lastHeaderView = [self viewWithTag:kTableHeaderTag+column];
            if (lastHeaderView) {
                [lastHeaderView removeFromSuperview];
            }
            headerView.tag = kTableHeaderTag+column;
            headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            frame = headerView.frame;
            frame.size.width = scrollView.contentSize.width;
            headerView.frame = frame;
            [scrollView addSubview:headerView];
            headerHeight = headerView.bounds.size.height;
        }
        
        //Reset Table Frame
        UITableView *table = (UITableView *)[scrollView viewWithTag:kTableViewTag+column];
        table.frame = CGRectMake(0, headerHeight, size.width, size.height - headerHeight);
    }
}

- (void)setDelegate:(id<MultiTableViewDelegate>)aDelegate
{
    _delegate = aDelegate;
    [self reframeBaseViews];
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    
    return YES;
}

#pragma mark Catagory Instances methods
- (UITableView *)tableForColumn:(NSInteger)column
{
    UITableView *table = (UITableView *)[[self viewWithTag:kScrollViewTag + column] viewWithTag:kTableViewTag + column];
    return table;
}

#pragma mark Instances methods
- (UIView *)reuseHeaderForColoumn:(NSUInteger)coloumn
{
     UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag + coloumn];
    
    return [scrollView viewWithTag:kTableHeaderTag+coloumn];
}


- (NSArray *)visibleCells
{
    UITableView *table = (UITableView *)[self tableForColumn:0];
    return [table visibleCells];
}
- (NSArray *)visibleCellsForColom:(int)colom
{
    UITableView *table = (UITableView *)[self tableForColumn:colom];
    return [table visibleCells];
}
- (void)reloadData {
    /** Footer Addition **/
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *scrollOffsets = [NSMutableArray array];
        for (int column=0; column < self.noOfCols; column++)
        {
            UIScrollView *scroll = (UIScrollView *)[self viewWithTag:kScrollViewTag + column] ;
            [scrollOffsets addObject:[NSValue valueWithCGPoint:scroll.contentOffset]];
            
        }
        
        [self.footerView removeFromSuperview];
        self.footerHeight=0;
        if([self.delegate respondsToSelector:@selector(heightForFooterInMultiTableView:)])
        {
            self.footerHeight=[self.delegate heightForFooterInMultiTableView:self];
        }
        
        UITableView *table;
        CGSize contSize;
        for (int col = 0; col < self.noOfCols; col++) {
            table = (UITableView *)[self viewWithTag:kTableViewTag + col];
            [table reloadData];
            /* Added for footer */
            contSize=table.contentSize;
            contSize.height+=self.footerHeight;
            table.contentSize=contSize;
            [(UITableView *)[self viewWithTag:kScrollViewTag + col] setContentOffset:CGPointZero];
        }
        if([self.delegate respondsToSelector:@selector(footerViewForMultiTableView:)])
        {
            
            self.footerView =[self.delegate footerViewForMultiTableView:self];
            
            self.footerView.frame=CGRectMake(0,  contSize.height+table.frame.origin.y-(self.footerHeight),self.bgView.frame.size.width ,self.footerHeight);
            [self insertSubview:self.footerView belowSubview:table];
            
        }
        
        
        for (int column=0; column < self.noOfCols; column++)
        {
            UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag + column];
            scrollView.contentSize = CGSizeMake([self.delegate multiTableContentWidth:scrollView.contentSize.width widthForContent:column], table.frame.size.height);
            table = (UITableView *)[self viewWithTag:kTableViewTag + column];
            CGRect tableRect = table.frame;
            tableRect.size.width  = scrollView.contentSize.width;
            table.frame = tableRect;
            
            CGPoint offset = [[scrollOffsets objectAtIndex:column] CGPointValue];
            scrollView.contentOffset = CGPointMake((offset.x+scrollView.frame.size.width)>scrollView.contentSize.width?0:offset.x,(offset.y+scrollView.frame.size.height)>scrollView.contentSize.height?0:offset.y);
            
        }
        
        [table performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:2];
    
    });
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    UITableView *table;
    for (int col = 0; col < self.noOfCols; col++)
    {
        table = (UITableView *)[self viewWithTag:kTableViewTag + col];
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}
- (void)scrollToColumn:(NSInteger)col atScrollPosition:(UITableViewColumnScrollPosition)scrollPosition animated:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kScrollViewTag + col];
    
    if (scrollPosition == UITableViewColumnScrollPositionLeft)
    {
        [scrollView setContentOffset:CGPointMake((scrollView.contentSize.width - scrollView.frame.size.width), scrollView.contentOffset.y) animated:animated];
    }
    else if (scrollPosition == UITableViewColumnScrollPositionRight)
    {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:animated];
    }
}
#pragma marm UITableView Delegate mathods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(multiTableView:viewForHeaderInSection:withCol:)])
    {
        return [self.delegate multiTableView:self viewForHeaderInSection:section withCol:(tableView.tag - kTableViewTag)];
    }
    return nil;
}


- (CGFloat)tableView:(MultiTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(multiTableView:heightForHeaderInSection:)])
    {
        return [self.delegate multiTableView:self heightForHeaderInSection:section];
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(multiTableView:viewForFooterInSection:withCol:)])
    {
        return [self.delegate multiTableView:tableView viewForFooterInSection:section withCol:(tableView.tag - kTableViewTag)];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(multiTableView:heightForFooterInSection:)])
    {
        return [self.delegate multiTableView:self heightForFooterInSection:section];
    }
    return 0;
}
#pragma mark UITableView Datasource mathods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSource numberOfSectionsInTableView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger rowsCount = [self.dataSource multiTableView:self numberOfRowsInSection:section];
    
    if (rowsCount == 0)
    {
        //[self.bgView showErrorHolderWithTitle:self.emptyMessage error:@"" secondaryErrorMessage:@""];
    }
    else
    {
        //[self.bgContainer hideErrorHolder];
        self.emptyMessage = @"";
    }
    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowIDForCenterTable = (int)indexPath.row;
    if ([self.dataSource respondsToSelector:@selector(multiTableView:cellForRowAtIndexPath:withCol:)]) {
         UITableViewCell *cell = [self.dataSource multiTableView:self cellForRowAtIndexPath:indexPath withCol:(tableView.tag - kTableViewTag)];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.dataSource respondsToSelector:@selector(multiTableView:didEndDisplayingCell:forRowAtIndexPath:withColumn:)]){
        [self.dataSource multiTableView:self didEndDisplayingCell:cell forRowAtIndexPath:indexPath withColumn:(tableView.tag - kTableViewTag)];
    }
}


#pragma mark UIScrollViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(multiTableView:heightForRowAtIndexPath:ofColumn:)])
    {
        return [self.delegate multiTableView:self heightForRowAtIndexPath:indexPath ofColumn:(tableView.tag - kTableViewTag)];
    }
    else
    {
       if(self.isIdeaHubListView==YES)
        {
            return 59;
        }
        else
        {
            return 44;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     UITableView *table;
     UITableView* baseTable = (UITableView *)[self viewWithTag:kTableViewTag];

    if(self.shoulAllowPullToRefresh && self.scrollBeginOffsetY>scrollView.contentOffset.y) {
        [self.bgView setClipsToBounds:YES];
        [self pullToRefresh:scrollView.contentOffset.y];
//        [self.animatingView startAnimating];
    }
    self.previousOffsetY = scrollView.contentOffset.y;
    
//    NSLog(@"self.previousOffsetY == %d -- %@ -- %f",self.previousOffsetY,[scrollView class],scrollView.contentSize.height);
    
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        if(self.noOfCols == 2)
        {
            UITableView* leftTable = (UITableView *)[self viewWithTag:kTableViewTag];
            UITableView* rightTable = (UITableView *)[self viewWithTag:kTableViewTag + 1];

            if([scrollView isEqual:leftTable]) {
                CGPoint offset = rightTable.contentOffset;
                offset.y = leftTable.contentOffset.y;
                [rightTable setContentOffset:offset];
            } else {
                CGPoint offset = leftTable.contentOffset;
                offset.y = rightTable.contentOffset.y;
                [leftTable setContentOffset:offset];
            }
        }else
        {
            for (int col = 0; col < self.noOfCols; col++)
            {
                table = (UITableView *)[self viewWithTag:kTableViewTag + col];
                table.contentOffset = scrollView.contentOffset;
            }
        }
        
        if(self.footerView)
        {
         self.footerView.frame= CGRectMake(self.footerView.frame.origin.x, baseTable.contentSize.height+table.frame.origin.y -  (table.contentOffset.y) -self.footerView.frame.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        }
    
    }
    else
    {
        UIImageView *imgViewLeft = (UIImageView *)[self viewWithTag:(kScrollViewLeftIndicatorTag + (scrollView.tag - kScrollViewTag))];
        UIImageView *imgViewRight = (UIImageView *)[self viewWithTag:(kScrollViewRightIndicatorTag + (scrollView.tag - kScrollViewTag))];
        
        if (imgViewLeft != nil)
        {
            imgViewLeft.hidden = NO;
            [self.bgView bringSubviewToFront:imgViewLeft];
            
            if (scrollView.contentOffset.x <= 50) {
                imgViewLeft.hidden = YES;
            }
        }
        
        if (imgViewRight !=nil)
        {
            imgViewRight.hidden = NO;
            
            [self.bgView bringSubviewToFront:imgViewRight];
            if (((scrollView.contentSize.width - scrollView.contentOffset.x) - scrollView.frame.size.width) <= 50)
            {
                imgViewRight.hidden = YES;
            }
        }
        
        CGSize scrollableSize = CGSizeMake(scrollView.contentSize.width, 0);
        [scrollView setContentSize:scrollableSize];
    
    }
    
    if ([self.delegate respondsToSelector:@selector(multiTableDidScroll)]) {
        [self.delegate multiTableDidScroll];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *table;
    for (int col = 0; col < self.noOfCols; col++) {
        table = (UITableView *)[self viewWithTag:kTableViewTag + col];
        [table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    table = (UITableView *)[self viewWithTag:kTableViewTag];
    UITableViewCell *row = ((UITableViewCell *)[table cellForRowAtIndexPath:indexPath]);
    if ([self.delegate respondsToSelector:@selector(multiTableView:didSelectRowAtIndexPath:withColumn:WithView:)]) {
       [self.delegate multiTableView:self didSelectRowAtIndexPath:indexPath withColumn:(tableView.tag - kTableViewTag) WithView:(UIView*)row];
    }
}

#pragma mark - scrollview delegate

-(void)setPriliminaryForPullToRefresh:(UIScrollView *)scrollView {
    if(!self.shoulAllowPullToRefresh) { // This check is to avoid animation issue and duplicate calls
        self.maxPullToRefreshorigin = scrollView.frame.size.height*kPullToRefreshPercentage;
        self.shoulAllowPullToRefresh = NO;
        self.scrollBeginOffsetY = scrollView.contentOffset.y;
        self.previousOffsetY =scrollView.contentOffset.y;
        if(self.scrollBeginOffsetY == 0 && !self.restrictPullToRefresh) {
            self.shoulAllowPullToRefresh = YES;
        }
        for (int column=0; column < 1; column++) {
            UIView *headerView = [self.delegate multiTableView:self viewForHeader:column];
            self.animatingView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-KSpinnerSize)/2, headerView.frame.size.height-KSpinnerSize, KSpinnerSize, KSpinnerSize);
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if([self.pullToRefreshDelegate respondsToSelector:@selector(performPullToRefreshOperation)]) {
        [self setPriliminaryForPullToRefresh:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.pullToRefreshDelegate respondsToSelector:@selector(performPullToRefreshOperation)]) {
        [self setPriliminaryForPullToRefresh:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 50.0 &&
        scrollView.contentSize.height > scrollView.frame.size.height && // Check if user scroll on horizontal scrollView
        [self.pullToRefreshDelegate respondsToSelector:@selector(performLoadMoreOperation)]) {
        [self.pullToRefreshDelegate performLoadMoreOperation];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(!self.restrictPullToRefresh)
        [self checkForPullToRefresh:scrollView];
}


#pragma mark - pull to refresh

-(void)pullToRefresh:(int )point {
    int differenceInPoint =  -point +self.previousOffsetY;
    CGRect frame =self.animatingView.frame;
    frame.origin.y += differenceInPoint;
    UIView *headerView = [self.delegate multiTableView:self viewForHeader:0];
    if(frame.origin.y <= self.maxPullToRefreshorigin + headerView.frame.size.height) {
        [self.animatingView setFrame:frame];
    }
}

-(void)checkForPullToRefresh:(UIScrollView *)scrollView {
    UIView *headerView = [self.delegate multiTableView:self viewForHeader:0];
    if(self.animatingView.frame.origin.y>=self.maxPullToRefreshorigin+headerView.frame.size.height){
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            for (int column=0; column < self.noOfCols; column++) {
                UIScrollView *baseScrollView = (UIScrollView*)[self viewWithTag:kScrollViewTag + column];
                UITableView *table = (UITableView*)[baseScrollView viewWithTag:kTableViewTag + column];
                CGRect rect = table.frame;
                rect.origin.y = self.maxPullToRefreshorigin+self.animatingView.frame.size.height+headerView.frame.size.height;
                [table setFrame:rect];
            }
        }completion:^(BOOL finished) {
              //if the boolean is true, it indicates that already a call is being proccessed
            if([self.pullToRefreshDelegate respondsToSelector:@selector(performPullToRefreshOperation)] && !self.isRefreshCallFired) {
                [self.pullToRefreshDelegate performPullToRefreshOperation];
                self.isRefreshCallFired = YES;
            }
        }];
    }
    else {
        self.shoulAllowPullToRefresh = NO;
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            CGRect rect = self.animatingView.frame;
            rect.origin.y = 0;
            [self.animatingView setFrame:rect];
        }completion:^(BOOL finished) {
        }];
    }
    
}

-(void)pullToRefreshCompleted {
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            CGRect rect = self.animatingView.frame;
            rect.origin.y = -rect.size.height;
            [self.animatingView setFrame:rect];
            for (int column=0; column < self.noOfCols; column++) {
                UIScrollView *baseScrollView = (UIScrollView*)[self viewWithTag:kScrollViewTag + column];
                UITableView *table = (UITableView*)[baseScrollView viewWithTag:kTableViewTag + column];
                UIView *headerView = [self.delegate multiTableView:self viewForHeader:column];
                rect = table.frame;
                rect.origin.y = headerView.frame.size.height;
                [table setFrame:rect];
            }
        }completion:^(BOOL finished) {
            self.shoulAllowPullToRefresh = NO;
            self.isRefreshCallFired = NO;
//            [self.animatingView stopAnimating];
        }];
}

#pragma mark PhillipStreamer

- (void)dealloc
{
}
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation forcolum:(int)colom {
    UITableView *table = [self tableForColumn:colom];
    [table reloadSections:sections withRowAnimation:animation];
}
- (void)reloadRow:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forcolum:(int)colom {
    UITableView *table = [self tableForColumn:colom];
    [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}
@end
