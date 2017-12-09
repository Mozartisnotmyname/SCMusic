//
//  OMSongInfo.h
//  KEF LS50
//
//  Created by sse-jiaoxinlong on 15-9-22.
//  Copyright (c) 2015年 GPE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OMHotSongInfo : NSObject
@property (nonatomic,strong) UIImage *albumImage_big;
@property (nonatomic,strong) UIImage *albumImage_small;
@property (nonatomic,strong) NSString *pic_big;
@property (nonatomic,strong) NSString *lrclink;
@property (nonatomic,strong) NSString *pic_small;
@property (nonatomic,strong) NSString *song_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *album_title;
@property (nonatomic,strong) NSString *file_duration;


@end
