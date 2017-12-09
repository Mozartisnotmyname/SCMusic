//
//  SongListTableViewCell.h
//  SCNews
//
//  Created by 凌       陈 on 11/9/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface SongListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *songNumber;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *singerName;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *detailControllerBtn;

@end
