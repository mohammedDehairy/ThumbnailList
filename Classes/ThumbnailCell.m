//
//  ThumbnailCell.m
//  ArabicNews1.0
//
//  Created by Mohammed Eldehairy on 10/16/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "ThumbnailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
@implementation ThumbnailCell
@synthesize originalRect ;
@synthesize ThumbnailCellDelegate;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)img
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[[UIImage imageNamed:img] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal] ;
        //self.layer.cornerRadius = 10;
        //self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 3.0f;
        self.exclusiveTouch = YES;
    }
    return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if([self.ThumbnailCellDelegate respondsToSelector:@selector(CellTouched:)])
    {
        [self.ThumbnailCellDelegate CellTouched:self];
    }
}

-(id)initWithFrame:(CGRect)frame withImageFromUrl:(NSURL*)imgurl withPlaceHolderImage:(NSString*)img
{
    self = [super initWithPlaceholderImage:[UIImage imageNamed:img]];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.imageURL = imgurl;
        //self.layer.cornerRadius = 10;
        //self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.0f;
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(!newSuperview) {
		[self cancelImageLoad];
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
