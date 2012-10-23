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
    ThumbnailList *list = [[ThumbnailList alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 300)];
    //[list setPageNumberLabelBackgroundColor:[UIColor redColor]];
    list.DataSource = self;
    [self.view addSubview:list];
    
	// Do any additional setup after loading the view, typically from a nib.
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
    if (index1>=7) {
        index1 = 0;
    }
    NSString *img =[NSString stringWithFormat:@"%@%d.png",@"alwatan",index1];
    ThumbnailCell *cell = [[ThumbnailCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withImage:img];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
