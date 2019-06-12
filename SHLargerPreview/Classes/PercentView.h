//
//  PercentView.h
//  NerdFeed
//
//  Created by zhaoqihao on 14-9-3.
//  Copyright (c) 2014年 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentView : UIView
{
    CAShapeLayer *spinLayer;
    CABasicAnimation *spinAnimation;
}

@property (nonatomic,assign)NSInteger percent;

-(id)initInView:(UIView *)view;

@end
