//
//  QZSectorProgressView.m
//  photo
//
//  Created by Stephen Hu on 2018/12/5.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "QZSectorProgressView.h"

@implementation QZSectorProgressView

#pragma mark ————— 基础设置 —————
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//重写progress的set方法,可以在赋值的同时给label赋值
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    // 赋值结束之后要刷新UI,不然看不到扇形的变化
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width / 2.0;
    // 定义扇形中心
    CGPoint origin = CGPointMake(width, width);
    // 定义扇形半径
    CGFloat radius = width;
    // 设定扇形起点位置
    CGFloat startAngle = - M_PI_2;
    // 根据进度计算扇形结束位置
    CGFloat endAngle = startAngle + self.progress * M_PI * 2;
    // 根据起始点、原点、半径绘制弧线
    UIBezierPath *sectorPath = [UIBezierPath bezierPathWithArcCenter:origin radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 从弧线结束为止绘制一条线段到圆心。这样系统会自动闭合图形,绘制一条从圆心到弧线起点的线段。
    [sectorPath addLineToPoint:origin];
    // 设置扇形的填充颜色
    [[UIColor colorWithWhite:.7 alpha:.7] set];
    // 设置扇形的填充模式
    [sectorPath fill];
}


@end
