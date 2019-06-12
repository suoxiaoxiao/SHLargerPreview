//
//  PicViewController.h
//  LookBigPic
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookBigPicViewController : UIViewController

/** 传入大图数组和小图数组 */
-(void)configAllBigUrlArray:(NSArray *)bigUrlArray andSmallUrlArray:(NSArray*)smallUrlArr andTargets:(id)targert andIndex:(NSInteger)index;

/** 没有大小图之分，公用一张图*/
-(void)configAllImageUrlArray:(NSArray *)imageArray andTargets:(id)targert andIndex:(NSInteger)index;

//以点击的view为起始动画，需传入整改需要预览图片的数组
-(void)pushChildViewControllerWithArray:(NSArray *)viewArray;

//从屏幕中心转场 （选择这种方式进场，也只能选择这种方式退出）
-(void)pushChildViewControllerFromCenter;

@end
