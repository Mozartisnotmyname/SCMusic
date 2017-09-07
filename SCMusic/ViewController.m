//
//  ViewController.m
//  BaiduMusic
//
//  Created by 凌       陈 on 8/18/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "OMHotSongInfo.h"
#import "QJSlideButtonView.h"
#import "QJBigScrollView.h"


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self confingSlideButtonView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化界面配置
- (void)confingSlideButtonView
{
    // 设置导航栏title
    self.title = @"SC音乐";
    
    // 设置SlideButtonView的title
    NSArray *titleArr = @[@"新歌榜",@"热歌榜",@"经典老歌榜",@"网路歌曲榜",@"影视金曲榜",@"欧美金曲榜"];
    
    QJSlideButtonView *s = [[QJSlideButtonView alloc] initWithcontroller:self TitleArr:titleArr];
    QJBigScrollView *b = [[QJBigScrollView alloc] initWithcontroller:self TitleArr:titleArr];
    
    __weak typeof(s) Sweak = s;
    __weak typeof(b) Bweak = b;
    b.Bgbolck = ^(NSInteger index){
        [Sweak setSBScrollViewContentOffset:index];
    };
    s.sbBlock = ^(NSInteger index){
        [Bweak setBgScrollViewContentOffset:index];
    };
}




@end
