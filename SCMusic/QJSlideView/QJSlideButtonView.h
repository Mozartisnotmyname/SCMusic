//
//  QJSlideButtonView.h
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SBViewBlock)(NSInteger index);

@interface QJSlideButtonView : UIScrollView

@property(nonatomic, strong)NSArray *titleArr;

- (id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;

-(void)setSBScrollViewContentOffset:(NSInteger)index;

@property(nonatomic, copy)SBViewBlock sbBlock;

@end
