//
//  ThumbnailListViewController.m
//  ThumbnailListView
//
//  Created by Mohammed Eldehairy on 10/18/12.
//  Copyright (c) 2012 Mohammed Eldehairy. All rights reserved.
//

#import "ThumbnailListViewController.h"

@interface ThumbnailListViewController ()

@end

@implementation ThumbnailListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    index1 = 0;
    ThumbnailList *list = [[ThumbnailList alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withDataSource:self];
    list.tag = 11;
    [self.view addSubview:list];
	
}
-(void)Edit
{
    UIBarButtonItem *btn = self.navigationItem.rightBarButtonItem;
     ThumbnailList *list = (ThumbnailList*)[self.view viewWithTag:11];
    if([btn.title isEqualToString:@"Edit"])
    {
    
        btn.title = @"Done";
       
        list.EnableEdit = YES;
    }else
    {
        btn.title = @"Edit";
        
        list.EnableEdit = NO;
    }
    
}
-(void)thumbnailList:(ThumbnailList *)list didSelectThumbAtIndex:(int)index
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"Cell selected" message:[NSString stringWithFormat:@"Cell no %d selected",index] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alter show];
}
-(int)numberOfcellsForthumbanilList:(ThumbnailList *)list
{
    return 20;
}
-(ThumbnailCell*)thumbnailList:(ThumbnailList *)list cellForIndex:(int)index
{
    index1++;
    if (index1>=5) {
        index1 = 0;
    }
    NSString *img =[NSString stringWithFormat:@"%@%d.png",@"alwatan",index1];
    ThumbnailCell *cell = [[ThumbnailCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withImage:img];
    return cell;
}
-(void)thumbnailList:(ThumbnailList *)list didSwapCellAtIndex:(int)sourceIndex withCellAtIndex:(int)destinationIndex
{
    //swap objects in data source and database
}
-(void)thumbnailList:(ThumbnailList *)list didDeleteCellAtIndex:(int)index
{
    //cell deleted
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
   /* ThumbnailList *list = (ThumbnailList*)[self.view viewWithTag:11];
    [list orientationChanged:toInterfaceOrientation];*/
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)RearrangeButtonTouched
{
    
}
-(void)AddButtonTouched
{
    
}
@end
