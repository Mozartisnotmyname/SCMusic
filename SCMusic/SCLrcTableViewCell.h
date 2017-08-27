//
//  SCLrcTableViewCell.h
//  UIViewClickedAction
//
//  Created by 凌       陈 on 8/22/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLrcTableViewCell : UITableViewCell

typedef enum SC_AnimationType {
    translation,
    scale,
    rotation,
    scaleAlways,
    scaleNormal,
}AnimationType;


+(SCLrcTableViewCell *) SC_CellForRowWithTableVieW: (UITableView *) tableView;
-(void)addAnimation: (AnimationType)animationType;

@end
