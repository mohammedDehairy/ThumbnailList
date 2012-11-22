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
#define TITLE_LABEL_TAG 101
@interface ThumbnailCell : UIView<EGOImageButtonDelegate>
{
    CGRect originalRect;
}
@property(nonatomic) CGRect originalRect;
@property(nonatomic,retain)id<ThumbnailCellDelegate> ThumbnailCellDelegate;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)img;

-(void)EnterEditMode;
-(void)ExitEditMode;
-(void)setTitle:(NSString*)title;
@end
