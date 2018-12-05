//
//  FFFindPhotoShowView.h
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/19.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FFFindPhotoShowView : UIView
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic, weak)   UIScrollView *scroView;
@property (nonatomic, assign) CGFloat loadingProgress;
- (UIImage *)getSnapshotImage;
@end

NS_ASSUME_NONNULL_END
