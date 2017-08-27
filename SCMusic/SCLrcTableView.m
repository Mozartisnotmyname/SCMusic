//
//  SCLrcTableView.m
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SCLrcTableView.h"

@implementation SCLrcTableView

extern OMSongInfo *songInfo;

-(void) setLrc_Index: (int)lrc_index {
    if (_Lrc_Index == lrc_index || lrc_index > songInfo.mLRCDictinary.count - 1) {
        return;
    }
    
    // 滚动到制定的位置
    // 新的indexPath
    id indexPath = [NSIndexPath indexPathForRow:lrc_index inSection:0];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: lrc_index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
    
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    _currentCell = (SCLrcTableViewCell *)currentCell;
    [_currentCell.textLabel setTextColor:[UIColor redColor]];
    
    id oldIndexPath = [NSIndexPath indexPathForRow:_Lrc_Index inSection:0];
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:oldIndexPath];
    _lrcOldCell = (SCLrcTableViewCell *)oldCell;
    [_lrcOldCell.textLabel setTextColor:[UIColor whiteColor]];
    

    [_currentCell addAnimation:scaleAlways];
    
//    [self.tableView reloadData];
    
    // 锁屏歌词更新
//    [_lockScreenTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
    [_lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: lrc_index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    UITableViewCell *lockCurrentCell = [_lockScreenTableView cellForRowAtIndexPath:indexPath];
    _currentCell = (SCLrcTableViewCell *)lockCurrentCell;
    [_currentCell.textLabel setTextColor:[UIColor redColor]];
    
    id lockOldIndexPath = [NSIndexPath indexPathForRow:_Lrc_Index inSection:0];
    UITableViewCell *lockOldCell = [_lockScreenTableView cellForRowAtIndexPath:lockOldIndexPath];
    _lrcOldCell = (SCLrcTableViewCell *)lockOldCell;
    [_lrcOldCell.textLabel setTextColor:[UIColor whiteColor]];
//    [_lockScreenTableView reloadData];
    
    // 更新歌词index
    _Lrc_Index = lrc_index;
}

-(instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        songInfo.mLRCDictinary = [[NSMutableDictionary alloc] init];
        songInfo.mTimeArray = [[NSMutableArray alloc] init];
        
        if (!_lockScreenTableView) {
            _lockScreenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 800 - 44 * 7 + 20, 480, 44 * 3) style:UITableViewStyleGrouped];
            _lockScreenTableView.dataSource = self;
            _lockScreenTableView.delegate = self;
            _lockScreenTableView.separatorStyle = NO;
            _lockScreenTableView.backgroundColor = [UIColor clearColor];
            [_lockScreenTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lrccellID"];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void) SC_SetUpLrcTableViewFrame: (CGRect)frame {
    self.view.frame = frame;
}


-(void) AnalysisLRC: (NSString *)lrcStr {
    
    
    NSString* contentStr = lrcStr;
    
    NSArray *lrcArray = [contentStr componentsSeparatedByString:@"\n"];
    
    [songInfo.mLRCDictinary removeAllObjects];
    [songInfo.mTimeArray removeAllObjects];
    
    for (NSString *line in lrcArray) {
        
        // 首先处理歌词中无用的东西
        // [ti:][ar:][al:]这类的直接跳过
        if ([line containsString:@"[0"] || [line containsString:@"[1"] || [line containsString:@"[2"] || [line containsString:@"[3"]) {
            NSArray *lineArr = [line componentsSeparatedByString:@"]"];
            NSString *str1 = [line substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [line substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcStr = lineArr[1];
                NSString *timeStr = [lineArr[0] substringWithRange:NSMakeRange(1, 5)];
                [songInfo.mLRCDictinary setObject:lrcStr forKey:timeStr];
                [songInfo.mTimeArray addObject:timeStr];
            }
        } else {
            continue;
        }
    }
    
    _mIsLRCPrepared = true;
    [self.tableView reloadData];

}

-(UIImage *)getBlurredImage:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter=[CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@5.0f forKey:@"inputRadius"];
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef ref=[context createCGImage:result fromRect:[result extent]];
    return [UIImage imageWithCGImage:ref];
}


#pragma - mark tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return songInfo.mLRCDictinary.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SCLrcTableViewCell *cell = [SCLrcTableViewCell SC_CellForRowWithTableVieW:tableView];

    cell.textLabel.text = songInfo.mLRCDictinary[songInfo.mTimeArray[indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_currentRow == indexPath.row) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _isDragging = NO;
}

@end
