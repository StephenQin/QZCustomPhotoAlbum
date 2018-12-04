//
//  FFPhotoPickerViewController.m
//
//  Created by Stephen Hu on 2018/9/17.
//  Copyright © 2018年 iDress. All rights reserved.
/*  为了显示中文的相册名字
 info.plist里面添加
 Localizedresources can be mixed YES
 Localization native development region China
 */

#import "FFPhotoPickerViewController.h"
#import "FFFindAlbumCell.h"
#import "FFFindPhotoShowView.h"
#import <Photos/Photos.h>
#import "FFTakePhotoViewController.h"
#import "FFTestViewController.h"
#import "FFAlbumListViewController.h"

@interface FFPhotoPickerViewController ()<FFFindAlbumCellDelegate>
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UIButton *nextBtn;
//@property (nonatomic, weak) UIImageView *bigImgView;
@property (nonatomic, weak) FFFindPhotoShowView *showView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *photoAlbumBtn;
@property (nonatomic, weak) UIButton *takePhotoBtn;
@property (nonatomic, weak) UIView *photoAlbumContainView;
@property (nonatomic, weak) UIView *albumTopControlView;

@property (strong, nonatomic) NSArray<PHAsset*>* currentCollectionData; // 保存所有拿到的PHAsset数据
@property (strong, nonatomic) NSMutableArray * imagesArray; // 保存小图片的数组
@property (strong, nonatomic) NSMutableArray * indexArray;  // 保存选中的index
@property (assign, nonatomic) PHImageRequestID requestID;
//@property (assign, nonatomic) NSInteger maxSelectCount;
@property (nonatomic, strong) NSMutableArray *finalImageArr; // 最终得到的照片数组
@property (nonatomic, weak) UIView *takePhotoView;
@property (nonatomic, strong) FFTakePhotoViewController *takePhotoVc;
#pragma mark ————— 新添加 —————
@property (nonatomic, weak) UIButton *chooseAlbumBtn; // 选择其他的相册
@property (strong, nonatomic) NSArray<NSDictionary *> *collectionData; // 其他相册数据
@property (assign, nonatomic) NSInteger currentCollectionCount;   // 当前选择的是第几个相册
@property (strong, nonatomic) NSString* currentCollectionTitle;   // 当前选择的相册的名字
@property (nonatomic, assign) BOOL haveOpen; // 相册是否打开过
//@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@end

@implementation FFPhotoPickerViewController

#pragma mark ————— 点击事件 —————

/**退出*/
- (void)closeBtnAction:(UIButton *)sender {
    FLog(@"点击关闭");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**点击顶部相册名字*/
- (void)chooseAlbumBtnAction:(UIButton *)sender {
    FLog(@"选择相册数据");
    FFAlbumListViewController *albumListVc = [FFAlbumListViewController new];
    albumListVc.albumInfoArr = self.collectionData;
    albumListVc.clickBlock = ^(NSInteger index) {
        FLog(@"点击选择第%zd个相册",index);
        [self setSelectCollectionCount:index];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumListVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**点击继续*/
- (void)nextBtnAction:(UIButton *)sender {
    FLog(@"点击继续,拿到最终的图片数组");
    if (self.indexArray.count > self.finalImageArr.count) {
        UIImage *img = [self.showView getSnapshotImage];
        [self.finalImageArr addObject:img];
        FFTestViewController *test = [FFTestViewController new];
        test.img = img;
        [self presentViewController:test animated:YES completion:nil];
    }
    FLog(@"最后得到的图片数组%@",self.finalImageArr);
}

/**点击拍照*/
- (void)takePhoto:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.photoAlbumBtn.selected = NO;
    FLog(@"点击拍射照片");
    self.photoAlbumContainView.hidden = YES;
    if (!self.takePhotoVc) {
        FFTakePhotoViewController *takePhoto = [FFTakePhotoViewController new];
        self.takePhotoVc = takePhoto;
        [self addChildViewController:takePhoto];
        [takePhoto didMoveToParentViewController:self];
        self.takePhotoView = takePhoto.view;
        takePhoto.view.frame = self.photoAlbumContainView.frame;
        [self.view addSubview:takePhoto.view];
    } else {
        self.takePhotoView.hidden = NO;
        [self.takePhotoVc startCapture];
    }
}

/**选择了一个相册*/
- (void)setSelectCollectionCount:(NSInteger)count {
    if (_collectionData.count <= count) {
        return;
    }
    [self.indexArray removeAllObjects];
    [self.finalImageArr removeAllObjects];
    CGFloat targetSize = (kScreenWidth - 3) / 4.0;
    _currentCollectionCount = count;
    _currentCollectionTitle = [[_collectionData[_currentCollectionCount] allKeys] lastObject];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chooseAlbumBtn setTitle:self.currentCollectionTitle forState:UIControlStateNormal];
    });
    NSArray * temp  = [[_collectionData[_currentCollectionCount] allValues] firstObject];
    self.currentCollectionData = [NSArray arrayWithArray:temp];
    
    // 主要用于缓存PHAsset
    [self.imageManager stopCachingImagesForAllAssets];
    [self.imageManager startCachingImagesForAssets:self.currentCollectionData
                                        targetSize:CGSizeMake(targetSize, targetSize)
                                       contentMode:PHImageContentModeAspectFill
                                           options:nil];
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact; // 精准的尺寸
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;// 图像质量在速度与质量中均衡
    options.synchronous = YES;  // 请求是否同步执行  此处设置为YES后deliveryMode 默认为PHImageRequestOptionsDeliveryModeHighQualityFormat
    for (PHAsset * asset in self.currentCollectionData) {
        [self.imageManager requestImageForAsset:asset
                                                   targetSize:CGSizeMake(targetSize, targetSize)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    if (result) {[self.imagesArray addObject:result];}
                                                }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        self.haveOpen = YES;
        [self.collectionView reloadData];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    });
}

/**点击底部相册*/
- (void)openPhotoAlbum:(UIButton *)sender {
    if (sender.selected) {return;}
    sender.selected = YES;
    self.photoAlbumContainView.hidden = NO;
    self.takePhotoView.hidden = YES;
    self.takePhotoBtn.selected = NO;
    [self.takePhotoVc stopCapture];
    if (self.haveOpen) {return;}
    NSMutableArray * tempCollectionsArray = [NSMutableArray array];
    FLog(@"点击相册");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取系统的相册
        PHFetchResult * sysfetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum // 经由相机得来的相册
                                                                                  subtype:PHAssetCollectionSubtypeAlbumRegular //用户在 Photos 中创建的相册，也就是我所谓的逻辑相册
                                                                                  options:nil];
        NSArray * titlesArray = @[@"相机胶卷", @"屏幕快照", @"最近添加", @"所有照片",@"动图",@"自拍"];
        [sysfetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * collectionTitle = obj.localizedTitle;
            FLog(@"相册的名字是:%@",collectionTitle);
            NSArray* data = [self getAssetWithCollection:obj];
            if ([titlesArray indexOfObject:collectionTitle] != NSNotFound) {
                if ([collectionTitle isEqualToString:@"最近添加"]) {
                    [tempCollectionsArray insertObject:@{collectionTitle:data} atIndex:0];
                } else {
                    [tempCollectionsArray addObject:@{collectionTitle:data}];
                }
            }
        }];
#pragma mark ————— 获取个人的相册列表 —————
        PHFetchResult * userfetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        for (PHAssetCollection * assetCollection in userfetchResult) {
            NSString * collectionTitle = assetCollection.localizedTitle;
            FLog(@"======相册的名字是：%@",collectionTitle);
            NSArray * assets = [self getAssetWithCollection:assetCollection];
            if (assets.count != 0) {
                [tempCollectionsArray addObject:@{collectionTitle:assets}];
            }
        }
        self.collectionData = [NSArray arrayWithArray:tempCollectionsArray];
        if (self.collectionData.count > 0) {
            // 默认选择最近添加
            [self setSelectCollectionCount:0];
        }
    });
}


/**从一个照片组内获取到照片信息PHAsset*/
- (NSArray *)getAssetWithCollection:(PHAssetCollection *)collection {
    //set fetchoptions
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage]; // 只选则照片
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    //search
    NSMutableArray * assetArray = [NSMutableArray array];
    PHFetchResult * assetFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset * asset in assetFetchResult) {
        [assetArray addObject:asset];
    }
    return assetArray;
}

// 从一个asset得到一张image
- (void)getImgeFromAPHAsset:(PHAsset *)asset {
    
    if (_requestID) {
        [self.imageManager cancelImageRequest:_requestID];
        _requestID = 0;
    }
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.networkAccessAllowed = YES;
    kWeakSelf(self);
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSLog(@"加载进度是%lf",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSString * errorString = error.userInfo[@"NSLocalizedDescription"];
                if (errorString) {
                    [MBProgressHUD showError:errorString];
                }
            }
        });
    };
    CGSize targetSize = CGSizeMake(asset.pixelWidth,asset.pixelHeight);//self.bigImgView.bounds.size;
    weakself.requestID = [self.imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (result) {
            [self.showView setBigImage:result];
        }
    }];
}

#pragma mark ————— FFFindAlbumCellDelegate —————
- (void)albumCell:(FFFindAlbumCell *)albumCell didSelectedSeltectBtn:(UIButton *)seltectBtn {
    if (seltectBtn.selected) {
        seltectBtn.selected = NO;
        NSInteger index = seltectBtn.titleLabel.text.integerValue;
        if (index <= self.finalImageArr.count) {
            [self.finalImageArr removeObjectAtIndex:index - 1];
        }
        [self.indexArray removeObject:[self.collectionView indexPathForCell:albumCell]];
        if (self.indexArray.count == 0) {self.nextBtn.enabled = NO;}
        [seltectBtn setTitle:@"" forState:UIControlStateNormal];
        [self.collectionView reloadItemsAtIndexPaths:self.indexArray];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:self.indexArray.lastObject];
        
    }
    FLog(@"取消选中后final数组%@",self.finalImageArr);
    FLog(@"取消选中后index数组%@",self.indexArray);
}

#pragma mark ————— UICollectionViewDelegate —————
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FFFindAlbumCell *newCell = (FFFindAlbumCell *)cell;
    for (NSIndexPath *index in self.indexArray) {
        if ([indexPath compare:index] == NSOrderedSame) {
            NSInteger count = [self.indexArray indexOfObject:index];
            NSString * title = [NSString stringWithFormat:@"%ld",count + 1];
            [newCell.selectBtn setTitle:title forState:UIControlStateNormal];
            [newCell.selectBtn setSelected:YES];
            return;
        }
    }
    [newCell.selectBtn setTitle:@"" forState:UIControlStateNormal];
    [newCell.selectBtn setSelected:NO];
}

#pragma mark ————— UICollectionViewDataSource —————
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFFindAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FFFindAlbumCell class]) forIndexPath:indexPath];
    PHAsset * asset = self.currentCollectionData[indexPath.row];
    cell.asset = asset;
    cell.delegate = self;
    cell.photoView.image = self.imagesArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FFFindAlbumCell *newCell = (FFFindAlbumCell *)[collectionView cellForItemAtIndexPath:indexPath];
    newCell.selectBtn.selected = YES;
    PHAsset * asset = self.currentCollectionData[indexPath.row];
    if (newCell.selectBtn.selected) {// 判断按钮的显示数字
        if ([self.indexArray containsObject:indexPath]) {
            [self getImgeFromAPHAsset:asset];
            if (self.indexArray.count > self.finalImageArr.count) {// 点击重复的，如果点的角标不是最大的把最大的截图
                [self.finalImageArr addObject:[self.showView getSnapshotImage]];
            }
            return;
        }
        if (self.indexArray.count == 6) {
            newCell.selectBtn.selected = NO;
            return;
        }
        [self.indexArray addObject:indexPath];
        self.nextBtn.enabled = YES;
        if (self.indexArray.count > 1) {// 第一次不截图
            [self.finalImageArr addObject:[self.showView getSnapshotImage]];
        }
    } else {
        [self.indexArray removeObject:indexPath];
        if (self.indexArray.count == 0) {
            self.nextBtn.enabled = NO;
        }
    }
    [self.collectionView reloadItemsAtIndexPaths:self.indexArray];
    [self getImgeFromAPHAsset:asset];
    FLog(@"点击了返回相册的的第%zd个item",indexPath.row);
    FLog(@"点击选中后final数组%@",self.finalImageArr);
    FLog(@"点击选中后index数组%@",self.indexArray);
}
#pragma mark ————— 基本设置 —————
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self makeupUI];
    self.imageManager = [[PHCachingImageManager alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showMessage:@"正在加载……"];
}
- (void)makeupUI {
    self.haveOpen = NO;
    [self.photoAlbumContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNoStatusBarHeight);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-(kBottomToolBarHeight + 48));
    }];
    [self.albumTopControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    [self.chooseAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make center];
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(150);
    }];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_offset(0);
        make.top.mas_equalTo(self.albumTopControlView.mas_bottom);
        make.height.mas_equalTo(kRealValueH(360));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.top.mas_equalTo(self.showView.mas_bottom).offset(5);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoAlbumContainView.mas_bottom);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-kBottomToolBarHeight);
    }];
    [self.photoAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView).offset(-kScreenWidth * 0.25);
        [make centerY];
    }];
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView).offset(kScreenWidth * 0.25);
        [make centerY];
    }];
}
- (void)setupCollectionView {
    [self.photoAlbumContainView addSubview:self.collectionView];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat width = 1.0 * (kScreenWidth - 3.0) / 4.0;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[FFFindAlbumCell class] forCellWithReuseIdentifier:NSStringFromClass([FFFindAlbumCell class])];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prefersStatusBarHidden];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self openPhotoAlbum:self.photoAlbumBtn];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoAlbumContainView.hidden = YES;
            });
        }
    }];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark ————— lazyLoad —————
- (UIView *)albumTopControlView {
    if (!_albumTopControlView) {
        UIView *albumTopControlView = [UIView new];
        [self.photoAlbumContainView addSubview:albumTopControlView];
        _albumTopControlView = albumTopControlView;
    }
    return _albumTopControlView;
}
- (FFFindPhotoShowView *)showView {
    if (!_showView) {
        FFFindPhotoShowView *showView = [FFFindPhotoShowView new];
        [self.photoAlbumContainView addSubview:showView];
        _showView = showView;
    }
    return _showView;
}
- (UIButton *)takePhotoBtn {
    if (!_takePhotoBtn) {
        UIButton *takePhotoBtn = [UIButton buttonWithTitle:@"拍照" andBackGrounColor:[UIColor whiteColor]];
        [takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [takePhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [takePhotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [takePhotoBtn setBackgroundImage:kImageNamed(@"红色下划线") forState:UIControlStateSelected];
        [takePhotoBtn setBackgroundImage:kImageNamed(@"白色下划线") forState:UIControlStateNormal];
        [self.bottomView addSubview:takePhotoBtn];
        _takePhotoBtn = takePhotoBtn;
    }
    return _takePhotoBtn;
}
- (UIButton *)photoAlbumBtn {
    if (!_photoAlbumBtn) {
        UIButton *photoAlbumBtn = [UIButton buttonWithTitle:@"相册" andBackGrounColor:[UIColor whiteColor]];
        [photoAlbumBtn addTarget:self action:@selector(openPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [photoAlbumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [photoAlbumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [photoAlbumBtn setBackgroundImage:kImageNamed(@"红色下划线") forState:UIControlStateSelected];
        [photoAlbumBtn setBackgroundImage:kImageNamed(@"白色下划线") forState:UIControlStateNormal];
        [self.bottomView addSubview:photoAlbumBtn];
        _photoAlbumBtn = photoAlbumBtn;
    }
    return _photoAlbumBtn;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}
- (UIView *)photoAlbumContainView {
    if (!_photoAlbumContainView) {
        UIView *photoAlbumContainView = [UIView new];
        [self.view addSubview:photoAlbumContainView];
        _photoAlbumContainView = photoAlbumContainView;
    }
    return _photoAlbumContainView;
}
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        UIButton *nextBtn = [UIButton buttonWithTitle:@"继续"andBackGrounColor:[UIColor whiteColor]];
        //        nextBtn.backgroundColor = kRedColor;
        nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.enabled = NO;
        [self.albumTopControlView addSubview:nextBtn];
        _nextBtn = nextBtn;
    }
    return _nextBtn;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *closeBtn = [UIButton  buttonWithNormalImage:kImageNamed(@"关闭")];
        //        closeBtn.backgroundColor = kRedColor;
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.albumTopControlView addSubview:closeBtn];
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}
- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        NSMutableArray *imagesArray = [NSMutableArray array];
        _imagesArray = imagesArray;
    }
    return _imagesArray;
}
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        NSMutableArray *indexArray = [NSMutableArray array];
        _indexArray = indexArray;
    }
    return _indexArray;
}
- (NSMutableArray *)finalImageArr {
    if (!_finalImageArr) {
        NSMutableArray *finalImageArr = [NSMutableArray array];
        _finalImageArr = finalImageArr;
    }
    return _finalImageArr;
}
- (UIButton *)chooseAlbumBtn {
    if (!_chooseAlbumBtn) {
        UIButton *chooseAlbumBtn = [UIButton buttonWithTitle:@"最近添加" andBackGrounColor:[UIColor whiteColor]];
        [chooseAlbumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [chooseAlbumBtn addTarget:self action:@selector(chooseAlbumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.albumTopControlView addSubview:chooseAlbumBtn];
        _chooseAlbumBtn = chooseAlbumBtn;
    }
    return _chooseAlbumBtn;
}
@end
