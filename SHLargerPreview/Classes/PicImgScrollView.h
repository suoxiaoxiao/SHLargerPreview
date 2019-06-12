//
//  MyScrollView.h
//  LookBigPic
//
//  Created by apple on 15/10/13.
//  Copyright © 2015年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SingleTapClick)(UIImageView *);

@interface PicImgScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,retain)UIImageView *bigImgView;
@property(nonatomic,copy)SingleTapClick singleTapClick;

-(void)initWithBigImgUrl:(NSString *)bigImgStr smallImageUrl:(NSString *)smallImgStr;

-(void)resetZoom;

@end
