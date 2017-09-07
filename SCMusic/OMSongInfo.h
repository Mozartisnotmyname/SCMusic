//
//  OMSongInfo.h
//  BaiduMusic
//
//  Created by 凌       陈 on 8/21/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MJExtension.h"
#import "OMHotSongInfo.h"

@interface OMSongInfo : NSObject
+ (OMSongInfo *)sharedManager;
@property (nonatomic,strong) UIImage *pic_big;
@property (nonatomic,strong) UIImage *pic_small;
@property (nonatomic,strong) NSString *song_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *album_title;
@property (nonatomic,strong) NSString *file_duration;
@property (nonatomic,strong) NSString *file_link;
@property (nonatomic,strong) NSString *file_size;
@property (nonatomic,strong) NSString *lrclink;
@property (nonatomic,assign) BOOL isLrcExistFlg;
@property (nonatomic,strong) NSString *lrcString;
@property (nonatomic,strong) NSMutableDictionary *mLRCDictinary;
@property (nonatomic,strong) NSMutableArray *mTimeArray;
@property (nonatomic,assign) int lrcIndex;
@property (nonatomic,assign) long playSongIndex;
@property (nonatomic,strong) NSArray *OMSongs;


- (void)loadNewSongs: (UITableView *)songListTableView;
- (void)loadHotSongs: (UITableView *)songListTableView;
- (void)loadHotArtists: (UITableView *)songListTableView;
- (void)loadClassicOldSongs: (UITableView *)songListTableView;
- (void)loadLoveSongs: (UITableView *)songListTableView;
- (void)loadMovieSongs: (UITableView *)songListTableView;
- (void)loadEuropeAndTheUnitedStatesSongs: (UITableView *)songListTableView;

-(void)getSelectedSong: (NSString *)songID index: (long)index;
-(void) setSongInfo: (OMHotSongInfo *)info;
-(NSString *)intToString: (int)needTransformInteger;
-(int) stringToInt: (NSString *)timeString;

@end
