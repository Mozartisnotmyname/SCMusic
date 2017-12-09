//
//  NavigationViewController.m
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "NavigationViewController.h"


@implementation NavigationViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.navigationBar setBarTintColor:UIColorFromRGB(0x5c8aea)];

    [self navigationBarSettting];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// -------------------------------------------------------------------------------
//    navigationBarSettting:
//  Setting navigationBar
// -------------------------------------------------------------------------------
-(void) navigationBarSettting {
    
    [self.navigationBar setBarTintColor:UIColorFromRGB(0xff0000)];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    // 去掉导航分割线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}


@end
