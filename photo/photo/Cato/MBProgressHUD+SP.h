//
//  MBProgressHUD+SP.h
//  穷游
//
//  Created by leshengping on 17/1/3.
//  Copyright © 2017年 idress. All rights reserved.
//  对MBProgress写的分类

#import "MBProgressHUD.h"

@interface MBProgressHUD (SP)

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (instancetype)showSuccess:(NSString *)success;
/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (instancetype)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示错误信息
 *
 */
+ (instancetype)showError:(NSString *)error;
/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (instancetype)showError:(NSString *)error toView:(UIView *)view;


/**
 *  显示普通信息（带菊花）
 *
 *  @param message 信息内容
 */
+ (instancetype)showMessage:(NSString *)message;


/**
 *  显示纯文字信息（不带菊花），居中显示
 *
 *  @param text 信息内容
 *  @param duration 多少时间后隐藏
 */
+ (instancetype)showText:(NSString *)text hideAfterTime:(NSInteger)duration;

/**
 *  显示纯文字信息（不带菊花），可设置hud在屏幕中的位置
 *
 *  @param text 信息内容
 *  @param offsetY 在屏幕中的垂直位置,0居中显示,(0,+∞)之间向下偏移,永远不会超过屏幕底部，(-∞,0)之间向上偏移，永远不会超过屏幕顶部
 *  @param duration 多少时间后隐藏
 */
+ (instancetype)showText:(NSString *)text offsetY:(CGFloat)offsetY hideAfterTime:(NSInteger)duration;

/**
 *  显示普通信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 */
+ (instancetype)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  隐藏MBProgressHUD
 */
+ (BOOL)hideHUD;
/**
 *  隐藏MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图, 在哪里显示，就在哪里隐藏
 */
+ (BOOL)hideHUDFromView:(UIView *)view;

@end




