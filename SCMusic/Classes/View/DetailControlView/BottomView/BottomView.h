//
//  BottomView.h
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BottomView : UIView

@property (nonatomic, strong) UIButton *preSongButtton;
@property (nonatomic, strong) UIButton *nextSongButton;
@property (nonatomic, strong) UIButton *playOrPauseButton;
@property (nonatomic, strong) UIButton *playModeButton;
@property (nonatomic, strong) UIButton *songListButton;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationTimeLabel;

@end
