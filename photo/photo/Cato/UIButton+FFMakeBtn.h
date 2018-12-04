//
//  UIButton+FFMakeBtn.h
//
//  Created by Stephen Hu on 2018/7/24.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FFMakeBtn)
/// 自定义类型按钮文字和背景色
+ (instancetype) customButtonWithTitle:(NSString *)title andBackGrounColor:(UIColor *)bgColor;
/// 返回一个带有文字和背景色的btn
+ (instancetype) buttonWithTitle:(NSString *)title andBackGrounColor:(UIColor *)bgColor;
/// 返回一个带有图片的btn
+ (instancetype) buttonWithNormalImage:(UIImage *)image;
/// 返回一个带有图片和title的btn
+ (instancetype) buttonWithNormalImage:(UIImage *)image andTitle:(NSString *)title;
/// 返回一个带有图片和选中图片的的btn
+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage;
/// 返回一个带有图片和选中图片和title的的btn
+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andTitle:(NSString *)title;
/// 返回一个带有图片和选中图片、高亮图片、和title的的btn
+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andHighlightedImage:(UIImage *)highlightedImage andTitle:(NSString *)title;
@end
