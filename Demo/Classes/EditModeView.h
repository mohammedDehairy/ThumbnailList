//
//  EditModeView.h
//  ThumbnailListView
//
//  Created by Mohammed Eldehairy on 10/24/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditModeDelegate.h"
@interface EditModeView : UIView
{
    id<EditModeDelegate> _delegate;
    BOOL expanded ;
}
@property(nonatomic)BOOL EditOn;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<EditModeDelegate>) delegate;
-(IBAction)AddBtn:(id)sender;
-(IBAction)RearrangeBtn:(id)sender;
-(IBAction)ExpandExtract:(id)sender;
@end
