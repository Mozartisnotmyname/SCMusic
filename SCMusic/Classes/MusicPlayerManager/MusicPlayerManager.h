//
//  MusicPlayerManager.h
//  BaiduMusic
//
//  Created by 凌       陈 on 8/21/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerManager : NSObject

typedef enum : NSUInteger {
    RepeatPlayMode,
    RepeatOnlyOnePlayMode,
    ShufflePlayMode,
} ShuffleAndRepeatState;

@property (nonatomic,strong) AVPlayer *play;
@property (nonatomic,strong) AVPlayerItem *playItem;
@property (nonatomic,assign) ShuffleAndRepeatState shuffleAndRepeatState;
@property (nonatomic,assign) NSInteger playingIndex;

+ (MusicPlayerManager *)sharedManager;
-(void) setPlayItem: (NSString *)songURL;
-(void) setPlay;
-(void) startPlay;
-(void) stopPlay;
-(void) play: (NSString *)songURL;

@end
