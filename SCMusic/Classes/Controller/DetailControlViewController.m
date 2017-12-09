//
//  DetailControlViewController.m
//  SCNews
//
//  Created by 凌       陈 on 11/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "DetailControlViewController.h"


extern MusicPlayerManager *musicPlayer;
extern OMSongInfo *songInfo;

@implementation DetailControlViewController

int lrcIndex = 0;

-(instancetype) init {
    self = [super init];
    if (self) {
        // 初始化SubView
        [self configSubView];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getShuffleAndRepeatState];
}

-(void) viewWillAppear:(BOOL)animated {
    [self playStateRecover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configSubView
-(void) configSubView {
    // 初始化musicPlayer和songInfo
    musicPlayer = MusicPlayerManager.sharedManager;
    songInfo = OMSongInfo.sharedManager;
    
    // top view初始化
    _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 5)];
    [_topView.backBtn addTarget:self action:@selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
    // mid view 初始化
    _midView = [[MidView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5, self.view.frame.size.width, self.view.frame.size.height / 5 * 3)];
    [self.view addSubview:_midView];
    
    // bottom view 初始化
    _bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 5 * 4, self.view.frame.size.width, self.view.frame.size.height / 5)];
    [self.view addSubview:_bottomView];
    
    // SongListView初始化
    _songListView                 = [[SongListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.618)];
    _songListView.backgroundColor = [UIColor whiteColor];
    
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
    
    // 设置背景图片
    [self setBackgroundImage:[UIImage imageNamed:@"backgroundImage3"]];
}

#pragma mark - 状态恢复
-(void) playStateRecover {
    
    [_midView.midIconView.imageView startRotating];
    
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
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-UIScreen.mainScreen.bounds.size.width / 2, -UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width * 2, UIScreen.mainScreen.bounds.size.height * 2)];
    _backgroundImageView.image = image;
    _backgroundImageView.clipsToBounds = true;
    [self.view addSubview:_backgroundImageView];
    [self.view sendSubviewToBack:_backgroundImageView];
    
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


#pragma - mark 歌曲列表
-(void) songListButtonAction {
    NSLog(@"你按下了songList按键！");
    
    // 设置播放模式
    [_songListView setPlayModeButtonState];
    
    // 剩下阴影部分
    _shadowView                 = [[UIView alloc] init];
    _shadowView.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight * (1.0 - 0.618));
    _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];


    // UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    // 阴影部分view
    [appWindow addSubview:_shadowView];
    // 底部弹出的SongListView
    [appWindow addSubview:_songListView];
  
    // 给阴影部分添加的点击事件，单击隐藏SongListView
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseGlide)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [_shadowView addGestureRecognizer:gesture];
    
    // 向下滑动退出
    //UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responseGlide)];
    //[recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    //[_songListView  addGestureRecognizer:recognizer];
    
    
    // SongListView弹出动画
    _songListView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight);
    _shadowView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        _shadowView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        _songListView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight * (1.0 - 0.618));
        
    } completion:^(BOOL finished){
        
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
}

#pragma mark - 下滑退出detail控制界面
- (void)responseGlide {
    
    // 设置播放模式
    [self setShuffleAndRepeatState];
    
    // SongListView隐藏动画
    [UIView animateWithDuration:0.3 animations:^{
        
        _songListView.transform = CGAffineTransformMakeTranslation(0.0, ScreenHeight);
        _shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_shadowView removeFromSuperview];
        [_songListView removeFromSuperview];
    }];
    
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


#pragma - mark 播放模式按键action
-(void) shuffleAndRepeat {
    
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode:
        {
            
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatOnlyOnePlayMode;  //单曲循环
            [self showMiddleHint:@"单曲循环"];
        }
            break;
        case RepeatOnlyOnePlayMode:
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = ShufflePlayMode;
            [self showMiddleHint:@"列表播放"];
        }
            break;
        case ShufflePlayMode:
        {
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [_bottomView.playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatPlayMode;
            [self showMiddleHint:@"随机播放"];
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:musicPlayer.shuffleAndRepeatState] forKey:@"SHFFLEANDREPEATSTATE"];//存储路径
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

#pragma - mark 设置播放模式
-(void) setShuffleAndRepeatState {
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:musicPlayer.shuffleAndRepeatState] forKey:@"SHFFLEANDREPEATSTATE"];//存储路径
}


#pragma mark - 播放模式提示框
- (void)showMiddleHint:(NSString *)hint {
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0.f, 0.f);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

-(void) backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - mark 获取随机数，用于随机播放
-(NSUInteger) getRandomNumber:(NSUInteger)from with:(NSUInteger)to//包括两边边界
{
    NSUInteger res =  from + (arc4random() % (to - from + 1));
    return res;
}

@end
