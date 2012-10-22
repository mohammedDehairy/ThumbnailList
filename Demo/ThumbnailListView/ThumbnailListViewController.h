//
//  ThumbnailListViewController.h
//  ThumbnailListView
//
//  Created by Mohammed Eldehairy on 10/18/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailList.h"
@interface ThumbnailListViewController : UIViewController <ThumbnailListDataSourceDelegate>
{
    NSArray *datasource;
    int index1;
}
@end
