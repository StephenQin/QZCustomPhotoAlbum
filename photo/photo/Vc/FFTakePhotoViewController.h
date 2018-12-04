//
//  FFTakePhotoViewController.h
//
//  Created by Stephen Hu on 2018/9/20.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FFTakePhotoViewController : UIViewController
@property (nonatomic, assign) BOOL haveTackPhoto;
/**
 停止拍摄
 */
- (void)stopCapture;

/**
 开始拍摄
 */
- (void)startCapture;
@end

NS_ASSUME_NONNULL_END
