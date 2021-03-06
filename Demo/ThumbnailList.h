//
//  ThumbnailList.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailListDataSourceDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ThumbnailCellDelegate.h"
#define RIGHT_NAV_TAG 88
#define SCROLL_VIEW_TAG 1
#define PAGE_NO_LABEL_TAG 33
#define LEFT_NAV_TAG 55
@interface ThumbnailList : UIView<UIScrollViewDelegate,ThumbnailCellDelegate,UIAlertViewDelegate>
{
@private
    int minPageNo;
    int numberOfCells;
    int cellHeight;
    int cellWidth;
    int minCellMargin;
    int currentPage;
    int LastCellIndexAdded;
    int LastX;
    CGPoint LastContentOffset;
    BOOL ScrollRight;
    NSMutableArray *PagesLoaded;
    NSOperationQueue *queue;
    int pageCount;
    BOOL subviewLayed;
    int LastnumberOfCellsInPage;
    BOOL draggingEnabled;
    BOOL editEnabled;
    id<ThumbnailListDataSourceDelegate> DataSource;
}
@property(nonatomic)CGSize cellSize;
@property(nonatomic)BOOL LongPressToEditEnabled;
-(void)ReloadData;
-(void)orientationChanged:(UIInterfaceOrientation)orientaion;
-(void)setEnableEdit:(BOOL)value;
-(BOOL)getEnableEdit;
- (id)initWithFrame:(CGRect)frame withDataSource:(id<ThumbnailListDataSourceDelegate>) datasource;
-(void)InsertCell:(ThumbnailCell*)Addedcell AtIndex:(int)index;
-(void)DeleteCellAtIndex:(int)index animated:(BOOL) animated;
@end