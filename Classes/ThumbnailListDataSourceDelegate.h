//
//  ThumbnailListDataSourceDelegate.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThumbnailCell.h"
@class ThumbnailList;
@protocol ThumbnailListDataSourceDelegate <NSObject>
-(ThumbnailCell*)thumbnailList:(ThumbnailList*) list cellForIndex:(int)index;
-(int)numberOfcellsForthumbanilList:(ThumbnailList *) list ;
@optional
-(void)thumbnailList:(ThumbnailList *) list didSelectThumbAtIndex:(int)index;
-(void)thumbnailList:(ThumbnailList*) list didSwapCellAtIndex:(int) sourceIndex withCellAtIndex:(int) destinationIndex;
-(void)thumbnailList:(ThumbnailList*) list didDeleteCellAtIndex:(int) index;
@end
