//
//  SCIconView.m
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SCIconView.h"


@implementation SCIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    return self;
}

-(void) setAlbumImage: (UIImage *)image {
    _imageView = [[SCImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.1, self.frame.size.height / 2 - self.frame.size.width * 0.4 , self.frame.size.width * 0.8, self.frame.size.width * 0.8)];
    _imageView.image = image;
    _imageView.clipsToBounds = true;
    _imageView.layer.cornerRadius = self.frame.size.width * 0.4;
    [self addSubview:_imageView];
}

@end
