//
//  QJBigScrollView.m
//  QJSlideView
//
//  Created by Justin on 16/3/10.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJBigScrollView.h"
#import "Masonry.h"
#import "QJsampleView.h"
#import "Helper.h"

#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)
#define BaseTag         20000


@interface QJBigScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *titleArr;

@property(nonatomic, strong)NSMutableArray *reuseViewArr;

@property (nonatomic, assign) CGFloat offset;

@end

@implementation QJBigScrollView{
    CGFloat contentOff_X;
    UIView * loadingView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithcontroller:(UIViewController *)VC TitleArr:(NSArray *)titleArr;
{
    self = [super init];
    if (self) {
        self.titleArr = titleArr;
        self.frame = [self getViewFrame];
        self.reuseViewArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        self.contentSize = CGSizeMake(Screen_Width * self.titleArr.count, Screen_Height - 44);
        [VC.view addSubview:self];
        [self confingSubViews];
        
    }
    return self;
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = Screen_Height - 44;
    frame.size.width = Screen_Width;
    frame.origin.x = 0;
    frame.origin.y = 44;
    return frame;
}

-(void)confingSubViews
{
    NSInteger i = 0;
    for (i = 0; i < 3; i++) {
        QJsampleView *view = [[QJsampleView alloc] initWithFrame:CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height - 44) Title:self.titleArr[i]];
        // 添加子视图到scrollview
        [self addSubview:view];

        // 添加view到托管的重用数组
        [self.reuseViewArr addObject:view];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.offset = scrollView.contentOffset.x;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    contentOff_X = scrollView.contentOffset.x;
    NSInteger index = contentOff_X/Screen_Width;
    __weak typeof(self) weak = self;
    if (contentOff_X < 0 || contentOff_X > Screen_Width * (self.titleArr.count - 1)) {
        
    }else{
        if (contentOff_X > self.offset){
            [self initRightView:index Complete:^(QJsampleView *view, NSInteger index) {
                [weak reflashUI:view Index:index];
            }];
        }else if (contentOff_X < self.offset){
            [self initRightView:index Complete:^(QJsampleView *view, NSInteger index) {
                [weak reflashUI:view Index:index];
            }];
        }
        if (self.Bgbolck) {
            self.Bgbolck(index);
        }
        
    }
}

-(void)setBgScrollViewContentOffset:(NSInteger)index
{
    [self setContentOffset:CGPointMake(Screen_Width *index, 0)];
    __weak typeof(self) weak = self;
    
    if (index > 1) {
        [self initRightView:index Complete:^(QJsampleView *view, NSInteger index) {
            [weak reflashUI:view Index:index];
        }];
    }
    if (index <= 1) {
        [self initLeftView:index Complete:^(QJsampleView *view, NSInteger index) {
            [weak reflashUI:view Index:index];
        }];
    }
}

-(void)removeLeftView:(void(^)(QJsampleView *view))completion
{
    QJsampleView *View = [self getReuseViewFromArr:0];
    if (completion) {
        completion(View);
    }
}

-(void)removeRightView:(void(^)(QJsampleView *view))completion
{
    QJsampleView *View = [self getReuseViewFromArr:2];
    if (completion) {
        completion(View);
    }
}
- (void)initRightView:(NSInteger)index Complete:(void(^)(QJsampleView *view, NSInteger index))complete
{
    [self removeLeftView:^(QJsampleView *view) {
        [self.reuseViewArr removeObject:view];
        [view setFrame:CGRectMake(Screen_Width *index, 0, Screen_Width, Screen_Height - 44)];
        [self.reuseViewArr addObject:view];
        if (complete) {
            complete(view,index);
        }
    }];
}

- (void)initLeftView:(NSInteger)index Complete:(void(^)(QJsampleView *view, NSInteger index))complete
{
    [self removeRightView:^(QJsampleView *view) {
        [self.reuseViewArr removeObject:view];
        [view setFrame:CGRectMake(Screen_Width *index, 0, Screen_Width, Screen_Height - 44)];
        [self.reuseViewArr addObject:view];
        if (complete) {
            complete(view,index);
        }
    }];
}

-(QJsampleView *)getReuseViewFromArr:(NSInteger)index
{
    if (self.reuseViewArr[index] == nil) {
        QJsampleView *view = [[QJsampleView alloc] initWithFrame:CGRectMake(index * Screen_Width, 0, Screen_Width, Screen_Height - 44) Title:self.titleArr[index]];
        [self.reuseViewArr insertObject:view atIndex:index];
        return view;
    }
    return self.reuseViewArr[index];
}

/**
 *  刷新视图的UI的方法
 */
-(void)reflashUI:(QJsampleView *)view Index:(NSInteger)index
{
    loadingView = [Helper initLoadingViewInView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知主线程刷新
            view.title = self.titleArr[index];
            [view reloadData];
            
            [loadingView removeFromSuperview];
            loadingView = nil;
            
        });
        
    });
}

-(void)delayMethod
{
    
}

@end
