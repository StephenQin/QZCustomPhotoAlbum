//
//  FFFindPhotoShowView.m
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/19.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFFindPhotoShowView.h"
#import "QZSectorProgressView.h"

@interface FFFindPhotoShowView()<UIScrollViewDelegate>
//@property (nonatomic, weak) UIScrollView *scroView;
@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIImageView *photoView;
@property (nonatomic, strong) NSMutableArray *layerArr;
@property (nonatomic, weak) QZSectorProgressView *progressView;
@end
@implementation FFFindPhotoShowView

#pragma mark ————— 赋值 —————
- (void)setBigImage:(UIImage *)bigImage {
    _bigImage = bigImage;
    [self.photoView setImage:bigImage];
    [self makeupUI];
}
- (void)setLoadingProgress:(CGFloat)loadingProgress {
    _loadingProgress = loadingProgress;
    self.progressView.progress = loadingProgress;
    self.progressView.hidden = NO;
    if (loadingProgress == 1) {
        self.progressView.hidden = YES;
    }
}
#pragma mark ————— 赋值 —————
- (UIImage *)getSnapshotImage {
    UIImage *snapshotImage = [self screenshotOfView:self.scroView];
    return snapshotImage;
}
- (UIImage *)screenshotOfView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        CGRect rect = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
        [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    }
    else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    return image;
}
- (UIImage *)captureImage:(UIImage *)image Rect:(CGRect)rect {
    // 图片的实际宽度
    CGFloat realImageW = CGImageGetWidth(image.CGImage);
    // 图片的实际宽度与@1x图片的宽度之比
    CGFloat scale = realImageW/image.size.width;
    CGFloat captureX = rect.origin.x * scale;
    CGFloat captureY = rect.origin.y * scale;
    CGFloat captureW = rect.size.width * scale;
    CGFloat captureH = rect.size.height * scale;
    CGImageRef imgRef = image.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(imgRef, CGRectMake(captureX, captureY,captureW, captureH));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
}
#pragma mark ————— UIScrollViewDelegate —————
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat scrollW = CGRectGetWidth(scrollView.frame);
    CGFloat scrollH = CGRectGetHeight(scrollView.frame);
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetX = scrollW > contentSize.width ? (scrollW - contentSize.width) * 0.5 : 0;
    CGFloat offsetY = scrollH > contentSize.height ? (scrollH - contentSize.height) * 0.5 : 0;
    CGFloat centerX = contentSize.width * 0.5 + offsetX;
    CGFloat centerY = contentSize.height * 0.5 + offsetY;
    self.photoView.center = CGPointMake(centerX, centerY);
    [self.layerArr setValue:@(NO) forKeyPath:@"hidden"];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [self.layerArr setValue:@(YES) forKeyPath:@"hidden"];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.layerArr setValue:@(NO) forKeyPath:@"hidden"];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.layerArr setValue:@(YES) forKeyPath:@"hidden"];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self.layerArr setValue:@(YES) forKeyPath:@"hidden"];
        }
    }
}

#pragma mark ————— 基础设置 —————
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeupUI];
    }
    return self;
}
- (void)makeupUI {
    [self.scroView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 38, 0, 38));
    }];
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        if (self.photoView.image.size.height >= self.photoView.image.size.width) {
            make.width.mas_equalTo(kScreenWidth - 76);
        } else {
            make.height.mas_equalTo(kRealValueH(360));
        }
    }];
    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        if (self.photoView.image.size.height >= self.photoView.image.size.width) {
            make.width.mas_equalTo(self.containView.mas_width);
            make.height.mas_equalTo((kScreenWidth - 76)*self.photoView.image.size.height/self.photoView.image.size.width);
        } else {
            make.width.mas_equalTo(kRealValueH(360) * self.photoView.image.size.width / self.photoView.image.size.height);
            make.height.mas_equalTo(self.containView.mas_height);
        }
    }];
    [self addGrid:self];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.scroView).offset(-5);
        make.width.height.mas_equalTo(20);
    }];
}
- (void)addGrid:(UIView *)view {
    CGFloat widthView = view.frame.size.width;
    CGFloat heightView = view.frame.size.height;
    CGFloat widthsize = (widthView - 76) / 3.0;
    CGFloat heightsize = heightView / 3.0;
    void (^addLineWidthRect)(CGRect rect) = ^(CGRect rect) {
        CALayer *layer = [[CALayer alloc] init];
        layer.hidden = YES;
        [self.layerArr addObject:layer];
        [view.layer addSublayer:layer];
        layer.frame = rect;
        layer.backgroundColor = [UIColor whiteColor].CGColor;
    };
    for (int i = widthsize + 38; i < widthView; i += (widthsize + 1)) {
        addLineWidthRect(CGRectMake(i, 0, 1, heightView));
    }
    for (int i = heightsize; i < heightView; i += (heightsize + 1)) {
        addLineWidthRect(CGRectMake(0, i, widthView, 1));
    }
}
#pragma mark ————— lazyLoad —————
- (QZSectorProgressView *)progressView {
    if (!_progressView) {
        QZSectorProgressView *progressView = [QZSectorProgressView new];
        progressView.hidden = YES;
        [self addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}
- (UIImageView *)photoView {
    if (!_photoView) {
        UIImageView *photoView = [[UIImageView alloc] initWithImage:kPlaceholderImg];
//        photoView.contentMode = UIViewContentModeScaleToFill;
        [self.containView addSubview:photoView];
        photoView.backgroundColor = [UIColor redColor];
        _photoView = photoView;
    }
    return _photoView;
}
- (UIView *)containView {
    if (!_containView) {
        UIView *containView = [UIView new];
        [self.scroView addSubview:containView];
        _containView = containView;
    }
    return _containView;
}
- (UIScrollView *)scroView {
    if (!_scroView) {
        UIScrollView *scroView = [[UIScrollView alloc] init];
        scroView.showsVerticalScrollIndicator = NO;
        scroView.showsHorizontalScrollIndicator = NO;
        scroView.multipleTouchEnabled = YES;
        scroView.maximumZoomScale = 3.0;
        scroView.minimumZoomScale = 1.0;
        scroView.alwaysBounceVertical = YES;
        scroView.alwaysBounceHorizontal = YES;
        scroView.delegate = self;
        [self addSubview:scroView];
        _scroView = scroView;
    }
    return _scroView;
}
- (NSMutableArray *)layerArr {
    if (!_layerArr) {
        NSMutableArray *layerArr = [NSMutableArray array];
        _layerArr = layerArr;
    }
    return _layerArr;
}
@end
