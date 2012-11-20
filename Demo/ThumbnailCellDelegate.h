//
//  ThumbnailCellDelegate.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 11/18/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThumbnailCellDelegate <NSObject>
-(void)CellTouched:(id)sender;
-(void)DeleteBtnTouchedForCell:(id)cell;
@end
