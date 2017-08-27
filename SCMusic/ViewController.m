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



@interface ViewController ()
{
 
}

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    musicPlayer = MusicPlayerManager.sharedInstance;
//    onlineMusicArray = [NSArray arrayWithObjects:@"热歌榜",@"热门歌手",@"新碟上架",nil];
//    
//    _songTableView.delegate = self;
//    _songTableView.dataSource = self;
//    
//    [self loadHotSongs];
    
    self.title = @"SC音乐";
    [self confingSlideButtonView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confingSlideButtonView
{
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
