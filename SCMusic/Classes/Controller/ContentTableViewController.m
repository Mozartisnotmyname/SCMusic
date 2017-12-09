//
//  ContentTableViewController.m
//  SCMusic
//
//  Created by 凌       陈 on 11/23/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "ContentTableViewController.h"

#define kCustomRowCount 7

static NSString *CellIdentifier = @"LazyTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

@interface ContentTableViewController ()
{
    NSArray *hotArtistsArray;
    NSArray *newAlbumsArray;
    NSArray *onlineMusicArray;
    NSString *choosedAlbumID;
    NSString *choosedArtistUID;
    OMSongInfo *songInfo;
}

@property (nonatomic, strong) NSMutableArray *arrayList;

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadInProgress;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) MusicDownloader *downloader;

@end

@implementation ContentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downloader = [[MusicDownloader alloc] init];
    _downloader.isDataRequestFinish = false;
    _imageDownloadInProgress = [NSMutableDictionary dictionary];
    songInfo = OMSongInfo.sharedManager;
    
    [self setupBasic];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(104, 0, 0, 0);
}


#pragma mark --private Method--初始化刷新控件
-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - /************************* 刷新数据 ***************************/
// ----------------------------------------------------------------------------
//    loadMoreData
//  Pull-Up(上拉)
// ----------------------------------------------------------------------------
- (void)loadData
{
    uint8_t type;
    if ([self.channelTitle  isEqual: @"新歌"]) {
        type = NEW_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"热歌"]) {
        type = HOT_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"经典"]) {
        type = OLD_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"情歌"]) {
        type = LOVE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"网络"]) {
        type = INTERNET_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"影视"]) {
        type = MOVIE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"欧美"]) {
        type = EUROPE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"Bill"]) {
        type = BILLBOARD_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"摇滚"]) {
        type = ROCK_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"爵士"]) {
        type = JAZZ_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"流行"]) {
        type = POP_MUSIC_LIST;
    }else {
        return;
    }
    
    NSString *partOne = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&";
    NSString *partTwo = [NSString stringWithFormat:@"type=%d&offset=0&size=%d",type, 20];
    NSString *urlString = [partOne stringByAppendingString:partTwo];
    [self loadDataForType:1 withURL:urlString];
}

// ----------------------------------------------------------------------------
//    loadMoreData
//  Pull-Down(下拉)
// ----------------------------------------------------------------------------
- (void)loadMoreData
{
    uint8_t type;
    if ([self.channelTitle  isEqual: @"新歌"]) {
        type = NEW_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"热歌"]) {
        type = HOT_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"经典"]) {
        type = OLD_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"情歌"]) {
        type = LOVE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"网络"]) {
        type = INTERNET_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"影视"]) {
        type = MOVIE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"欧美"]) {
        type = EUROPE_SONG_LIST;
    }else if ([self.channelTitle  isEqual: @"Bill"]) {
        type = BILLBOARD_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"摇滚"]) {
        type = ROCK_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"爵士"]) {
        type = JAZZ_MUSIC_LIST;
    }else if ([self.channelTitle  isEqual: @"流行"]) {
        type = POP_MUSIC_LIST;
    }else {
        return;
    }

    NSString *partOne = @"http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.billboard.billList&format=json&";
    NSString *partTwo = [NSString stringWithFormat:@"type=%d&offset=%lu&size=%d",type,(unsigned long)self.arrayList.count, 20];
    NSString *urlString = [partOne stringByAppendingString:partTwo];
    [self loadDataForType:2 withURL:urlString];
}

// ----------------------------------------------------------------------------
//    loadDataForType:(int)loadingType withURL:(NSString *)urlString
//  Loading data through Pull-Up and Pull-Down
// ----------------------------------------------------------------------------
- (void)loadDataForType:(int)loadingType withURL:(NSString *)urlString
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
   NSString *path = urlString;
    
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSArray *array = [responseObject objectForKey:@"song_list"];
            NSArray *loadSongArray = [OMHotSongInfo mj_objectArrayWithKeyValuesArray:array];
            
            if (loadingType == 1) {
                self.arrayList = [loadSongArray mutableCopy];
                [self.tableView.mj_header endRefreshing];
            }else if(loadingType == 2){
                
                if (self.arrayList.count >= 100) {
                    [self.tableView.mj_footer endRefreshing];
                    return;
                }
                
                [self.arrayList addObjectsFromArray:loadSongArray];
                [self.tableView.mj_footer endRefreshing];
            }
            songInfo.isDataRequestFinish = YES;
            songInfo.OMSongs = self.arrayList;
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error--%@",error);
    }];
    
}





// ----------------------------------------------------------------------------
//    startIconDownload:forIndexPath:
// ----------------------------------------------------------------------------
- (void)startIconDownload:(OMHotSongInfo *)info forIndexPath:(NSIndexPath *)indexPath
{
    MusicDownloader *downloader = (self.imageDownloadInProgress)[indexPath];
    if (downloader == nil)
    {
        downloader = [[MusicDownloader alloc] init];
        downloader.hotSonginfo = info;
        [downloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = info.albumImage_small;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadInProgress)[indexPath] = downloader;
        [downloader startDownload];
    }
}

// -----------------------------------------------------------------------------
//    loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// ------------------------------------------------------------------------------
-(void) loadImagesForOnScreenRows {
    
    if (self.arrayList.count > 0) {
        NSArray *visiblePaths= [self.tableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths) {
            OMHotSongInfo *info = (self.arrayList)[indexPath.row];
            
            if (!info.albumImage_small) {
                [self startIconDownload:info forIndexPath:indexPath];
            }
        }
    }
}


#pragma - mark TableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.channelTitle isEqualToString:@"新歌"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"热歌"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"经典"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"情歌"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"网络"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"影视"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"欧美"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"Bill"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"摇滚"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"爵士"]) {
        return self.arrayList.count;
    }else if ([self.channelTitle  isEqual: @"流行"]) {
        return self.arrayList.count;
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    NSUInteger nodeCount = self.arrayList.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [self.tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:PlaceholderCellIdentifier];
        }
    }
    else
    {
        // add a placeholder cell while waiting on table data
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        }
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell representing the app
            OMHotSongInfo *info = (self.arrayList)[indexPath.row];
            
            cell.textLabel.text = info.title;
            cell.detailTextLabel.text = info.author;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!info.albumImage_small)
            {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:info forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            }
            else
            {
                cell.imageView.image = info.albumImage_small;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OMHotSongInfo *info = (self.arrayList)[indexPath.row];
    NSLog(@"你选择了《%@》这首歌", info.title);
    [songInfo setSongInfo:info];
    [songInfo getSelectedSong:info.song_id index:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
// -------------------------------------------------------------------------------
//    scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnScreenRows];
    }
}

// -------------------------------------------------------------------------------
//    scrollViewDidEndDecelerating:scrollView
//   When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnScreenRows];
}


@end
