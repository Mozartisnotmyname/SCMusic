//
//  ContentTableViewController.h
//  SCMusic
//
//  Created by 凌       陈 on 11/23/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "OMHotSongInfo.h"
#import "OMSongInfo.h"
#import "OMAlbumInfo.h"
#import "OMArtistInfo.h"
#import "MJRefresh.h"
#import "Const.h"
#import "MusicDownloader.h"
#import "DetailControlViewController.h"

@interface ContentTableViewController : UITableViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSString *channelTitle;
@property (nonatomic, strong) DetailControlViewController *detailController;

-(void)reloadData;
-(void)getSelectedSong: (NSString *)songID index: (long)index;


@end
