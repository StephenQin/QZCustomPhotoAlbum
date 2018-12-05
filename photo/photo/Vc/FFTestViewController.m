//
//  FFTestViewController.m
//
//  Created by Stephen Hu on 2018/9/19.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFTestViewController.h"
#import "FFFindAlbumCell.h"

@interface FFTestViewController ()
@end

@implementation FFTestViewController
- (void)dismissBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD hideHUD];
    }];
}
- (void)setupCollectionView {
    [self.view addSubview:self.collectionView];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenWidth);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[FFFindAlbumCell class] forCellWithReuseIdentifier:NSStringFromClass([FFFindAlbumCell class])];
}

#pragma mark ————— UICollectionViewDataSource —————
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rawImgArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFFindAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FFFindAlbumCell class]) forIndexPath:indexPath];
    UIImage *img = self.rawImgArr[indexPath.row];
    CGSize size = img.size;
    NSLog(@"img的原始尺寸是%@",NSStringFromCGSize(size));
    cell.photoView.image = self.rawImgArr[indexPath.row];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
    UIButton *dismissBtn = [UIButton buttonWithTitle:@"dismiss" andBackGrounColor:[UIColor whiteColor]];
    [dismissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make center];
        make.width.height.mas_equalTo(80);
    }];
}
@end
