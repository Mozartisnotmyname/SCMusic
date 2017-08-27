//
//  Helper.m
//  QJSlideView
//
//  Created by Justin on 16/3/12.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "Helper.h"
#import "Masonry.h"

@implementation Helper

+ (UIView *)initLoadingViewInView
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    UIView *loadingBgView = [[UIView alloc] init];
    loadingBgView.translatesAutoresizingMaskIntoConstraints = NO;
    loadingBgView.backgroundColor = [UIColor clearColor];
    [window addSubview:loadingBgView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 5;
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [loadingBgView addSubview:bgView];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [loadingBgView addSubview:loadingView];
    
    [loadingBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(window);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);
    }];

    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY);

    }];
    
    [loadingView startAnimating];
    
    return loadingBgView;
}


@end
