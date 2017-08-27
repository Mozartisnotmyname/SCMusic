//
//  NavigationViewController.h
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMSongInfo.h"
#import "MusicPlayerManager.h"
#import "OMHotSongInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "wslAnalyzer.h"
#import "wslLrcEach.h"
#import "SCImageView.h"
#import "DetailPlayControlView.h"

@interface NavigationViewController : UINavigationController

// 底部弹出View
@property (nonatomic ,strong) DetailPlayControlView *deliverView; //底部View
@property (nonatomic ,strong) UIView *BGView; //遮罩

//当前歌词所在位置
@property (nonatomic,assign)  NSInteger currentRow;


//锁屏图片视图,用来绘制带歌词的image
@property (nonatomic, strong) UIImageView * lrcImageView;
@property (nonatomic, strong) UIImage * lastImage;//最后一次锁屏之后的歌词海报

// playControllerView 控件
@property (nonatomic, strong) UIView *playControllerView;
@property (nonatomic, strong) SCImageView *currentPlaySongImage;
@property (nonatomic, strong) UIButton *playAndPauseButton;
@property (nonatomic, strong) UIButton *nextSongButton;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *singerName;

@property (nonatomic, strong) id playerTimeObserver;

@end
