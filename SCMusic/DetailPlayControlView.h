//
//  DetailPlayControlView.h
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "MidView.h"
#import "BottomView.h"
#import "OMSongInfo.h"
#import "MusicPlayerManager.h"
#import "OMHotSongInfo.h"

@interface DetailPlayControlView : UIView

@property(nonatomic, strong) TopView *topview;
@property(nonatomic, strong) MidView *midView;
@property(nonatomic, strong) BottomView *bottomView;
@property(nonatomic, strong) UIImageView *backgroundImageView;
-(void) setBackgroundImage: (UIImage *)image;
-(void) playSetting;

@end
