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
#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 0.1
@implementation ThumbnailCell
@synthesize originalRect ;
@synthesize ThumbnailCellDelegate;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)img
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        EGOImageButton *imageBtn = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:img]  delegate:self];
        
        [imageBtn setFrame:CGRectMake(0, 0, 80, 80)] ;
        imageBtn.tag = IMAGE_BTN_TAG;
        [imageBtn addTarget:self action:@selector(ImageBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];

        imageBtn.layer.borderColor = [UIColor grayColor].CGColor;
        imageBtn.layer.borderWidth = 3.0f;
        self.exclusiveTouch = YES;
        UIButton *CloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [CloseBtn setImage:[UIImage imageNamed:@"Close1.png"] forState:UIControlStateNormal];
        [CloseBtn addTarget:self action:@selector(CloseBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        CloseBtn.frame = CGRectMake(-10, -10, 35, 35);
        [CloseBtn setHidden:YES];
        CloseBtn.tag = DELETE_BTN_TAG;
        [self addSubview:CloseBtn];
       
    }
    return self;
}
-(void)ImageBtnTouched:(id)sender
{
    if([self.ThumbnailCellDelegate respondsToSelector:@selector(CellTouched:)])
    {
        [self.ThumbnailCellDelegate CellTouched:self];
    }
}
-(EGOImageButton*)getImageButton
{
    return (EGOImageButton*)[self viewWithTag:IMAGE_BTN_TAG];
}
-(UIButton*)getDeleteBtn
{
    return (UIButton*)[self viewWithTag:DELETE_BTN_TAG];
}

-(void)EnterEditMode
{
    [[self getDeleteBtn] setHidden:NO];
    
    NSInteger randomInt = arc4random()%500;
    float r = (randomInt/500.0)+0.5;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDeg * -1.0) - r ));
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg + r ));
    
    self.transform = leftWobble;  // starting point
    
    [[self layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         [UIView setAnimationRepeatCount:NSNotFound];
                         self.transform = rightWobble; }
                     completion:nil];
}
-(void)ExitEditMode
{
    [[self getDeleteBtn] setHidden:YES];
    
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
}
-(void)CloseBtnTouched:(id)sender
{
    if([self.ThumbnailCellDelegate respondsToSelector:@selector(DeleteBtnTouchedForCell:)])
    {
        [self.ThumbnailCellDelegate DeleteBtnTouchedForCell:self];
    }
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
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        EGOImageButton *imageBtn = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:img] delegate:self];
        
        [imageBtn setImage:[[UIImage imageNamed:img] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal] ;
        imageBtn.tag = IMAGE_BTN_TAG;
        
        [self addSubview:imageBtn];

        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.0f;
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(!newSuperview) {
		[[self getImageButton] cancelImageLoad];
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
