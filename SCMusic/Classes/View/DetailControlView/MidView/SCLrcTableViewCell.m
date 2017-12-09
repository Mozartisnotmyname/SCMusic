//
//  SCLrcTableViewCell.m
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import "SCLrcTableViewCell.h"

@implementation SCLrcTableViewCell


AnimationType *animationType = translation;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(SCLrcTableViewCell *) SC_CellForRowWithTableVieW: (UITableView *) tableView {
    
    NSString *cellID = @"lrccellID";
    SCLrcTableViewCell *cell = (SCLrcTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[SCLrcTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}

-(void)addAnimation: (AnimationType)animationType {
    switch (animationType) {
        case translation:
        {
            [self.layer removeAnimationForKey:@"translation"];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
            animation.values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:50], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:50], [NSNumber numberWithDouble:0], nil];
            animation.duration = 0.7;
            animation.repeatCount = 1;
            [self.layer addAnimation:animation forKey:@"translation"];
            break;
        }
        case scale:
        {
            [self.layer removeAnimationForKey:@"scale"];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        
            animation.values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.5], [NSNumber numberWithDouble:1.0], nil];
            animation.duration = 0.7;
            animation.repeatCount = 1;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [self.layer addAnimation:animation forKey:@"scale"];
            break;
        }
        case rotation:
        {
            [self.layer removeAnimationForKey:@"rotation"];
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:(-1 / 6 * M_PI)], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:(1 / 6 * M_PI)], [NSNumber numberWithDouble:0], nil];
            animation.duration = 0.7;
            animation.repeatCount = 1;
            [self.layer addAnimation:animation forKey:@"rotation"];
            break;
        }
        case scaleAlways:
        {
//            [self.layer removeAnimationForKey:@"scale"];
            CABasicAnimation *animatio1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
            animatio1.repeatCount = 1;
            animatio1.duration = 0.6;
//            animatio1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animatio1.removedOnCompletion = false;
//            animatio1.fillMode = kCAFillModeForwards;
            
            animatio1.autoreverses = YES; // 动画结束时执行逆动画
            
            // 缩放倍数
            animatio1.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
            animatio1.toValue = [NSNumber numberWithFloat:1.2]; // 结束时的倍率
            [self.layer addAnimation:animatio1 forKey:@"scale-layer"];
            
//            NSLog(@"scaleAlways");
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//            animation.values = [NSArray arrayWithObjects:[NSNumber numberWithDouble:(-1 / 6 * M_PI)], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:(1 / 6 * M_PI)], [NSNumber numberWithDouble:0], nil];
//        
//            animation.duration = 0.7;
//            animation.repeatCount = 1;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.removedOnCompletion = false;
//            animation.fillMode = kCAFillModeForwards;
//            [self.layer addAnimation:animation forKey:@"scale"];
            
            break;
        }
        case scaleNormal:
        {
//             [self.layer removeAnimationForKey:@"scale"];
//            CAPropertyAnimation *animation =[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
//    
//            animation.autoreverses = true;
//            animation.duration = 0.7;
//            animation.repeatCount = 1;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            [self.layer addAnimation:animation forKey:@"scale"];
            
            break;
        }
        default: break;
        
    }
}

@end
