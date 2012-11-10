//
//  ThumbnailList.m
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "ThumbnailList.h"
#import "ThumbnailCell.h"
@implementation ThumbnailList
@synthesize DataSource = _DataSource;
@synthesize cellSize = _cellSize;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(6, 0, self.frame.size.width, self.frame.size.height)];
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

        

        subviewLayed = NO;
       
    }
    return self;
}
-(void)navigateRight:(id)sender
{
    if((currentPage+1)<pageCount)
    {
        UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:1];
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
        UIScrollView *scrollView = (UIScrollView*)[self viewWithTag:1];
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
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
         PagesLoaded = [[[NSMutableArray alloc] init] retain];
        scroll.tag = 1;
        scroll.pagingEnabled = YES;
        scroll.scrollEnabled = YES;
        scroll.contentSize = self.frame.size;
        [scroll setShowsHorizontalScrollIndicator:NO];
        [scroll setShowsVerticalScrollIndicator:NO];
        scroll.delegate = self;
        [self addSubview:scroll];
        _cellSize = CGSizeMake(70, 50);
        minPageNo = 1;
        minCellMargin = 20;
        cellHeight = 80;
        cellWidth = 80;
        self.clipsToBounds = YES;
        queue = [[NSOperationQueue alloc] init];
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
    UIScrollView *scroll = (UIScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
    NSArray *viewsToRemove = [scroll subviews];

    
    for(ThumbnailCell *cell in viewsToRemove)
    {
        if((cell.tag>=10000)&&(cell.tag<=(numberOfCells+10000)))
        {
            
            
            // Check if ThumbCells reached the bottom
            // if reached the bottom reset y and increase x
            
            if((((int)((x+cellWidth +margin)/self.frame.size.width))*self.frame.size.width)!=(x+cellWidth +margin) )
            {
                if(cell.tag!=10000)
                {
                    x += cellWidth +margin;
                    
                }
                
            }else 
            {
                x+=cellWidth +margin;
                if(cell.tag!=10000)
                {
                    if((y+cellHeight+margin)<=self.frame.size.height-100)
                    {
                        y += cellHeight + margin;
                        x -= self.frame.size.width-margin;
                    }else
                    {
                        x+=  margin;
                        y = 20;
                    }
                }
                
            }
            
            
            
            //set cell size
            cell.frame = CGRectMake(x, y, cellHeight, cellHeight);
            
            
            
        }
    }
    
    //calculate no of pages in pager
    int oldPageCount = pageCount;
    float perc = x/self.frame.size.width;
    pageCount = (int)((perc)+1.0);
    
    //calculate ThumbListView width
    int width  = pageCount * self.frame.size.width;
    
    
    

    
    
    
    // set scrollView content size
    
    CGPoint offset = scroll.contentOffset;
    float xratio = currentPage/oldPageCount;
    
    
    int newPage = xratio*pageCount;
    

    
    scroll.contentSize = CGSizeMake(width, self.frame.size.height);
    
    CGPoint newoffset = CGPointMake(newPage*self.frame.size.width, offset.y);
    [scroll setContentOffset:newoffset];
    
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(newSuperview)
    {
        [super willMoveToSuperview:newSuperview];

        [self ReloadData];
        
    }
}
-(void)ThumbSelected:(id)sender
{
    ThumbnailCell *cell = (ThumbnailCell*)sender;
    int index = cell.tag-10000;
    if([_DataSource respondsToSelector:@selector(thumbnailList:didSelectThumbAtIndex:)])
    {
        [_DataSource thumbnailList:self didSelectThumbAtIndex:index];
    }
}

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
    UIScrollView *scroll = (UIScrollView*)[self viewWithTag:SCROLL_VIEW_TAG];
    NSArray *viewsToRemove = [scroll subviews];
    for (UIView *v in viewsToRemove) {
        if((v.tag>=10000)&&(v.tag<=(numberOfCells+10000)))
        {
            [v removeFromSuperview];
        }
    }
    
    for(int i=0;i<numberOfCells;i++)
    {
        if([self.DataSource respondsToSelector:@selector(thumbnailList:cellForIndex:)])
        {
            ThumbnailCell *cell = [_DataSource thumbnailList:list cellForIndex:i];
            
            [cell addTarget:list action:@selector(ThumbSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            // Check if ThumbCells reached the bottom
            // if reached the bottom reset y and increase x
            
            if((((int)((x+cellWidth +margin)/self.frame.size.width))*self.frame.size.width)!=(x+cellWidth +margin) )
            {
                if(i!=0)
                {
                    x += cellWidth +margin;
                    
                }
                
            }else //if((y+cellHeight+margin)<=self.frame.size.height-20)
            {
                x+=cellWidth +margin;
                if(i!=0)
                {
                    if((y+cellHeight+margin)<=self.frame.size.height-100)
                    {
                        y += cellHeight + margin;
                        x -= self.frame.size.width-margin;
                    }else
                    {
                        x+=  margin;
                        y = 20;
                    }
                }
                
            }
            
            
            
            //set cell size
            cell.frame = CGRectMake(x, y, cellHeight, cellHeight);
            
            cell.tag = i+10000;
            
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
    
    
    
    

    
    
    
    // set scrollView content size
    scroll.contentSize = CGSizeMake(width, self.frame.size.height);
    

    
    
  
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    if (sender.dragging) {
        // scrolling is caused by user
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        currentPage = (page % pageCount);
        sender = nil;
    }
    
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

-(void)AddButtonTouched{
    if([_DataSource respondsToSelector:@selector(AddButtonTouched)])
    {
        [_DataSource AddButtonTouched];
    }
}
-(void)RearrangeButtonTouched
{
    if([_DataSource respondsToSelector:@selector(RearrangeButtonTouched)])
    {
        [_DataSource RearrangeButtonTouched];
    }
}
@end
