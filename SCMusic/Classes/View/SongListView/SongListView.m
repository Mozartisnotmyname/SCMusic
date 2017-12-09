//
//  SongListView.m
//  SCNews
//
//  Created by 凌       陈 on 11/9/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SongListView.h"

@implementation SongListView

extern MusicPlayerManager *musicPlayer;
extern OMSongInfo *songInfo;

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // musicPlayer和songInfo初始化
        musicPlayer = MusicPlayerManager.sharedManager;
        songInfo = OMSongInfo.sharedManager;
        
        //topView
        _topView = [[SongListTopView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 9)];
        _topView.backgroundColor = UIColorFromRGB(0xaaaaaa);
        [_topView.playMode addTarget:self action:@selector(playModeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topView];
        
        //tableView
        _tableView = [[SongListTableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 9, self.frame.size.width, self.frame.size.height / 9 * 8)];
       _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];

        
    }
    return self;
}


-(void) setPlayModeButtonState {
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode://顺序播放
        {
            NSString *title = [NSString stringWithFormat:@"顺序播放(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatPlayMode;
        }
            break;
        case RepeatOnlyOnePlayMode://单曲循环
        {
            NSString *title = [NSString stringWithFormat:@"单曲循环(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = RepeatOnlyOnePlayMode;  //单曲循环
        }
            break;
        case ShufflePlayMode://随机播放
        {
            NSString *title = [NSString stringWithFormat:@"随机播放(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
            musicPlayer.shuffleAndRepeatState = ShufflePlayMode;
        }
            break;
        default:
            break;
    }
}

-(void) playModeButtonAction {
    switch (musicPlayer.shuffleAndRepeatState)
    {
        case RepeatPlayMode://顺序播放
        {
            NSString *title = [NSString stringWithFormat:@"单曲循环(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
            [self showMiddleHint:@"单曲循环"];
            musicPlayer.shuffleAndRepeatState = RepeatOnlyOnePlayMode;  //单曲循环
        }
            break;
        case RepeatOnlyOnePlayMode://单曲循环
        {
            NSString *title = [NSString stringWithFormat:@"随机播放(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
            [self showMiddleHint:@"随机播放"];
            musicPlayer.shuffleAndRepeatState = ShufflePlayMode;
        }
            break;
        case ShufflePlayMode://随机播放
        {
            NSString *title = [NSString stringWithFormat:@"顺序播放(%lu)", (unsigned long)songInfo.OMSongs.count];
            [_topView.playMode setTitle:title forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [_topView.playMode setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
            [self showMiddleHint:@"顺序播放"];
            musicPlayer.shuffleAndRepeatState = RepeatPlayMode;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 播放模式提示框
- (void)showMiddleHint:(NSString *)hint {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0.f, 0.f);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}

@end
