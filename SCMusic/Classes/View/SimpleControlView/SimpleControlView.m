//
//  SimpleControlView.m
//  SCNews
//
//  Created by 凌       陈 on 11/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SimpleControlView.h"
#import "Masonry.h"
#import "Const.h"

@implementation SimpleControlView

-(instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:UIColorFromRGB(0xff0000)];
        //创建imageView添加到SimpleControlView中
        _albumImage = [[UIImageView alloc] init];
        [self addSubview:_albumImage];
        
        [_albumImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
        
        // 创建歌名label添加到SimpleControlView中
        _songName = [[UILabel alloc] init];
        _songName.font = [UIFont systemFontOfSize:18.0];
        [_songName setTextColor:UIColorFromRGB(0x000000)];
        [self addSubview:_songName];
        
        [_songName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(_albumImage.mas_right).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.bottom.equalTo(self.mas_bottom).with.offset(-30);
        }];
        
        // 创建歌手名label添加到SimpleControlView中
        _singerName = [[UILabel alloc] init];
        _singerName.font = [UIFont systemFontOfSize:12.0];
         [_singerName setTextColor:UIColorFromRGB(0x000000)];
        [self addSubview:_singerName];
        
        [_singerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_songName.mas_bottom).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(_albumImage.mas_right).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
        
        // 创建下一曲按键添加到SimpleControlView中
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn  setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
        [self addSubview:_nextBtn];
        
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10); //with is an optional semantic filler
            make.right.equalTo(self.mas_right).with.offset(20);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        // 创建播放暂停按键添加到SimpleControlView中
        _playOrPauseBtn = [[UIButton alloc] init];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        [self addSubview:_playOrPauseBtn];
        
        [_playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10); //with is an optional semantic filler
            make.right.equalTo(_nextBtn.mas_right).with.offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        
    }
    
    return self;
}

@end
