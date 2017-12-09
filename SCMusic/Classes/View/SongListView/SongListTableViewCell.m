//
//  SongListTableViewCell.m
//  SCNews
//
//  Created by 凌       陈 on 11/9/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SongListTableViewCell.h"

@implementation SongListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //创建imageView添加到cell中
        _songNumber = [[UILabel alloc] init];
        _songNumber.font = [UIFont systemFontOfSize:20.0];
        _songNumber.textColor = [UIColor blackColor];
        _songNumber.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_songNumber];
        
        [_songNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
        
        // 创建歌名label添加到cell中
        _songName = [[UILabel alloc] init];
        _songName.font = [UIFont systemFontOfSize:18.0];
        _songName.textColor = [UIColor blackColor];
        [self addSubview:_songName];
        
        [_songName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(_songNumber.mas_right).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.bottom.equalTo(self.mas_bottom).with.offset(-30);
        }];
        
        // 创建歌手名label添加到cell中
        _singerName = [[UILabel alloc] init];
        _singerName.font = [UIFont systemFontOfSize:12.0];
        _singerName.textColor = [UIColor blackColor];
        [self addSubview:_singerName];
        
        [_singerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_songName.mas_bottom).with.offset(5); //with is an optional semantic filler
            make.left.equalTo(_songNumber.mas_right).with.offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
        
    }
    
    return self;
}

@end
