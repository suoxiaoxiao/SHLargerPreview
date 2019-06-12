//
//  UIImage+SH_ImageScale.h
//  SHLargerPreview
//
//  Created by suoxiaoxiao on 2019/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SH_ImageScale)
/**
 *  返回一张压缩的图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

NS_ASSUME_NONNULL_END
