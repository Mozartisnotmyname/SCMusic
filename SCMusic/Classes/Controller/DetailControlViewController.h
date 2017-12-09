//
//  DetailControlViewController.h
//  SCNews
//
//  Created by 凌       陈 on 11/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "MidView.h"
#import "BottomView.h"
#import "OMSongInfo.h"
#import "MusicPlayerManager.h"
#import "OMHotSongInfo.h"
#import "SongListView.h"
#import "Const.h"


@interface DetailControlViewController : UIViewController

// 底部弹出View
@property (nonatomic ,strong) SongListView *songListView;   // 底部View
@property (nonatomic ,strong) UIView *shadowView;           // 阴影部分
@property(nonatomic, strong) TopView *topView;              // SongListView的topView
@property(nonatomic, strong) MidView *midView;
@property(nonatomic, strong) BottomView *bottomView;
@property(nonatomic, strong) UIImageView *backgroundImageView;

-(void) setBackgroundImage: (UIImage *)image;
-(void) playStateRecover;

@end
