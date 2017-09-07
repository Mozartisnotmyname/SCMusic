//
//  OMSongInfo.m
//  BaiduMusic
//
//  Created by 凌       陈 on 8/21/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "OMSongInfo.h"

@implementation OMSongInfo

static OMSongInfo *_sharedManager = nil;

+(OMSongInfo *)sharedManager {
    @synchronized( [OMSongInfo class] ){
        if(!_sharedManager)
            _sharedManager = [[self alloc] init];
        return _sharedManager;
    }
    return nil;
}

#pragma mark - 导入数据
- (void)loadNewSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=1&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

- (void)loadHotSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=2&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

- (void)loadHotArtists: (UITableView *)songListTableView
{
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.get72HotArtist&format=json&order=1&offset=0&limit=100";//前100热门歌手
    //    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        if ([responseObject isKindOfClass:[NSDictionary class]])
    //        {
    //            NSArray *array = [responseObject objectForKey:@"artist"];
    //            hotArtistsArray = [OMArtistInfo objectArrayWithKeyValuesArray:array];
    //           [_mytableView reloadData];
    //        }
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"error--%@",error);
    //    }];
}

- (void)loadClassicOldSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=22&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

- (void)loadLoveSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=25&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

- (void)loadMovieSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=24&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

- (void)loadEuropeAndTheUnitedStatesSongs: (UITableView *)songListTableView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&type=21&offset=0&size=100";//前100热门歌曲
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            _OMSongs = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            //            [self reloadTableView:_radioAndMusicTableView];
            [songListTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
}



//- (void)loadNewAlbums: (UITableView *)songListTableView
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *path = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.plaza.getRecommendAlbum&format=json&offset=0&limit=100";//前100新专辑
//    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSArray *array = [responseObject valueForKeyPath:@"plaze_album_list.RM.album_list.list"];//多级
//            newAlbumsArray = [OMAlbumInfo objectArrayWithKeyValuesArray:array];
//            [songListTableView reloadData];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error--%@",error);
//    }];
//}
//- (void)loadArtistSong: (UITableView *)songListTableView
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *path = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.artist.getSongList&format=json&order=2&tinguid=%@&offset=0&limits=50", choosedArtistUID];
//    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSArray *array = [responseObject objectForKey:@"songlist"];
//            songInfo.OMSongs = [OMHotSongInfo objectArrayWithKeyValuesArray:array];
//            [songListTableView reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}
//- (void)loadAlbumSong: (UITableView *)songListTableView
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSString *path = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.album.getAlbumInfo&format=json&album_id=%@",choosedAlbumID];
//    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject isKindOfClass:[NSDictionary class]])
//        {
//            NSArray *array = [responseObject objectForKey:@"songlist"];
//            songInfo.OMSongs = [OMHotSongInfo objectArrayWithKeyValuesArray:array];
//            [songListTableView reloadData];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//}


#pragma mark - 获取歌曲url
-(void)getSelectedSong: (NSString *)songID index: (long)index {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = [@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.song.play&songid="  stringByAppendingString:songID];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *array = [responseObject objectForKey:@"bitrate"];
            
            self.file_link = [array objectForKey:@"file_link"];
            self.file_size = [array objectForKey:@"file_size"];
            self.file_duration = [array objectForKey:@"file_duration"];
            self.playSongIndex = index;

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@",error);
    }];
    
}


#pragma mark - 设置歌曲的所有信息
-(void) setSongInfo: (OMHotSongInfo *)info {
    
    self.title = info.title;
    self.author = info.author;
    self.album_title = info.author;
    self.lrclink = info.lrclink;
    
    NSString *path = info.pic_small;
    if (path)
    {
        NSURL *url = [NSURL URLWithString:path];
        
        @try {
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *albumArt = [UIImage imageWithData:imageData];
            
            if (albumArt)
            {
                self.pic_small = albumArt;
            }
            else
            {
                self.pic_small = [UIImage imageNamed:@"album_default"];
            }
            
            
        } @catch (NSException *exception) {
            NSLog(@"下载图片出错！");
        }
        
        
    }
    else
    {
        self.pic_small = [UIImage imageNamed:@"album_default"];
    }
    
    path = info.pic_big;
    if (path)
    {
        NSURL *url = [NSURL URLWithString:path];
        
        @try {
            
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *albumArt = [UIImage imageWithData:imageData];
            
            if (albumArt)
            {
                self.pic_big = albumArt;
            }
            else
            {
                self.pic_big = [UIImage imageNamed:@"album_default"];
            }
            
            
        } @catch (NSException *exception) {
            NSLog(@"下载图片出错！");
        }
        
        
    }
    else
    {
        self.pic_big = [UIImage imageNamed:@"album_default"];
    }
    
    path = info.lrclink;
    if (path)
    {
        NSURL *url = [NSURL URLWithString:path];
        
        @try {
            
            NSData *lrcData = [NSData dataWithContentsOfURL:url];
            NSString *lrcStr = [[NSString alloc] initWithData:lrcData encoding:NSUTF8StringEncoding];
            self.lrcString = lrcStr;
            self.isLrcExistFlg = true;
            
        } @catch (NSException *exception) {
            NSLog(@"获取歌词出错！");
            self.isLrcExistFlg = false;
        }
        
        
    }
    else
    {
        NSLog(@"歌词不存在！");
        self.isLrcExistFlg = false;
    }
}

#pragma mark - int转NSString
-(NSString *)intToString: (int)needTransformInteger {
    
    //实现00：00这种格式播放时间
    int wholeTime = needTransformInteger;
    
    int min  = wholeTime / 60;
    
    int sec = wholeTime % 60;
    
    NSString *str = [NSString stringWithFormat:@"%02d:%02d", min , sec];
    
    return str;
}

#pragma mark - NSString转int
-(int) stringToInt: (NSString *)timeString {
    
    NSArray *strTemp = [timeString componentsSeparatedByString:@":"];
    
    int time = [strTemp.firstObject intValue] * 60 + [strTemp.lastObject intValue];
    
    return time;
    
}



@end
