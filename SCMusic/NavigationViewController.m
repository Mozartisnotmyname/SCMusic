//
//  NavigationViewController.m
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "NavigationViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)

MusicPlayerManager *musicPlayer;
OMSongInfo *songInfo;

@implementation NavigationViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.navigationBar setBarTintColor:UIColorFromRGB(0x5c8aea)];
    musicPlayer = MusicPlayerManager.sharedManager;
    songInfo = OMSongInfo.sharedManager;
    
    [self.navigationBar setBarTintColor:UIColorFromRGB(0xff0000)];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    // 去掉导航分割线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];

    // 主页控制View
    _playControllerView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height * 0.88, Screen_Width, Screen_Height * 0.12)];
    _playControllerView.backgroundColor = UIColorFromRGB(0xff0000);
    _playControllerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_playControllerView addGestureRecognizer:tapGesturRecognizer];
    
    // detail控制View
    _deliverView                 = [[DetailPlayControlView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _deliverView.backgroundColor = [UIColor redColor];


    
    // 专辑图片
    _currentPlaySongImage = [[SCImageView alloc] initWithFrame:CGRectMake(10, 10 , _playControllerView.frame.size.height - 20 , _playControllerView.frame.size.height - 20)];
    _currentPlaySongImage.image = [UIImage imageNamed:@"album_default"];
    _currentPlaySongImage.clipsToBounds = true;
    _currentPlaySongImage.layer.cornerRadius = (_playControllerView.frame.size.height - 20) * 0.5;
    [_playControllerView addSubview:_currentPlaySongImage];
    
    //播放控制
    _playAndPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width * 0.7 , _playControllerView.frame.size.height * 0.4 , _playControllerView.frame.size.height * 0.6 , _playControllerView.frame.size.height* 0.6)];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
    [_playAndPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playControllerView addSubview:_playAndPauseButton];
    
    
    _nextSongButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width * 0.85 , _playControllerView.frame.size.height * 0.4 , _playControllerView.frame.size.height * 0.6 , _playControllerView.frame.size.height* 0.6)];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
     [_nextSongButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playControllerView addSubview:_nextSongButton];
    
    // 歌曲进度条
    _songSlider = [[UISlider alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height , 0 , _playControllerView.frame.size.width - _playControllerView.frame.size.height - 10 , _playControllerView.frame.size.height* 0.3)];
    [_songSlider setThumbImage:[UIImage imageNamed:@"cm2_efc_knob_trough_prs"] forState:UIControlStateNormal];
    _songSlider.tintColor = UIColorFromRGB(0xffffff);

    //设置slider响应事件
    [_songSlider addTarget:self //事件委托对象
               action:@selector(playbackSliderValueChanged) //处理事件的方法
     forControlEvents:UIControlEventValueChanged//具体事件
     ];
    [_songSlider addTarget:self //事件委托对象
               action:@selector(playbackSliderValueChangedFinish) //处理事件的方法
     forControlEvents:UIControlEventTouchUpInside//具体事件
     ];
    [_playControllerView addSubview:_songSlider];
    
    // 歌名和歌手名
    _songName = [[UILabel alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height ,  _playControllerView.frame.size.height* 0.3 , _playControllerView.frame.size.width * 0.5 , _playControllerView.frame.size.height* 0.4)];
//    songName.backgroundColor = [UIColor blackColor];
    _songName.text = @"亲爱的小猪";
    _songName.textColor = [UIColor whiteColor];
    _songName.font = [UIFont systemFontOfSize:18.0];
    [_playControllerView addSubview:_songName];
    
    _singerName = [[UILabel alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height ,  _playControllerView.frame.size.height* 0.7 , _playControllerView.frame.size.width * 0.5 , _playControllerView.frame.size.height* 0.3)];
//    singerName.backgroundColor = [UIColor blackColor];
    _singerName.text = @"陈述创";
    _singerName.textColor = UIColorFromRGB(0xfafafa);
    _singerName.font = [UIFont systemFontOfSize:15.0];
    [_playControllerView addSubview:_singerName];
    
    
    [self.view addSubview:_playControllerView];
    
    [self createRemoteCommandCenter];
    
    // 设置KVO
    [songInfo addObserver:self forKeyPath:@"playSongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    [musicPlayer addObserver:self forKeyPath:@"finishPlaySongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playSongSetting)
                                                 name: @"repeatPlay"
                                               object: nil];
}

#pragma mark - 锁屏界面开启和监控远程控制事件
//锁屏界面开启和监控远程控制事件
- (void)createRemoteCommandCenter{
 
    // 远程控制命令中心 iOS 7.1 之后  详情看官方文档：https://developer.apple.com/documentation/mediaplayer/mpremotecommandcenter
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // MPFeedbackCommand对象反映了当前App所播放的反馈状态. MPRemoteCommandCenter对象提供feedback对象用于对媒体文件进行喜欢, 不喜欢, 标记的操作. 效果类似于网易云音乐锁屏时的效果
    
    //添加喜欢按钮
    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
    likeCommand.enabled = YES;
    likeCommand.localizedTitle = @"喜欢";
    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"喜欢");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //添加不喜欢按钮，这里用作“下一首”
    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
    dislikeCommand.enabled = YES;
    dislikeCommand.localizedTitle = @"下一首";
    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //标记
    MPFeedbackCommand *bookmarkCommand = commandCenter.bookmarkCommand;
    bookmarkCommand.enabled = YES;
    bookmarkCommand.localizedTitle = @"标记";
    [bookmarkCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"标记");
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制播放
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [musicPlayer.play pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制暂停
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [musicPlayer.play play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制上一曲
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一曲");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 远程控制下一曲
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一曲");
        [self nextButtonAction:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    //快进
    MPSkipIntervalCommand *skipBackwardIntervalCommand = commandCenter.skipForwardCommand;
    skipBackwardIntervalCommand.preferredIntervals = @[@(54)];
    skipBackwardIntervalCommand.enabled = YES;
    [skipBackwardIntervalCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        NSLog(@"你按了快进按键！");
        
        // 歌曲总时间
        CMTime duration = musicPlayer.play.currentItem.asset.duration;
        Float64 completeTime = CMTimeGetSeconds(duration);
        
        // 快进10秒
        _songSlider.value = _songSlider.value + 10 / completeTime;
        
        // 计算快进后当前播放时间
        Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
        
        // 播放器定位到对应的位置
        CMTime targetTime = CMTimeMake((int64_t)(currentTime), 1);
        [musicPlayer.play seekToTime:targetTime];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = musicPlayer.play.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [musicPlayer.play seekToTime:CMTimeMake(totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
}

#pragma mark - removeObserver
- (void)dealloc{
    [self removeObserver];
}

- (void)removeObserver{
    
    [musicPlayer.play removeTimeObserver:_playerTimeObserver];
    _playerTimeObserver = nil;
    
    [musicPlayer.play.currentItem cancelPendingSeeks];
    [musicPlayer.play.currentItem.asset cancelLoading];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.likeCommand removeTarget:self];
    [commandCenter.dislikeCommand removeTarget:self];
    [commandCenter.bookmarkCommand removeTarget:self];
    [commandCenter.nextTrackCommand removeTarget:self];
    [commandCenter.skipForwardCommand removeTarget:self];
    [commandCenter.changePlaybackPositionCommand removeTarget:self];
}


#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath  isEqual: @"playSongIndex"]) {
//        musicPlayer.finishPlaySongIndex = songInfo.playSongIndex;
        [self playSongSetting];
    }
    
    if ([keyPath  isEqual: @"finishPlaySongIndex"]) {
//        songInfo.playSongIndex = musicPlayer.finishPlaySongIndex;
        [self playSongSetting];
    }
    
}

#pragma mark - 播放音乐调用
-(void) playSongSetting {

    if (_playerTimeObserver != nil) {
        
        [musicPlayer.play removeTimeObserver:_playerTimeObserver];
        _playerTimeObserver = nil;
        
        [musicPlayer.play.currentItem cancelPendingSeeks];
        [musicPlayer.play.currentItem.asset cancelLoading];
        
    }
    

    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
    
    // 主页面控制界面信息设置
    _songName.text = songInfo.title;
    _singerName.text = songInfo.author;
    _currentPlaySongImage.image = songInfo.pic_small;
    [_currentPlaySongImage startRotating];
    
    // detail页面控制界面信息设置
    _deliverView.topview.songTitleLabel.text = songInfo.title;
    _deliverView.topview.singerNameLabel.text = [[@"- " stringByAppendingString:songInfo.author] stringByAppendingString:@" -"];
    [_deliverView.midView.midIconView setAlbumImage:songInfo.pic_big];
//    [_deliverView setBackgroundImage:songInfo.pic_small];
    [_deliverView.midView.midIconView.imageView startRotating];
    [_deliverView.midView.midLrcView AnalysisLRC:songInfo.lrcString];
    
    // 歌词index清零
    songInfo.lrcIndex = 0;
    
    
    [musicPlayer setPlayItem:songInfo.file_link];
    [musicPlayer setPlay];
    [musicPlayer startPlay];
    
    // 播放结束通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:musicPlayer.play.currentItem];

    
    _playerTimeObserver = [musicPlayer.play addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        NSLog(@"当前播放时间：%f", currentTime);
        
        CMTime total = musicPlayer.play.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        // 当前播放时间
        _deliverView.bottomView.currentTimeLabel.text = [songInfo intToString:(int)currentTime];
        // 总时间
        _deliverView.bottomView.durationTimeLabel.text =[songInfo intToString:(int)totalTime];
        
        _songSlider.value = (float) ( currentTime / totalTime );
        _deliverView.bottomView.songSlider.value = (float) ( currentTime / totalTime );
        
        
        // 设置歌词
//        if (songInfo.isLrcExistFlg == true) {
//            if (songInfo.lrcIndex < songInfo.mTimeArray.count - 1) {
//                
//                if ((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]]) {
//                    [_deliverView.midView.midLrcView setLrc_Index:songInfo.lrcIndex];
//                    songInfo.lrcIndex = songInfo.lrcIndex + 1;
//                } else {
//                    
//                    if (songInfo.lrcIndex != 0) {
//                        
//                        if (((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex - 1]]) && ((int)currentTime < [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]])) {
//                            [_deliverView.midView.midLrcView setLrc_Index:songInfo.lrcIndex - 1];
//                        }
//                    }
//                    
//                }
//            
//                    
//            } else {
//                
//            }
//            
//            
//        }
        
        if (songInfo.isLrcExistFlg == true) {
            
            if (!_deliverView.midView.midLrcView.isDragging) {
            
                if (songInfo.lrcIndex <= songInfo.mLRCDictinary.count - 1) {
                    
                    if ((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]]) {
                        
                        _deliverView.midView.midLrcView.currentRow = songInfo.lrcIndex;
                        
                        [_deliverView.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_deliverView.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        [_deliverView.midView.midLrcView.tableView reloadData];
                        
                        [_deliverView.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _deliverView.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                        [_deliverView.midView.midLrcView.lockScreenTableView reloadData];
                        
                        songInfo.lrcIndex = songInfo.lrcIndex + 1;
                        
                    } else {
                    
                        if (songInfo.lrcIndex != 0) {
                            
                            if (((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex - 1]]) && ((int)currentTime < [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]])) {
                                
                                _deliverView.midView.midLrcView.currentRow = songInfo.lrcIndex - 1;
                                
                                [_deliverView.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_deliverView.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                [_deliverView.midView.midLrcView.tableView reloadData];
                                
                                [_deliverView.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _deliverView.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                [_deliverView.midView.midLrcView.lockScreenTableView reloadData];
                            }
                        }
                                
                    }
            
                }
            }
        }

        
        //监听锁屏状态 lock=1则为锁屏状态
        uint64_t locked;
        __block int token = 0;
        notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(token, &locked);
        
        //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
        uint64_t screenLight;
        __block int lightToken = 0;
        notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
        });
        notify_get_state(lightToken, &screenLight);
        
        BOOL isShowLyricsPoster = NO;
        // NSLog(@"screenLight=%llu locked=%llu",screenLight,locked);
        if (screenLight == 0 && locked == 1) {
            //点亮且锁屏时
            isShowLyricsPoster = YES;
        }else if(screenLight){
            return;
        }
        
        //展示锁屏歌曲信息，上面监听屏幕锁屏和点亮状态的目的是为了提高效率
        [self showLockScreenTotaltime:totalTime andCurrentTime:currentTime andLyricsPoster:isShowLyricsPoster];
        
    }];

}

#pragma mark - 锁屏播放设置
//展示锁屏歌曲信息：图片、歌词、进度、演唱者
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andLyricsPoster:(BOOL)isShow{
    
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:songInfo.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:songInfo.author forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:songInfo.album_title forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    UIImage * lrcImage = songInfo.pic_big;
    if (isShow) {
        
        //制作带歌词的海报
        if (!_lrcImageView) {
            _lrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480,800)];
        }
        
        //主要为了把歌词绘制到图片上，已达到更新歌词的目的
        [_lrcImageView addSubview:_deliverView.midView.midLrcView.lockScreenTableView];
        _lrcImageView.image = lrcImage;
        _lrcImageView.backgroundColor = [UIColor blackColor];
        
        //获取添加了歌词数据的海报图片
        UIGraphicsBeginImageContextWithOptions(_lrcImageView.frame.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_lrcImageView.layer renderInContext:context];
        lrcImage = UIGraphicsGetImageFromCurrentImageContext();
        _lastImage = lrcImage;
        UIGraphicsEndImageContext();
        
    }else{
        if (_lastImage) {
            lrcImage = _lastImage;
        }
    }
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:lrcImage]
                 forKey:MPMediaItemPropertyArtwork];
    
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
}

#pragma mark - 播放或暂停
-(void)playAndPauseButtonAction: (UIButton *)sender {
    
    NSLog(@"当前播放曲目：%@", songInfo.title);

    if (musicPlayer.play.rate == 0) {
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [musicPlayer startPlay];
        
    } else {
   
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage stopRotating];
        [musicPlayer stopPlay];
    }
}

#pragma mark - 下一曲
-(void) nextButtonAction: (UIButton *)sender {
    
    if (songInfo.playSongIndex < songInfo.OMSongs.count) {
        OMHotSongInfo *info = songInfo.OMSongs[songInfo.playSongIndex + 1];
        NSLog(@"即将播放下一首歌曲: 《%@》", info.title);
        [songInfo setSongInfo:info];
        [songInfo getSelectedSong:info.song_id index:songInfo.playSongIndex + 1];
    } else {
        NSLog(@"后面没歌曲啦~");
    }

}

#pragma mark - 歌曲播放结束操作
-(void) finishedPlaying {

    NSLog(@"本歌曲播放结束，准备播放下一首歌曲！");
//    songInfo.playSongIndex = songInfo.playSongIndex + 1;
    [self nextButtonAction:nil];
}

#pragma mark - 进度条改变值时触发
//拖动进度条改变值时触发
-(void) playbackSliderValueChanged {
    
    // 更新播放时间
    [self updateTime];

    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
    
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [musicPlayer startPlay];
        
    }
}

#pragma mark - 进度条改变值结束时触发
-(void) playbackSliderValueChangedFinish {
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if (musicPlayer.play.rate == 0) {
        
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        [musicPlayer startPlay];
        
    }
}

#pragma mark - 更新播放时间
-(void) updateTime {
    
    CMTime duration = musicPlayer.play.currentItem.asset.duration;
    
    // 歌曲总时间和当前时间
    Float64 completeTime = CMTimeGetSeconds(duration);
    Float64 currentTime = (Float64)(_songSlider.value) * completeTime;
    
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

#pragma mark - 主页控制View点击事件
-(void)tapAction:(id)tap
{
    NSLog(@"点击了tapView");
    [self responseClick];
}


- (void)responseClick {
    // 全屏遮罩
    self.BGView                 = [[UIView alloc] init];
    self.BGView.frame           = [[UIScreen mainScreen] bounds];
    self.BGView.tag             = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    
    // UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    
    // 给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseGlide)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
    }];
    
    NSLog(@"toolbar的尺寸：%f", self.toolbar.accessibilityFrame.size.height);
    NSLog(@"navigationBar:%f", self.navigationBar.frame.size.height);
    
    // 底部弹出的View
    [appWindow addSubview:_deliverView];
    [_deliverView playSetting];
    
    // 向下滑动退出
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responseGlide)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.deliverView  addGestureRecognizer:recognizer];
    
    
    // View出现动画
    self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, Screen_Height);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        
    }];

}

#pragma mark - 下滑退出detail控制界面
- (void)responseGlide {
    
    NSLog(@"====");
    
    //[currentPlaySongImage resumeRotate];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.deliverView.transform = CGAffineTransformMakeTranslation(0.01, Screen_Height);
        self.deliverView.alpha = 1.0;
        self.BGView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.BGView removeFromSuperview];
        [self.deliverView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
