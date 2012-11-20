//
//  ThumbnailCell.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "ThumbnailCellDelegate.h"
#define DELETE_BTN_TAG 15
#define IMAGE_BTN_TAG 10
@interface ThumbnailCell : UIView<EGOImageButtonDelegate>
{
    CGRect originalRect;
}
@property(nonatomic) CGRect originalRect;
@property(nonatomic,retain)id<ThumbnailCellDelegate> ThumbnailCellDelegate;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)img;
-(id)initWithFrame:(CGRect)frame withImageFromUrl:(NSURL*)imgurl withPlaceHolderImage:(NSString*)img;
-(void)EnterEditMode;
-(void)ExitEditMode;
@end
