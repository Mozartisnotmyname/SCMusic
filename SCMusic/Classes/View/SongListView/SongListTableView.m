//
//  SongListTableView.m
//  SCNews
//
//  Created by 凌       陈 on 11/9/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SongListTableView.h"
#import "SongListTableViewCell.h"
#import "MusicPlayerManager.h"
#import "OMSongInfo.h"
#import "OMHotSongInfo.h"

static NSString *CellIdentifier = @"SCTableViewCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

extern MusicPlayerManager *musicPlayer;
extern OMSongInfo *songInfo;

@implementation SongListTableView


-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // musicPlayer和songInfo初始化
        musicPlayer = MusicPlayerManager.sharedManager;
        songInfo = OMSongInfo.sharedManager;
        
        // tableView初始化
        self.delegate = self;
        self.dataSource = self;
        self.sectionHeaderHeight = 0.1;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
        [self reloadData];
    }
    return self;
}




#pragma mark - UITableViewDataSource

// -------------------------------------------------------------------------------
//	numberOfSectionsInTableView
//  height of tableView.
// -------------------------------------------------------------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// -------------------------------------------------------------------------------
//	tableView:heightForRowAtIndexPath:
//  height of tableView.
// -------------------------------------------------------------------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return songInfo.OMSongs.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OMHotSongInfo *info = songInfo.OMSongs[indexPath.row];
    
    SongListTableViewCell *cell = (SongListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SongListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    cell.songNumber.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.songName.text = info.title;
    cell.singerName.text = info.author;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OMHotSongInfo *info = songInfo.OMSongs[indexPath.row];
    NSLog(@"你选择了《%@》这首歌", info.title);
    [songInfo setSongInfo:info];
    [songInfo getSelectedSong:info.song_id index:indexPath.row];
    
}



@end
