//
//  EditModeView.m
//  ThumbnailListView
//
//  Created by Mohammed Eldehairy on 10/24/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "EditModeView.h"
#import <QuartzCore/QuartzCore.h>
@implementation EditModeView
@synthesize EditOn = _EditOn;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<EditModeDelegate>) delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        // Initialization code
        UIView *xib = [[[NSBundle mainBundle] loadNibNamed:@"EditModeView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(frame.origin.x, -(xib.frame.size.height-20), xib.frame.size.width, xib.frame.size.height);
        [self addSubview:xib];
        xib.layer.cornerRadius = 10;
        _delegate = delegate ;
        expanded = NO;
        _EditOn = NO;
        [_delegate retain];
        
    }
    return self;
}
-(void)ExpandExtract:(id)sender
{
    UIButton *Edit = (UIButton*)[self viewWithTag:2];
    [Edit setImage:[UIImage imageNamed:@"thumbs_001934-black-inlay-steel-square-icon-media-media2-arrow-down1.png"] forState:UIControlStateNormal];
    if(expanded==YES)
    {
        [UIView animateWithDuration:0.2 animations:^(void){
        
            self.frame = CGRectMake(self.frame.origin.x, -(self.frame.size.height-20), self.frame.size.width, self.frame.size.height);
            [Edit setImage:[UIImage imageNamed:@"thumbs_001934-black-inlay-steel-square-icon-media-media2-arrow-down.png"] forState:UIControlStateNormal];
            expanded = NO;
        
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^(void){
            
            self.frame = CGRectMake(self.frame.origin.x, -10, self.frame.size.width, self.frame.size.height);
            [Edit setImage:[UIImage imageNamed:@"thumbs_001934-black-inlay-steel-square-icon-media-media2-arrow-down1.png"] forState:UIControlStateNormal];
            expanded = YES;
            
        }];
    }
}
-(void)AddBtn:(id)sender{

    if([_delegate respondsToSelector:@selector(AddButtonTouched)])
    {
        [_delegate AddButtonTouched];
    }
}
-(void)RearrangeBtn:(id)sender
{
    UIButton *Edit = (UIButton*)[self viewWithTag:1];
    if(_EditOn==YES)
    {

        [Edit setTitle:@"Edit" forState:UIControlStateNormal]  ;
        _EditOn = NO;
        
    }else
    {
        [Edit setTitle:@"Done" forState:UIControlStateNormal]  ;
        _EditOn = YES;
    }
    
    if([_delegate respondsToSelector:@selector(RearrangeButtonTouched)])
    {
        [_delegate RearrangeButtonTouched];
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
