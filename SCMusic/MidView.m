//
//  MidView.m
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "MidView.h"

#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)

@implementation MidView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delegate = self;
    
    self.showsHorizontalScrollIndicator = false;
    
    self.pagingEnabled = true;
    
    self.contentSize = CGSizeMake(Screen_Width * 2, 0);
    
    // 专辑图片视图配置
    _midIconView = [[SCIconView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, frame.size.height)];
    [self addSubview:_midIconView];
    
    // 歌词视图配置
    _midLrcView = [[SCLrcTableView alloc] initWithStyle:UITableViewStylePlain];
    [_midLrcView SC_SetUpLrcTableViewFrame:CGRectMake(Screen_Width, 0, frame.size.width, frame.size.height)];
    _midLrcView.tableView.allowsSelection = false;
    _midLrcView.tableView.backgroundColor = [UIColor clearColor];
    _midLrcView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _midLrcView.tableView.showsVerticalScrollIndicator = false;
    _midLrcView.tableView.contentInset = UIEdgeInsetsMake(frame.size.height / 2, 0, frame.size.height / 2, 0);
    [self addSubview:_midLrcView.view];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

-(void) scrollViewDidScroll: (UIScrollView *)scrollView {
    
    double spread = self.contentOffset.x / Screen_Width;
    
    _midIconView.alpha =  1.0 - spread;
    
    _midLrcView.tableView.alpha = spread;
    
}

@end
