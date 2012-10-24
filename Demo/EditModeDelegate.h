//
//  EditModeDelegate.h
//  ThumbnailListView
//
//  Created by Mohammed Eldehairy on 10/24/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditModeDelegate <NSObject>
-(void)AddButtonTouched;
-(void)RearrangeButtonTouched;
@end
