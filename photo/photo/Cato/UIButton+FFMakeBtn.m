//
//  UIButton+FFMakeBtn.m
//
//  Created by Stephen Hu on 2018/7/24.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "UIButton+FFMakeBtn.h"

@implementation UIButton (FFMakeBtn)

+ (instancetype) buttonWithTitle:(NSString *)title andBackGrounColor:(UIColor *)bgColor{
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    btn.backgroundColor = bgColor;
    return btn;
}

+ (instancetype) customButtonWithTitle:(NSString *)title andBackGrounColor:(UIColor *)bgColor{
    UIButton *btn = [self buttonWithNormalImage:nil andTitle:title];
    btn.tintColor = [UIColor whiteColor];
    btn.backgroundColor = bgColor;
    return btn;
}
+ (instancetype) buttonWithNormalImage:(UIImage *)image {
    return [self buttonWithNormalImage:image andTitle:nil];
}

+ (instancetype) buttonWithNormalImage:(UIImage *)image andTitle:(NSString *)title {
   return  [self buttonWithNormalImage:image andSelectedImage:nil andHighlightedImage:nil andTitle:title];
}

+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage {
    return [self buttonWithNormalImage:image andSelectedImage:selectedImage andHighlightedImage:nil andTitle:nil];
}

+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andTitle:(NSString *)title {
    return [self buttonWithNormalImage:image andSelectedImage:selectedImage andHighlightedImage:nil andTitle:title];
}

+ (instancetype) buttonWithNormalImage:(UIImage *)image andSelectedImage:(UIImage *)selectedImage andHighlightedImage:(UIImage *)highlightedImage andTitle:(NSString *)title {
    UIButton *btn = [[self alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
@end
