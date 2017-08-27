//
//  DetailPlayControlView.m
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "DetailPlayControlView.h"


#define SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)


extern MusicPlayerManager *musicPlayer;
extern OMSongInfo *songInfo;

@implementation DetailPlayControlView


int lrcIndex = 0;


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    // top view初始化
    _topview = [[TopView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / 5)];
    [self addSubview:_topview];

    // mid view 初始化
    _midView = [[MidView alloc] initWithFrame:CGRectMake(0, frame.size.height / 5, frame.size.width, frame.size.height / 5 * 3)];
    [self addSubview:_midView];

    // bottom view 初始化
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, frame.size.height / 5 * 4, frame.size.width, frame.size.height / 5)];
    [self addSubview:_bottomView];
    
    // 添加playOrPauseButton响应事件
    [_bottomView.playOrPauseButton addTarget:self action:@selector(playOrPauseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加nextSongButton响应事件
    [_bottomView.nextSongButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加preButton响应事件
    [_bottomView.preSongButtton addTarget:self action:@selector(preButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加shuffleAndRepeat响应事件
    [_bottomView.playModeButton addTarget:self action:@selector(shuffleAndRepeat) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加songListButton响应事件
    [_bottomView.songListButton addTarget:self action:@selector(songListButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 播放进度条添加响应事件
    [_bottomView.songSlider addTarget:self //事件委托对象
                                           action:@selector(playbackSliderValueChanged) //处理事件的方法
                                 forControlEvents:UIControlEventValueChanged//具体事件
     ];
    [_bottomView.songSlider addTarget:self //事件委托对象
                                           action:@selector(playbackSliderValueChangedFinish) //处理事件的方法
                                 forControlEvents:UIControlEventTouchUpInside//具体事件
     ];
    
    [self setBackgroundImage:[UIImage imageNamed:@"backgroundImage3"]];
    [self getShuffleAndRepeatState];
    
    return self;
}

#pragma - mark 播放设置
-(void) playSetting {
    
    if (musicPlayer.play.rate == 1) {
        NSLog(@"播放！");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        
    } else {
        NSLog(@"暂停");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView stopRotating];
    }

}

#pragma - mark 设置detail控制界面背景图片
-(void) setBackgroundImage: (UIImage *)image {
    
     _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
//    _backgroundImageView.frame =  CGRectMake(-UIScreen.mainScreen.bounds.size.width / 2, -UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width * 2, UIScreen.mainScreen.bounds.size.height * 2);
    _backgroundImageView.image = image;
    _backgroundImageView.clipsToBounds = true;
    [self addSubview:_backgroundImageView];
    [self sendSubviewToBack:_backgroundImageView];
    
    // 毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.alpha = 1.0;
    visualView.frame = CGRectMake(-UIScreen.mainScreen.bounds.size.width / 2, -UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width * 2, UIScreen.mainScreen.bounds.size.height * 2);
    visualView.clipsToBounds = true;
    [_backgroundImageView addSubview:visualView];
}

#pragma - mark 播放或暂停
-(void) playOrPauseButtonAction {

    if (musicPlayer.play.rate == 0) {
         NSLog(@"播放！");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
        
    } else {
         NSLog(@"暂停");
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView stopRotating];
        [musicPlayer stopPlay];
    }
   
}

#pragma - mark 下一曲
-(void) nextButtonAction {
    
    musicPlayer.playingIndex = songInfo.playSongIndex;
    
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode:
        {
            musicPlayer.playingIndex++;
            if (musicPlayer.playingIndex >= songInfo.OMSongs.count)//最后一首了
            {
                musicPlayer.playingIndex = 0;              //跳到第一首
            }
        }
            break;
        case RepeatOnlyOnePlayMode:
        {
            
        }
            break;
        case ShufflePlayMode:
        {
            if (musicPlayer.playingIndex == songInfo.OMSongs.count - 1)//最后一首了
            {
                musicPlayer.playingIndex = [self getRandomNumber:0 with:(songInfo.OMSongs.count - 2)];//重头开始不包括本首歌
            }
            else
            {
                musicPlayer.playingIndex = [self getRandomNumber:(musicPlayer.playingIndex + 1) with:(songInfo.OMSongs.count - 1)];//不包括本首歌
            }
        }
            break;
        default:
            break;
    }
    
    if ( musicPlayer.playingIndex != songInfo.playSongIndex ) {
        if (songInfo.playSongIndex < songInfo.OMSongs.count) {
            OMHotSongInfo *info = songInfo.OMSongs[ musicPlayer.playingIndex];
            NSLog(@"即将播放下一首歌曲: 《%@》", info.title);
            [songInfo setSongInfo:info];
            [songInfo getSelectedSong:info.song_id index:songInfo.playSongIndex + 1];
            
        }
    } else {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"repeatPlay" object:self];
    }
    
}

#pragma - mark 上一曲
-(void) preButtonAction {
    
    musicPlayer.playingIndex = songInfo.playSongIndex;
    
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode:
        {
            if ( musicPlayer.playingIndex == 0)//第一首
            {
                 musicPlayer.playingIndex = songInfo.OMSongs.count - 1;  //跳到最后一首
            }
            else
            {
                 musicPlayer.playingIndex--;    //索引为上一首
            }
        }
            break;
        case RepeatOnlyOnePlayMode:
        {
            
        }
            break;
        case ShufflePlayMode:
        {
            if ( musicPlayer.playingIndex == 0)//是第一首歌
            {
                 musicPlayer.playingIndex = [self getRandomNumber:1 with:(songInfo.OMSongs.count - 1)];//播放除第一首歌之外的所有歌曲
            }
            
            else
            {
                 musicPlayer.playingIndex = [self getRandomNumber:0 with:( musicPlayer.playingIndex - 1)];
            }
        }
            break;
        default:
            break;
    }
    
    if ( musicPlayer.playingIndex != songInfo.playSongIndex ) {
        if (songInfo.playSongIndex > 0) {
            OMHotSongInfo *info = songInfo.OMSongs[songInfo.playSongIndex - 1];
            NSLog(@"即将播放上一首歌曲: 《%@》", info.title);
            [songInfo setSongInfo:info];
            [songInfo getSelectedSong:info.song_id index:songInfo.playSongIndex - 1];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"repeatPlay" object:self];
    }

}

#pragma - mark 播放模式
-(void) shuffleAndRepeat {
    

    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode://只循环不随机
        {

            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatOnlyOnePlayMode;  //单曲循环
        }
            break;
        case RepeatOnlyOnePlayMode://只单曲播放
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = ShufflePlayMode;
        }
            break;
        case ShufflePlayMode://随机播放
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatPlayMode;
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:musicPlayer.shuffleAndRepeatState] forKey:@"SHFFLEANDREPEATSTATE"];//存储路径
}

#pragma - mark 歌曲列表
-(void) songListButtonAction {
    NSLog(@"你按下了songList按键！");
}


#pragma - mark 进度条改变值时触发
//拖动进度条改变值时触发
-(void) playbackSliderValueChanged {
    
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
        
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
    }
}

#pragma - mark 进度条改变值结束时触发
-(void) playbackSliderValueChangedFinish {
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
        
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_bottomView.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_midView.midIconView.imageView resumeRotate];
        [musicPlayer startPlay];
        
    }
}

#pragma - mark 更新播放时间
-(void) updateTime {
    
    CMTime duration = musicPlayer.play.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(_bottomView.songSlider.value) * completeTime;
    
    //播放器定位到对应的位置
    CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
    [musicPlayer.play seekToTime:targetTime];
    
    int index = 0;
    for (NSString *indexStr in songInfo.mTimeArray) {
        if ((int)currentTime < [songInfo stringToInt:indexStr]) {
            songInfo.lrcIndex = index;
        } else {
            index = index + 1;
        }
    }
}

#pragma - mark 获取保存的播放模式
- (void)getShuffleAndRepeatState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *repeatAndShuffleNumber = [defaults objectForKey:@"SHFFLEANDREPEATSTATE"];
    if (repeatAndShuffleNumber == nil)
    {
        musicPlayer.shuffleAndRepeatState = RepeatPlayMode;
    }
    else
    {
        musicPlayer.shuffleAndRepeatState = (ShuffleAndRepeatState)[repeatAndShuffleNumber integerValue];
    }
    
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode:
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
        }
            break;
        case RepeatOnlyOnePlayMode:
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
        }
            break;
        case ShufflePlayMode:
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
            break;
        default:
            break;
        }
    }
}

#pragma - mark 获取随机数，用于随机播放
-(NSUInteger) getRandomNumber:(NSUInteger)from with:(NSUInteger)to//包括两边边界
{
    NSUInteger res =  from + (arc4random() % (to - from + 1));
    return res;
}

@end
