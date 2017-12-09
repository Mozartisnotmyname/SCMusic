//
//  RootViewController.m
//  BaiduMusic
//
//  Created by 凌       陈 on 8/18/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "RootViewController.h"


MusicPlayerManager *musicPlayer;
OMSongInfo *songInfo;

@implementation RootViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏title
    self.title = @"SCMusic";
    
    musicPlayer = MusicPlayerManager.sharedManager;
    songInfo = OMSongInfo.sharedManager;
    
    // 设置Subview
    [self setupSubview];
    
    // 锁屏播放设置
    [self createRemoteCommandCenter];
    
    // 设置KVO
    [songInfo addObserver:self forKeyPath:@"playSongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    [songInfo addObserver:self forKeyPath:@"isDataRequestFinish" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    [musicPlayer addObserver:self forKeyPath:@"finishPlaySongIndex" options:NSKeyValueObservingOptionOld
     |NSKeyValueObservingOptionNew context:nil];
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playSongSetting)
                                                 name: @"repeatPlay"
                                               object: nil];
    
    // 播放遇到中断，比如电话进来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];

}

-(void)viewDidAppear:(BOOL)animated {
    [self playStateRecover];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupSubview
-(void) setupSubview {
    
    // 初始化detailController
    _detailController = [[DetailControlViewController alloc] init];
    
    // 主页控制View
    _playControllerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) * 0.92 - CGRectGetHeight(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.08)];
    _playControllerView.backgroundColor = UIColorFromRGB(0xff0000);
    _playControllerView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:_playControllerView];
    [self.view addSubview:_playControllerView];
    
    [_playControllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.width.mas_equalTo(CGRectGetWidth(self.view.frame));
        make.height.mas_equalTo(CGRectGetHeight(self.view.frame) * 0.08);
    }];
    
    // 专辑图片
    _currentPlaySongImage = [[SCImageView alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height * 0.1, -_playControllerView.frame.size.height * 0.2 , _playControllerView.frame.size.height * 1.1 , _playControllerView.frame.size.height * 1.1)];
    _currentPlaySongImage.image = [UIImage imageNamed:@"cm2_simple_defaut_album_image"];
    _currentPlaySongImage.clipsToBounds = true;
    _currentPlaySongImage.layer.cornerRadius = _playControllerView.frame.size.height * 0.55;
    [_playControllerView addSubview:_currentPlaySongImage];
    _currentPlaySongImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToDeitalController)];
    [_currentPlaySongImage addGestureRecognizer:tag];
    
    //播放控制
    _playAndPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.width * 0.75 , _playControllerView.frame.size.height * 0.25 , _playControllerView.frame.size.height * 0.65 , _playControllerView.frame.size.height* 0.65)];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
    [_playAndPauseButton addTarget:self action:@selector(playAndPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playControllerView addSubview:_playAndPauseButton];
    
    
    _nextSongButton = [[UIButton alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.width * 0.88 , _playControllerView.frame.size.height * 0.25 , _playControllerView.frame.size.height * 0.65 , _playControllerView.frame.size.height* 0.65)];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
    [_nextSongButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
    [_nextSongButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playControllerView addSubview:_nextSongButton];
    
    // 歌曲进度条
    _songSlider = [[UISlider alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height * 1.3 , 0 , _playControllerView.frame.size.width - _playControllerView.frame.size.height * 1.3 , _playControllerView.frame.size.height* 0.3)];
    [_songSlider setThumbImage:[UIImage imageNamed:@"cm2_simple_knob_nomal"] forState:UIControlStateNormal];
    [_songSlider setThumbImage:[UIImage imageNamed:@"cm2_simple_knob_prs"] forState:UIControlStateHighlighted];
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
    _songName = [[UILabel alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height * 1.3,  _playControllerView.frame.size.height* 0.3 , _playControllerView.frame.size.width * 0.5 , _playControllerView.frame.size.height* 0.3)];
    //    songName.backgroundColor = [UIColor blackColor];
    _songName.text = @"Unkown";
    _songName.textColor = [UIColor whiteColor];
    _songName.font = [UIFont systemFontOfSize:16.0];
    [_playControllerView addSubview:_songName];
    
    _singerName = [[UILabel alloc] initWithFrame:CGRectMake(_playControllerView.frame.size.height * 1.3,  _playControllerView.frame.size.height* 0.7 , _playControllerView.frame.size.width * 0.5 , _playControllerView.frame.size.height* 0.2)];
    //    singerName.backgroundColor = [UIColor blackColor];
    _singerName.text = @"Unkown";
    _singerName.textColor = [UIColorFromRGB(0xfafafa) colorWithAlphaComponent:0.95];
    _singerName.font = [UIFont systemFontOfSize:13.0];
    [_playControllerView addSubview:_singerName];
    [self.view addSubview:_playControllerView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupTopContianerView];
    [self setupChildController];
    [self setupContentScrollView];
}

#pragma mark - 初始化子控制器
-(void)setupChildController {
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        
        viewController.channelTitle = self.currentChannelsArray[i];
        [self addChildViewController:viewController];
    }
}

#pragma mark - 初始化顶部标题scrollView
- (void)setupTopContianerView{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.currentChannelsArray;
    self.topContianerView  = topContianerView;
    //self.topContianerView.backgroundColor = [UIColor redColor];
    topContianerView.delegate = self;
    [self.view addSubview:topContianerView];
}

#pragma mark - 初始化ContentScrollView
- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}

#pragma mark - scrollView滑动停止调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
        for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
            NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
            if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                UITableView *theTableView = self.contentScrollView.subviews[i];
                NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                NSInteger gap = theIndex - currentIndex;
                if (gap<=2&&gap>=-2) {
                    continue;
                } else {
                    [theTableView removeFromSuperview];
                }
            }
            
        }
        
    }
}


#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark - UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

#pragma mark - TTTopChannelContianerViewDelegate
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}

#pragma mark - 顶部标题数组设置
-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        if (!_currentChannelsArray) {
            _currentChannelsArray = [NSMutableArray arrayWithObjects:@"新歌", @"热歌", @"经典", @"情歌", @"网络", @"影视", @"欧美",@"Bill", @"摇滚", @"爵士", @"流行", nil];
        }
    }
    return _currentChannelsArray;
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
        [self playSongSetting];
    }
    
    if ([keyPath isEqual:@"isDataRequestFinish"]) {
        if (songInfo.isDataRequestFinish == YES) {
            songInfo.isDataRequestFinish = NO;
            [_detailController.songListView.tableView reloadData];
        }
    }
    
    if ([keyPath  isEqual: @"finishPlaySongIndex"]) {
        [self playSongSetting];
    }
    
}


#pragma mark - 音乐被中断处理
- (void) onAudioSessionEvent: (NSNotification *) notification
{
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received!");
        
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"Interruption began!");
            [musicPlayer stopPlay];
        } else {
            NSLog(@"Interruption ended!");
            //Resume your audio
            [musicPlayer startPlay];
        }
    }
}

#pragma mark - 状态恢复
-(void) playStateRecover {
    
    [_currentPlaySongImage startRotating];
    
    if (musicPlayer.play.rate == 1) {
        NSLog(@"播放！");
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage resumeRotate];
        
    } else {
        NSLog(@"暂停");
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playAndPauseButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [_currentPlaySongImage stopRotating];
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
    [_currentPlaySongImage resumeRotate];
    
    // detail页面控制界面信息设置
    _detailController.topView.songTitleLabel.text = songInfo.title;
    _detailController.topView.singerNameLabel.text = [[@"- " stringByAppendingString:songInfo.author] stringByAppendingString:@" -"];
    [_detailController.midView.midIconView setAlbumImage:songInfo.pic_big];
    [_detailController.midView.midLrcView AnalysisLRC:songInfo.lrcString];
    
    // 播放设置
    [musicPlayer setPlayItem:songInfo.file_link];
    [musicPlayer setPlay];
    [musicPlayer startPlay];

    // 歌词index清零
    songInfo.lrcIndex = 0;
    
    // 控制界面设置
    [_detailController playStateRecover];
    
    
    // 播放结束通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(finishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:musicPlayer.play.currentItem];
    
    // 设置Observer更新播放进度
    _playerTimeObserver = [musicPlayer.play addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        NSLog(@"当前播放时间：%f", currentTime);
        
        CMTime total = musicPlayer.play.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        
        // 当前播放时间
        _detailController.bottomView.currentTimeLabel.text = [songInfo intToString:(int)currentTime];
        // 总时间
        _detailController.bottomView.durationTimeLabel.text =[songInfo intToString:(int)totalTime];
        
        _songSlider.value = (float) ( currentTime / totalTime );
        _detailController.bottomView.songSlider.value = (float) ( currentTime / totalTime );
        
        // 更新歌词
        if (songInfo.isLrcExistFlg == true) {
            
            if (!_detailController.midView.midLrcView.isDragging) {
                
                if (songInfo.lrcIndex <= songInfo.mLRCDictinary.count - 1) {
                    
                    if ((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]]) {
                        
                        _detailController.midView.midLrcView.currentRow = songInfo.lrcIndex;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_detailController.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                            
                            [_detailController.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                            
                        });
                        
                        // 刷新歌词列表
                        [_detailController.midView.midLrcView.tableView reloadData];
                        [_detailController.midView.midLrcView.lockScreenTableView reloadData];
                        
                        songInfo.lrcIndex = songInfo.lrcIndex + 1;
                        
                    } else {
                        
                        if (songInfo.lrcIndex != 0) {
                            
                            if (((int)currentTime >= [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex - 1]]) && ((int)currentTime < [songInfo stringToInt:songInfo.mTimeArray[songInfo.lrcIndex]])) {
                                
                                _detailController.midView.midLrcView.currentRow = songInfo.lrcIndex - 1;
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [_detailController.midView.midLrcView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                    [_detailController.midView.midLrcView.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: _detailController.midView.midLrcView.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                });
                                
                                // 刷新歌词列表
                                [_detailController.midView.midLrcView.tableView reloadData];
                                [_detailController.midView.midLrcView.lockScreenTableView reloadData];
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
        [_lrcImageView addSubview:_detailController.midView.midLrcView.lockScreenTableView];
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
    
    if (songInfo.playSongIndex < songInfo.OMSongs.count - 1) {
        OMHotSongInfo *info = songInfo.OMSongs[songInfo.playSongIndex + 1];
        NSLog(@"即将播放下一首歌曲: 《%@》", info.title);
        [songInfo setSongInfo:info];
        [songInfo getSelectedSong:info.song_id index:songInfo.playSongIndex + 1];
    } else {
        OMHotSongInfo *info = songInfo.OMSongs[0];
        NSLog(@"即将播放下一首歌曲: 《%@》", info.title);
        [songInfo setSongInfo:info];
        [songInfo getSelectedSong:info.song_id index:0];
    }
    
}

#pragma mark - 歌曲播放结束操作
-(void) finishedPlaying {
    
    NSLog(@"本歌曲播放结束，准备播放下一首歌曲！");
    //    songInfo.playSongIndex = songInfo.playSongIndex + 1;
    [self nextButtonAction:nil];
}

#pragma mark - 点击专辑图片
-(void) jumpToDeitalController {
    [self presentViewController:_detailController animated:YES completion:nil];
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


@end
