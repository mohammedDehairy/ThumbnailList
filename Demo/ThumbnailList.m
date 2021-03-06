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
@synthesize cellSize = _cellSize;
@synthesize LongPressToEditEnabled = _LongPressToEditEnabled;
-(BOOL)getEnableEdit
{
    return editEnabled;
}
-(void)AddDeleteBtnToCell:(ThumbnailCell*)cell
{
    
}
-(void)setEnableEdit:(BOOL)value
{
    editEnabled = value;
    if(value==YES)
    {
        for(ThumbnailCell *cell in [self getScrollView].subviews)
        {
            [cell EnterEditMode];
           
            
        }
    }else
    {
        for(ThumbnailCell *cell in [self getScrollView].subviews)
        {
            
            [cell ExitEditMode];

        }
    }
}
- (id)initWithFrame:(CGRect)frame withDataSource:(id<ThumbnailListDataSourceDelegate>) datasource
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        DataSource = datasource;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.autoresizesSubviews = YES;
        MyScrollView *scroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
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
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ToggleEditMode:)];
        
        [self addGestureRecognizer:tapGestureRecognizer];
        _LongPressToEditEnabled = YES;
        _cellSize = CGSizeMake(70, 50);
        minPageNo = 1;
        minCellMargin = 20;
        cellHeight = 105;
        cellWidth = 80;
        self.clipsToBounds = YES;
        queue = [[NSOperationQueue alloc] init];
        
        draggingEnabled = YES;
        editEnabled = NO;
        subviewLayed = NO;
        [self ReloadData];
        
    }
    return self;
}
-(void)ToggleEditMode:(UIGestureRecognizer*)gesture
{
    if(editEnabled==YES)
    {
        [self setEnableEdit:NO];
    }
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
        editEnabled = NO;
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
    UIColor *aColor = [UIColor colorWithRed:(223.0/255.0) green:(224.0/255.0) blue:(225.0/255.0) alpha:1.0f];
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
   
    
    [self Load];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self orientationChanged:[[UIDevice currentDevice] orientation]];
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
    
    int numberOfCellsInPageBuffer = 0;
    int numberOfCellsInPage = 0;
    for(int i=0;i<numberOfCells;i++)
    {
        ThumbnailCell *cell = (ThumbnailCell*)[scroll viewWithTag:i+10000];
      
            
            
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
            cell.frame = CGRectMake(x, y, cellWidth, cellHeight);
            
            cell.originalRect = CGRectMake(x, y, cellWidth, cellHeight);
        cell.tag = i+10000;
        
    }
    
    [self AdjustScrollViewContentSizeToLastCellX:x];
    
    
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

-(void)allignCell:(ThumbnailCell**) cell AfterLastx:(int) lastx lasty:(int) lasty forOrientation:(UIInterfaceOrientation) orientaion
{
    int margin;
    if(UIInterfaceOrientationIsLandscape(orientaion))
    {
        margin = 32;
    }else
    {
        margin=minCellMargin;
    }
    

    
    if((((int)((lastx+cellWidth +margin)/self.frame.size.width))*self.frame.size.width)!=(lastx+cellWidth +margin) )
    {
        if((*cell).tag!=10000)
        {
            lastx += cellWidth +margin;
            
        }
        
    }else
    {
        lastx+=cellWidth +margin;
        if((*cell).tag!=10000)
        {
            if((lasty+cellHeight+margin)<=self.frame.size.height-100)
            {
                
                lasty += cellHeight + margin;
                lastx -= self.frame.size.width-margin;
            }else
            {
                lastx+=  margin;
                lasty = 20;
            }
        }
        
    }
    CGRect frame = CGRectMake(lastx, lasty, (*cell).frame.size.width, (*cell).frame.size.height);
    (*cell).frame = frame;
    (*cell).originalRect = frame;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

}
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];

    
    
    
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
        if([DataSource respondsToSelector:@selector(thumbnailList:didSelectThumbAtIndex:)])
        {
            [DataSource thumbnailList:self didSelectThumbAtIndex:index];
        }
    }

}


-(void)DeleteBtnTouchedForCell:(ThumbnailCell*)cell
{
    [self DeleteCellAtIndex:cell.tag-10000 animated:YES];
}
-(void)DeleteCellAtIndex:(int)index animated:(BOOL) animated
{
    ThumbnailCell *DeletedCell = (ThumbnailCell*)[[self getScrollView] viewWithTag:index+10000];
     CGRect PreviousCellFrame = DeletedCell.originalRect;
    int deletedTag = DeletedCell.tag;
    [DeletedCell removeFromSuperview];
    [DeletedCell release];
    DeletedCell = nil;
    if(animated==YES)
    {
        [UIView beginAnimations:@"tilescleared" context:nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration:0.5];
    }
    CGRect bufferFrame;
    CGRect LastCellFrame;
    MyScrollView *scroll = [self getScrollView];
    for(int i=(deletedTag+1);i<numberOfCells+10000;i++)
    {
        ThumbnailCell *cell = (ThumbnailCell*)[scroll viewWithTag:i];
            bufferFrame = cell.originalRect;
            cell.frame = PreviousCellFrame;
            cell.tag--;
            cell.originalRect = PreviousCellFrame;
            
            
            LastCellFrame = cell.originalRect;
            PreviousCellFrame = bufferFrame;
    }
    numberOfCells--;
    if(animated==YES)
    {
        [UIView commitAnimations];
    }
    if([DataSource respondsToSelector:@selector(thumbnailList:didDeleteCellAtIndex:)] )
    {
        [DataSource thumbnailList:self didDeleteCellAtIndex:deletedTag-10000];
    }
    LastCellFrame = ((ThumbnailCell*)[self viewWithTag:numberOfCells+9999]).frame;
    [self AdjustScrollViewContentSizeToLastCellX:LastCellFrame.origin.x];
}

-(void)Load
{
    
    
    
    int margin;
    UIInterfaceOrientation orientation= [[UIDevice currentDevice] orientation];
    if(UIInterfaceOrientationIsLandscape(orientation))
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
     CGPoint LastOffset = scroll.contentOffset;
    NSArray *viewsToRemove = [scroll subviews];
    for (UIView *v in viewsToRemove) {
        if((v.tag>=10000)&&(v.tag<=(numberOfCells+10000)))
        {
            [v removeFromSuperview];
        }
    }
    if([DataSource respondsToSelector:@selector(numberOfcellsForthumbanilList:)])
    {
        numberOfCells = [DataSource numberOfcellsForthumbanilList:self];
    }else
    {
        numberOfCells = 0;
    }
    int numberOfCellsInPage = 0;
    for(int i=0;i<numberOfCells;i++)
    {
        if([DataSource respondsToSelector:@selector(thumbnailList:cellForIndex:)])
        {
            ThumbnailCell *cell = [DataSource thumbnailList:self cellForIndex:i];
            

            
            
            //set cell size
            cell.frame = CGRectMake(x, y, cellWidth, cellHeight);
            cell.originalRect = CGRectMake(x, y, cellWidth, cellHeight);
            
            //add cell To List

            [self AddCellToList:cell withTag:i+10000];
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
    
    [self orientationChanged:[[UIDevice currentDevice] orientation]];
    [self ReserveScrollContentOffset:LastOffset];
    
}
-(void)ReserveScrollContentOffset:(CGPoint)LastOffset
{
    UIScrollView *scroll = [self getScrollView];
    if(LastOffset.x>=scroll.contentSize.width)
    {
        [scroll setContentOffset:CGPointMake(scroll.contentSize.width-self.frame.size.width, 0) ];
    }else
    {
        [scroll setContentOffset:LastOffset];
    }
}
- (IBAction) CellMoved:(UIGestureRecognizer*) sender
{
    if(_LongPressToEditEnabled==YES || editEnabled==YES)
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
               
                
                
            }else if((pointInSelf.x-40)<0 && currentPage>=0)
            {
                
                [scroll bringSubviewToFront:control];
                 [scroll scrollRectToVisible:CGRectMake(control.center.x-150, control.frame.origin.y, control.frame.size.width, control.frame.size.height) animated:YES];
                
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
        }else
        {
            [self setEnableEdit:YES];
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
                        CGRect contronRect = control.frame;
                        //swap rectangles
                        otherCell.frame = control.originalRect;
                        
                        control.frame = otherCell.originalRect;
                        
                        
                        contronRect = control.originalRect;
                        control.originalRect = otherCell.originalRect;
                        
                        otherCell.originalRect = contronRect;
                        
                        //swap tags
                        int controlTag = control.tag;
                        control.tag = otherCell.tag;
                        
                        otherCell.tag = controlTag;
                        
                        
                    } completion:^(BOOL finished){
                        otherCell.layer.borderColor = [UIColor grayColor].CGColor;

                        if([DataSource respondsToSelector:@selector(thumbnailList:didSwapCellAtIndex:withCellAtIndex:)])
                        {
                            [DataSource thumbnailList:self didSwapCellAtIndex:control.tag-10000 withCellAtIndex:otherCell.tag-10000];
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
-(void)AddCellToList:(ThumbnailCell*)cell withTag:(int)tag
{
    [cell retain];
    cell.ThumbnailCellDelegate = self;
    cell.tag = tag;
    UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(CellMoved:)];
    [longTapGesture setNumberOfTouchesRequired:1];
    
    [cell addGestureRecognizer:longTapGesture];
    [[self getScrollView] addSubview:cell];
    [cell release];
    cell = nil;
}
-(void)InsertCell:(ThumbnailCell*)Addedcell AtIndex:(int)index
{
    UIScrollView *scroll = [self getScrollView];
    
    ThumbnailCell *cellAtTheIndex = (ThumbnailCell*)[scroll viewWithTag:index+10000];
    
    Addedcell.frame = cellAtTheIndex.originalRect;
    Addedcell.originalRect = cellAtTheIndex.originalRect;
    
    [self AddCellToList:Addedcell withTag:cellAtTheIndex.tag];
        
    
    ThumbnailCell *cellBefore;
    if(index>=numberOfCells-1 && cellAtTheIndex==nil)
    {
        cellBefore = Addedcell;
        ThumbnailCell *CurrentLastCell = (ThumbnailCell*)[scroll viewWithTag:numberOfCells-1+10000];
        if(CurrentLastCell==nil)
        {
            cellBefore.frame = CGRectMake(minCellMargin, 20, cellWidth, cellHeight);
            cellBefore.originalRect = CGRectMake(minCellMargin, 20, cellWidth, cellHeight);
            cellBefore.tag = 9999;
        }else{
            cellBefore.frame = CurrentLastCell.frame;
            cellBefore.originalRect = CurrentLastCell.frame;
            cellBefore.tag = CurrentLastCell.tag;
        }
        
    }else
    {
        cellBefore = cellAtTheIndex;
        ThumbnailCell *Currentcell;
        for(int i=(index+10001);i<numberOfCells+10000;i++)
        {
            Currentcell  = (ThumbnailCell*)[scroll viewWithTag:i];
            
            CGRect bufferFrame = Currentcell.originalRect;
            
            cellBefore.frame = bufferFrame;
            cellBefore.originalRect = bufferFrame;
            cellBefore.tag++;
            
            cellBefore = Currentcell;
        }
    }
    
   
    
    numberOfCells++;
    
    cellBefore.tag++;
    
    [self allignCell:&cellBefore AfterLastx:cellBefore.frame.origin.x lasty:cellBefore.frame.origin.y forOrientation:[[UIDevice currentDevice] orientation]];
    int lastx = cellBefore.frame.origin.x;
    
    
    [self AdjustScrollViewContentSizeToLastCellX:lastx];

}
-(void)AdjustScrollViewContentSizeToLastCellX:(int) lastX
{
    UIScrollView *scroll = [self getScrollView];
    if(lastX>scroll.contentSize.width)
    {
        scroll.contentSize = CGSizeMake(scroll.contentSize.width+self.frame.size.width, scroll.contentSize.height);
    }else if(lastX<(scroll.contentSize.width-self.frame.size.width))
    {
        scroll.contentSize = CGSizeMake(scroll.contentSize.width-self.frame.size.width, scroll.contentSize.height);
    }
}

@end