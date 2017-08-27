//
//  MusicPlayerManager.m
//  BaiduMusic
//
//  Created by 凌       陈 on 8/21/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "MusicPlayerManager.h"


@implementation MusicPlayerManager

static MusicPlayerManager *_sharedManager = nil;

+(MusicPlayerManager *)sharedManager {
    @synchronized( [MusicPlayerManager class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}


-(void) setPlayItem: (NSString *)songURL {
    NSURL * url  = [NSURL URLWithString:songURL];
    _playItem = [[AVPlayerItem alloc] initWithURL:url];
}

-(void) setPlay {
    _play = [[AVPlayer alloc] initWithPlayerItem:_playItem];
}

-(void) startPlay {
    [_play play];
}

-(void) stopPlay {
    [_play pause];
}

-(void) play: (NSString *)songURL {
    [self setPlayItem:songURL];
    [self setPlay];
    [self startPlay];
}

@end
