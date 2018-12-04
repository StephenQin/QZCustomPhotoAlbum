//
//  FFTakePhotoViewController.m
//
//  Created by Stephen Hu on 2018/9/20.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFTakePhotoViewController.h"
@interface FFTakePhotoViewController ()
/**
 预览视图
 */
@property (weak, nonatomic) UIView *previewView;
/**
 快门按钮
 */
@property (weak, nonatomic) UIButton *captureButton;
/**
 关闭按钮
 */
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation FFTakePhotoViewController {
    /// 拍摄会话
    AVCaptureSession *_captureSession;
    /// 输入设备 - 摄像头
    AVCaptureDeviceInput *_inputDevice;
    /// 图像输出
    AVCaptureStillImageOutput *_imageOutput;
    /// 取景框 - 预览图层
    AVCaptureVideoPreviewLayer *_previewLayer;
    /// 拍摄完成的图像
    UIImage *_capturedPicture;
}
#pragma mark ————— 点击事件 —————
- (void)closeBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ————— 基础设置 —————
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeupUI];
    // 设置拍摄会话
    [self setupCaptureSession];
}
- (void)makeupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNoStatusBarHeight);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(kRealValue(450));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.previewView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.captureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.previewView.mas_bottom).offset(kRealValue(39));
        [make centerX];
        make.width.height.mas_equalTo(85);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prefersStatusBarHidden];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)capture {
    
    // 判断是否正在拍摄
    if (!_captureSession.isRunning) {
        return;
    }
    // 拍照和保存
    [self capturePicture];
}
/**
 切换摄像头
 */
- (void)switchCamera {
    
    // 判断是否`正在取景` -> 需要做分享的工作
    if (!_captureSession.isRunning) {
        return;
    }
    
    // 0. 具体的设备 - 摄像头／麦克风(模拟器没有摄像头，应该使用真机测试)
    AVCaptureDevice *device = [self captureDevice];
    
    // 1. 创建输入设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    // 停止拍摄会话
    [self stopCapture];
    
    // 删除之前的输入设备
    [_captureSession removeInput:_inputDevice];
    
    // 2. 判断设备能否被添加 - 如果已经有摄像头在会话中，不能添加新的设备
    if ([_captureSession canAddInput:input]) {
        _inputDevice = input;
    }
    
    // 3. 添加到会话
    [_captureSession addInput:_inputDevice];
    
    // 4. 重新启动会话
    [self startCapture];
}
#pragma mark - 相机相关方法

/**
 开始拍摄
 */
- (void)startCapture {
    [_captureSession startRunning];
}

/**
 停止拍摄
 */
- (void)stopCapture {
    [_captureSession stopRunning];
}

/**
 拍照和保存
 */
- (void)capturePicture {
    
    // AVCaptureConnection 表示图像和摄像头的连接
    AVCaptureConnection *conn = _imageOutput.connections.firstObject;
    if (conn == nil) {
        FLog(@"无法连接到摄像头");
        return;
    }
    // 拍摄照片
    [_imageOutput captureStillImageAsynchronouslyFromConnection:conn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        // 判断是否有图像数据的采样缓冲区
        if (imageDataSampleBuffer == nil) {
            FLog(@"没有图像数据采样缓冲区");
            return;
        }
        // 使用图像数据采样缓冲区生成照片的数据
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        // 使用数据生成图像 - 几乎可以显示在一个完整的视图中
        UIImage *image = [UIImage imageWithData:data];
        // 将图像的上下两部分不显示在预览图层中的内容裁切掉！
//         1> 预览视图的大小
        CGRect rect = self.previewView.bounds;
        // 2> 计算裁切掉的大小
        CGFloat offset = (self.view.bounds.size.height - rect.size.height) * 0.5;
        // 3> 利用图像上下文来裁切图像
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        // 4> 绘制图像
        [image drawInRect:CGRectInset(rect, 0, -offset)];
        // 5> 从图像上下文获取绘制结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        // 6> 关闭上下文
        UIGraphicsEndImageContext();
        // 保存图像
        UIImageWriteToSavedPhotosAlbum(result , self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}
/**
 保存相片结束的回调方法
 
 @param image       图像
 @param error       错误
 @param contextInfo 上下文
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 静止画面
    [self stopCapture];
    // 记录成员变量
    _capturedPicture = image;
}

/**
 设置拍摄会话
 */
- (void)setupCaptureSession {
    
    // 0. 具体的设备 - 摄像头／麦克风(模拟器没有摄像头，应该使用真机测试)
    AVCaptureDevice *device = [self captureDevice];
    // 1. 输入设备 - 可以添加到拍摄会话
    _inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    // 2. 输出图像
    _imageOutput = [AVCaptureStillImageOutput new];
    // 3. 拍摄会话
    _captureSession = [AVCaptureSession new];
    // 4. 将输入／输出添加到拍摄会话
    // 为了避免因为客户手机的设备故障以及其他原因，通常需要判断设备能否添加到会话
    if (![_captureSession canAddInput:_inputDevice]) {
        FLog(@"无法添加输入设备");
        return;
    }
    if (![_captureSession canAddOutput:_imageOutput]) {
        FLog(@"无法添加输出设备");
        return;
    }
    [_captureSession addInput:_inputDevice];
    [_captureSession addOutput:_imageOutput];
    // 5. 设置预览图层
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    // 指定图层的大小 - 模态展现的，在 viewDidLoad 方法中，视图的大小还没有确定
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = kRealValue(450);
    _previewLayer.frame = rect;
    // 添加图层到预览视图
    [_previewView.layer insertSublayer:_previewLayer atIndex:0];
    // 设置取景框的拉伸效果 - 统一使用 AVLayerVideoGravityResizeAspectFill
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 6. 开始拍摄
    [self startCapture];
}

/**
 切换摄像头
 
 @return 如果 _inputDevice 有值，要根据对应的摄像头对调，如果没有值，返回后置摄像头
 */
- (AVCaptureDevice *)captureDevice {
    // 1. 获得当前输入设备的镜头位置
    AVCaptureDevicePosition position = _inputDevice.device.position;
    position = (position != AVCaptureDevicePositionBack) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    // 2. 具体的设备 - 摄像头／麦克风(模拟器没有摄像头，应该使用真机测试)
    // 返回摄像头的数组，前置／后置
    NSArray *array = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 遍历数组获取后置摄像头
    AVCaptureDevice *device;
    for (AVCaptureDevice *obj in array) {
        if (obj.position == position) {
            device = obj;
            break;
        }
    }
    return device;
}

#pragma mark ————— lazyload —————
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *closeBtn = [UIButton buttonWithNormalImage:kImageNamed(@"关闭")];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.tintColor = [UIColor whiteColor];
        [self.view addSubview:closeBtn];
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}
- (UIView *)previewView {
    if (!_previewView) {
        UIView *previewView = [UIView new];
        previewView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:previewView];
        _previewView = previewView;
    }
    return _previewView;
}
- (UIButton *)captureButton {
    if (!_captureButton) {
        UIButton *captureButton = [UIButton buttonWithNormalImage:kImageNamed(@"拍摄")];
        [captureButton addTarget:self action:@selector(capturePicture) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:captureButton];
        _captureButton = captureButton;
    }
    return _captureButton;
}
@end
