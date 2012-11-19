//
//  ThumbnailList.m
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "ThumbnailList.h"
#import "ThumbnailCell.h"
#import "MyScrollView.h"
@implementation ThumbnailList
@synthesize DataSource = _DataSource;
@synthesize cellSize = _cellSize;
@synthesize EnableEdit = editEnabled;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        MyScrollView *scroll = [[MyScrollView alloc] initWithFrame:CGRectMake(6, 0, self.frame.size.width, self.frame.size.height)];
        PagesLoaded = [[[NSMutableArray alloc] init] retain];
        scroll.tag = SCROLL_VIEW_TAG;
        scroll.pagingEnabled = YES;
        scroll.scrollEnabled = YES;
        scroll.contentSize = self.frame.size;
        [scroll setShowsHorizontalScrollIndicator:NO];
        [scroll setShowsVerticalScrollIndicator:NO];
        scroll.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        scroll.delegate = self;
        
        [self addSubview:scroll];
        _cellSize = CGSizeMake(70, 50);
        minPageNo = 1;
        minCellMargin = 20;
        cellHeight = 80;
        cellWidth = 80;
        self.clipsToBounds = YES;
        queue = [[NSOperationQueue alloc] init];
        
        draggingEnabled = YES;
        editEnabled = NO;
        subviewLayed = NO;
        
    }
    return self;
}
-(void)navigateRight:(id)sender
{
    if((currentPage+1)<pageCount)
    {
        MyScrollView *scrollView = (MyScrollView*)[self viewWithTag:1];
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * (++currentPage);
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        [scrollView scrollRectToVisible:frame animated:YES];
        
    }
}
-(void)navigateLeft:(id)sender
{
    if(currentPage>0)
    {
        MyScrollView *scrollView = (MyScrollView*)[self viewWithTag:1];
        CGRect frame;
        
        frame.origin.x = scrollView.frame.size.width * (--currentPage);
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        [scrollView scrollRectToVisible:frame animated:YES];
        
    }
}
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        MyScrollView *scroll = [[MyScrollView alloc] initWithFrame:CGRectMake(6, 0, self.frame.size.width, self.frame.size.height)];
        PagesLoaded = [[[NSMutableArray alloc] init] retain];
        scroll.tag = SCROLL_VIEW_TAG;
        scroll.pagingEnabled = YES;
        scroll.scrollEnabled = YES;
        scroll.contentSize = self.frame.size;
        [scroll setShowsHorizontalScrollIndicator:NO];
        [scroll setShowsVerticalScrollIndicator:NO];
        scroll.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        scroll.delegate = self;
        scroll.canCancelContentTouches = NO;
        [self addSubview:scroll];
        _cellSize = CGSizeMake(70, 50);
        minPageNo = 1;
        minCellMargin = 20;
        cellHeight = 80;
        cellWidth = 80;
        self.clipsToBounds = YES;
        queue = [[NSOperationQueue alloc] init];
        
        draggingEnabled = YES;
        editEnabled = YES;
        subviewLayed = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 2.0f/*0.5f * CGRectGetHeight(bounds)*/;
    
    
    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGRect innerRect = CGRectInset(bounds, radius, radius);
    CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, bounds.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y + bounds.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x, innerRect.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius);
    CGPathCloseSubpath(visiblePath);
    
    // Fill this path
    UIColor *aColor = [UIColor whiteColor];
    [aColor setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(bounds, -42, -42));
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    
    // Now setup the shadow properties on the context
    aColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.5f, 1.5f), 10.0f, [aColor CGColor]);
    //cgcontextsets
    
    // Now fill the rectangle, so the shadow gets drawn
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    // Release the paths
    CGPathRelease(path);
    CGPathRelease(visiblePath);
    
}

-(void)ReloadData
{
    if([_DataSource respondsToSelector:@selector(numberOfcellsForthumbanilList:)])
    {
        numberOfCells = [_DataSource numberOfcellsForthumbanilList:self];
    }else
    {
        numberOfCells = 0;
    }
    
    
    NSInvocationOperation *op = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(LoadNextPage:) object:self] autorelease];
    if(!queue)
    {
        queue = [[NSOperationQueue alloc] init];
    }
    [queue addOperation:op];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
-(void)orientationChanged:(UIInterfaceOrientation)orientaion;
{
    int margin;
    if(UIInterfaceOrientationIsLandscape(orientaion))
    {
        margin = 32;
    }else
    {
        margin=minCellMargin;
    }
    int x = margin;
    int y = 20;
    subviewLayed = YES;
    MyScrollView *scroll = (MyScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
    NSArray *viewsToRemove = [scroll subviews];
    
    int numberOfCellsInPageBuffer = 0;
    int numberOfCellsInPage = 0;
    for(ThumbnailCell *cell in viewsToRemove)
    {
        if((cell.tag>=10000)&&(cell.tag<=(numberOfCells+10000)))
        {
            
            
            // Check if ThumbCells reached the bottom
            // if reached the bottom reset y and increase x
            
            if((((int)((x+cellWidth +margin)/self.frame.size.width))*self.frame.size.width)!=(x+cellWidth +margin) )
            {
                numberOfCellsInPageBuffer++;
                if(cell.tag!=10000)
                {
                    x += cellWidth +margin;
                    
                }
                
            }else
            {
                 numberOfCellsInPageBuffer++;
                x+=cellWidth +margin;
                if(cell.tag!=10000)
                {
                    if((y+cellHeight+margin)<=self.frame.size.height-100)
                    {
                       
                        y += cellHeight + margin;
                        x -= self.frame.size.width-margin;
                    }else
                    {
                        numberOfCellsInPage = numberOfCellsInPageBuffer;
                        numberOfCellsInPageBuffer = 0;
                        x+=  margin;
                        y = 20;
                    }
                }
                
            }
            
            
            
            //set cell size
            cell.frame = CGRectMake(x, y, cellHeight, cellHeight);
            
            cell.originalRect = CGRectMake(x, y, cellHeight, cellHeight);
            
        }
    }
    
    //calculate no of pages in pager
    float perc = x/self.frame.size.width;
    pageCount = (int)((perc)+1.0);
    
    //calculate ThumbListView width
    int width  = pageCount * self.frame.size.width;
    
    LastContentOffset = scroll.contentOffset;
    
    int firstCellInPageIndex;
    int pageWidth;
    if(UIInterfaceOrientationIsLandscape(orientaion))
    {
        pageWidth = 480;
        firstCellInPageIndex = ((currentPage)*LastnumberOfCellsInPage);
    }else
    {
        pageWidth = 320;
        firstCellInPageIndex = ((currentPage)*LastnumberOfCellsInPage);
    }
    LastnumberOfCellsInPage = numberOfCellsInPage;
    // Update Scroll View Content Offset
    ThumbnailCell *firstCellInPage = (ThumbnailCell*)[scroll viewWithTag:firstCellInPageIndex+10000];

    
    int newContentOffset = (firstCellInPage.frame.origin.x/pageWidth);
    newContentOffset *= pageWidth;
    
    scroll.contentSize = CGSizeMake(width, self.frame.size.height);
    
    [scroll setContentOffset:CGPointMake(newContentOffset, scroll.contentOffset.y)];
    
    LastContentOffset = scroll.contentOffset;
    
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if(newSuperview)
    {
        
        
        [self ReloadData];
        
    }
}
-(MyScrollView*)getScrollView
{
    @synchronized(@"scroll")
    {
        return (MyScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
    }
    
}
-(void)scrollToCurrentPage
{
    [[self getScrollView] setContentOffset:CGPointMake(currentPage*self.frame.size.width, 0) animated:YES];
}
-(void)CellTouched:(id)sender
{
    ThumbnailCell *control = sender;
    if(editEnabled == NO)
    {
        
        int index = control.tag-10000;
        if([_DataSource respondsToSelector:@selector(thumbnailList:didSelectThumbAtIndex:)])
        {
            [_DataSource thumbnailList:self didSelectThumbAtIndex:index];
        }
    }else
    {
        
                
    }

}
/*-(void)ThumbSelected:(id)sender withEvent:(UIEvent*)event
{
     ThumbnailCell *control = sender;
    if(editEnabled == NO)
    {
        
        int index = control.tag-10000;
        if([_DataSource respondsToSelector:@selector(thumbnailList:didSelectThumbAtIndex:)])
        {
            [_DataSource thumbnailList:self didSelectThumbAtIndex:index];
        }
    }else 
    {
        
        BOOL intersectionDetected = NO;
        UIScrollView *scroll = [self getScrollView];
        [self scrollToCurrentPage];
        for (ThumbnailCell *otherCell in scroll.subviews)
        {
            if (otherCell == control)
                continue;
            CGRect absoluteOtherViewRect  = otherCell.frame; // Calculate
            if (CGRectIntersectsRect(control.frame, absoluteOtherViewRect))
            {
                // Collision!
                intersectionDetected = YES;
                [UIView animateWithDuration:0.2 animations:^(void){
                    
                    otherCell.frame = control.originalRect;
                    otherCell.layer.borderColor = [UIColor blueColor].CGColor;
                    control.frame = otherCell.originalRect;
                    
                    
                    
                    //swap tags
                    int controlTag = control.tag;
                    control.tag = otherCell.tag;
                    
                    otherCell.tag = controlTag;
                    
                    
                } completion:^(BOOL finished){
                    //otherCell.layer.borderColor = [UIColor grayColor].CGColor;
                    control.originalRect = control.frame;
                    otherCell.originalRect = otherCell.frame;
                    if([_DataSource respondsToSelector:@selector(thumbnailList:didSwapCellAtIndex:withCellAtIndex:)])
                    {
                        [_DataSource thumbnailList:self didSwapCellAtIndex:control.tag-10000 withCellAtIndex:otherCell.tag-10000];
                    }
                    
                }];
                break;
            }else
            {
                otherCell.layer.borderColor = [UIColor grayColor].CGColor;
            }
            
        }
        if(intersectionDetected == NO)
        {
            [UIView animateWithDuration:0.2 animations:^(void){
                
                control.frame = control.originalRect;
                
                
                
                
            } completion:^(BOOL finished){
                
               
               
                
            }];
        }

    }
}*/

-(void)LoadNextPage:(ThumbnailList*)list
{
    
    
    
    int margin;
    UIInterfaceOrientation orientation= [[UIDevice currentDevice] orientation];
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        margin = 36;
    }else
    {
        margin=minCellMargin;
    }
    int x = margin;
    int y = 20;
    subviewLayed = YES;
    MyScrollView *scroll = (MyScrollView*)[list viewWithTag:SCROLL_VIEW_TAG];
    NSArray *viewsToRemove = [scroll subviews];
    for (UIView *v in viewsToRemove) {
        if((v.tag>=10000)&&(v.tag<=(numberOfCells+10000)))
        {
            [v removeFromSuperview];
        }
    }
    int numberOfCellsInPageBuffer = 0;
    int numberOfCellsInPage = 0;
    for(int i=0;i<numberOfCells;i++)
    {
        if([self.DataSource respondsToSelector:@selector(thumbnailList:cellForIndex:)])
        {
            ThumbnailCell *cell = [_DataSource thumbnailList:list cellForIndex:i];
            
            //[cell addTarget:list action:@selector(ThumbSelected:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            // Check if ThumbCells reached the bottom
            // if reached the bottom reset y and increase x
            
            if((((int)((x+cellWidth +margin)/self.frame.size.width))*self.frame.size.width)!=(x+cellWidth +margin) )
            {
                numberOfCellsInPageBuffer++;
                if(i!=0)
                {
                    x += cellWidth +margin;
                    
                }
                
            }else //if((y+cellHeight+margin)<=self.frame.size.height-20)
            {
                numberOfCellsInPageBuffer++;
                x+=cellWidth +margin;
                if(i!=0)
                {
                    if((y+cellHeight+margin)<=self.frame.size.height-100)
                    {
                        y += cellHeight + margin;
                        x -= self.frame.size.width-margin;
                    }else
                    {
                        numberOfCellsInPage = numberOfCellsInPageBuffer;
                        numberOfCellsInPageBuffer = 0;
                        x+=  margin;
                        y = 20;
                    }
                }
                
            }
            
            
            
            //set cell size
            cell.frame = CGRectMake(x, y, cellHeight, cellHeight);
            cell.originalRect = CGRectMake(x, y, cellHeight, cellHeight);
            cell.tag = i+10000;
            cell.ThumbnailCellDelegate = self;
            
            //add drag and drop events
            UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(CellMoved:)];
            [longTapGesture setNumberOfTouchesRequired:1];
            //[cell addTarget:self action:@selector(CellMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [cell addGestureRecognizer:longTapGesture];
            
            //add cell to scrollView
            [scroll addSubview:cell];
            [cell release];
            cell = nil;
            
        }
    }
    
    //calculate no of pages in pager
    float perc = x/self.frame.size.width;
    pageCount = (int)((perc)+1.0);
    
    //calculate ThumbListView width
    int width  = pageCount * self.frame.size.width;
    
    LastnumberOfCellsInPage = numberOfCellsInPage;
    
    
    
    
    
    
    // set scrollView content size
    scroll.contentSize = CGSizeMake(width, self.frame.size.height);
    
    
    
    
}
/*-(void)CellMoved:(id)sender withEvent:(UIEvent*)event
{
    MyScrollView *scroll = (MyScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
    
    ThumbnailCell *control = (ThumbnailCell*)sender;
    CGPoint point = [[[event allTouches] anyObject] locationInView:scroll];
    control.center = point;
    CGPoint pointInSelf = [[[event allTouches] anyObject] locationInView:self];
    scroll.delaysContentTouches = NO;
    [scroll setCanCancelContentTouches:NO];
    scroll.scrollEnabled = NO;
    if((pointInSelf.x+150)>self.frame.size.width && currentPage!=pageCount-1)
    {
        
        [scroll bringSubviewToFront:control];
        [scroll scrollRectToVisible:CGRectMake(control.center.x+150, control.frame.origin.y, control.frame.size.width, control.frame.size.height) animated:YES];
        //control.center = CGPointMake(point.x+100, point.y);
        
        
    }else if((pointInSelf.x-150)<0 && currentPage!=0)
    {
        
        [scroll bringSubviewToFront:control];
        [scroll scrollRectToVisible:CGRectMake(control.center.x-150, control.frame.origin.y, control.frame.size.width, control.frame.size.height) animated:YES];
        //control.center = CGPointMake(point.x-100, point.y);
    }
    
    
    
    
    BOOL intersectionDetected = NO;
    for (ThumbnailCell *otherCell in scroll.subviews)
    {
        if (otherCell == control)
            continue;
        CGRect absoluteOtherViewRect  = otherCell.frame; // Calculate
        if (CGRectIntersectsRect(control.frame, absoluteOtherViewRect) && intersectionDetected==NO)
        {
            // Collision!
            intersectionDetected = YES;
            
            
            otherCell.layer.borderColor = [UIColor blueColor].CGColor;
            
        }else
        {
            otherCell.layer.borderColor = [UIColor grayColor].CGColor;
        }
        
    }

}*/
- (IBAction) CellMoved:(UIGestureRecognizer*) sender
{
    if(editEnabled == YES)
    {
        MyScrollView *scroll = (MyScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
        
        ThumbnailCell *control = (ThumbnailCell*)[sender view];
        CGPoint point = [sender locationInView:scroll];
        control.center = point;
        CGPoint pointInSelf = [sender locationInView:self];
        scroll.delaysContentTouches = NO;
        [scroll setCanCancelContentTouches:NO];
        scroll.scrollEnabled = NO;
        if(sender.state != UIGestureRecognizerStateBegan)
        {
           
            if((pointInSelf.x+40)>self.frame.size.width && currentPage<=pageCount-1)
            {
                
                [scroll bringSubviewToFront:control];
                 [scroll scrollRectToVisible:CGRectMake(control.center.x+150, control.frame.origin.y, control.frame.size.width, control.frame.size.height) animated:YES];
                //control.center = CGPointMake(point.x+100, point.y);
                
                
            }else if((pointInSelf.x-40)<0 && currentPage>=0)
            {
                
                [scroll bringSubviewToFront:control];
                 [scroll scrollRectToVisible:CGRectMake(control.center.x-150, control.frame.origin.y, control.frame.size.width, control.frame.size.height) animated:YES];
                //control.center = CGPointMake(point.x-100, point.y);
            }


            
            
            BOOL intersectionDetected = NO;
            for (ThumbnailCell *otherCell in scroll.subviews)
            {
                if (otherCell == control)
                    continue;
                CGRect absoluteOtherViewRect  = otherCell.frame; // Calculate
                if (CGRectIntersectsRect(control.frame, absoluteOtherViewRect) && intersectionDetected==NO)
                {
                    // Collision!
                    intersectionDetected = YES;
                    
                        
                    otherCell.layer.borderColor = [UIColor blueColor].CGColor;
                    
                }else
                {
                    otherCell.layer.borderColor = [UIColor grayColor].CGColor;
                }
                
            }
        }
        
        if(sender.state == UIGestureRecognizerStateEnded)
        {
            BOOL intersectionDetected = NO;
            MyScrollView *scroll = [self getScrollView];
            scroll.delaysContentTouches = YES;
            [scroll setCanCancelContentTouches:YES];
            scroll.scrollEnabled = YES;
            [self scrollToCurrentPage];
            for (ThumbnailCell *otherCell in scroll.subviews)
            {
                if (otherCell == control)
                    continue;
                CGRect absoluteOtherViewRect  = otherCell.frame; // Calculate
                if (CGRectIntersectsRect(control.frame, absoluteOtherViewRect))
                {
                    // Collision!
                    intersectionDetected = YES;
                    [UIView animateWithDuration:0.2 animations:^(void){
                        
                        //swap rectangles
                        otherCell.frame = control.originalRect;
                        
                        control.frame = otherCell.originalRect;
                        
                        
                        
                        //swap tags
                        int controlTag = control.tag;
                        control.tag = otherCell.tag;
                        
                        otherCell.tag = controlTag;
                        
                        
                    } completion:^(BOOL finished){
                        otherCell.layer.borderColor = [UIColor grayColor].CGColor;
                        control.originalRect = control.frame;
                        otherCell.originalRect = otherCell.frame;
                        if([_DataSource respondsToSelector:@selector(thumbnailList:didSwapCellAtIndex:withCellAtIndex:)])
                        {
                            [_DataSource thumbnailList:self didSwapCellAtIndex:control.tag-10000 withCellAtIndex:otherCell.tag-10000];
                        }
                        
                    }];
                    break;
                }
                otherCell.layer.borderColor = [UIColor grayColor].CGColor;
            }
            if(intersectionDetected == NO)
            {
                [UIView animateWithDuration:0.2 animations:^(void){
                    
                    control.frame = control.originalRect;
                    
                    
                    
                    
                } completion:^(BOOL finished){
                    
                    
                    
                    
                }];
            }

        }
    }
}
-(void)MoveToNextPage
{
    MyScrollView *scroll = [self getScrollView];
    [scroll setContentOffset:CGPointMake(scroll.contentOffset.x+self.frame.size.width, scroll.contentOffset.y) animated:YES];
}
-(void)EnableDragging
{
    draggingEnabled = YES;
}
- (void)scrollViewDidScroll:(MyScrollView *)sender {
    
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        currentPage = (page % pageCount);
        sender = nil;
    
    
}
-(void)setRightNavButtonImage:(UIImage*)image
{
    UIButton *rightBtn = (UIButton*)[self viewWithTag:RIGHT_NAV_TAG];
    [rightBtn setImage:image forState:UIControlStateNormal];
}
-(void)setLeftNavButtonImage:(UIImage*)image
{
    UIButton *LeftBtn = (UIButton*)[self viewWithTag:LEFT_NAV_TAG];
    [LeftBtn setImage:image forState:UIControlStateNormal];
}


@end