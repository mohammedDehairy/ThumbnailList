//
//  ThumbnailList.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailListDataSourceDelegate.h"

@interface ThumbnailList : UIView<UIScrollViewDelegate>
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
    
}
@property(nonatomic,retain)id<ThumbnailListDataSourceDelegate> DataSource;
@property(nonatomic)CGSize cellSize;
-(void)ReloadData;
@end
