//
//  QJsampleView.h
//  QJSlideView
//
//  Created by Justin on 16/3/12.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "OMHotSongInfo.h"
#import "OMSongInfo.h"
#import "OMAlbumInfo.h"
#import "OMArtistInfo.h"


@interface QJsampleView : UIView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@property(nonatomic, copy)NSString *title;

- (void)reloadData;
-(void)getSelectedSong: (NSString *)songID index: (long)index;

@end
