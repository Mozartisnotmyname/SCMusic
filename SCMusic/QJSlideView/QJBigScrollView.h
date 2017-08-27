//
//  QJBigScrollView.h
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BgScrollViewBlock)(NSInteger index);
@interface QJBigScrollView : UIScrollView


- (id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;

-(void)setBgScrollViewContentOffset:(NSInteger)index;

@property(nonatomic, copy)BgScrollViewBlock Bgbolck;

@end
