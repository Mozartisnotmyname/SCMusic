//
//  RootViewController.h
//  BaiduMusic
//
//  Created by 凌       陈 on 8/18/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MJExtension.h"
#import "OMHotSongInfo.h"
#import "OMSongInfo.h"
#import "MusicPlayerManager.h"
#import "OMHotSongInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>
#import "SCImageView.h"
#import "DetailControlViewController.h"
#import "Const.h"
#import "TTTopChannelContianerView.h"
#import "ContentTableViewController.h"
#import "Masonry.h"

@interface RootViewController : UIViewController <UIScrollViewDelegate,TTTopChannelContianerViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;
@property (nonatomic, strong) DetailControlViewController *detailController;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *arrayLists;


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

