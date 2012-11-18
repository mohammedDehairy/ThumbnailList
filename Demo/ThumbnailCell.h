//
//  ThumbnailCell.h
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@interface ThumbnailCell : EGOImageButton
{
    CGRect originalRect;
}
@property(nonatomic) CGRect originalRect;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)img;
-(id)initWithFrame:(CGRect)frame withImageFromUrl:(NSURL*)imgurl withPlaceHolderImage:(NSString*)img;

@end
