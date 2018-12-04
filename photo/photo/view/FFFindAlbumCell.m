//
//  FFFindAlbumCell.m
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/17.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFFindAlbumCell.h"

@interface FFFindAlbumCell()
//@property (nonatomic, weak) UIImageView *photoView;
@property (assign, nonatomic) PHContentEditingInputRequestID editRequestID;
//@property (nonatomic, weak) UIButton *selectBtn;
@property (strong, nonatomic) CALayer * maskLayer;
@end
@implementation FFFindAlbumCell

#pragma mark ————— 赋值 —————
//- (void)setIsSelected:(BOOL)isSelected {
//    _isSelected = isSelected;
//    if (_isSelected) {
//        [_photoView.layer addSublayer:[self getMaskLayer]];
//    } else if (_maskLayer){
//        [_maskLayer removeFromSuperlayer];
//        _maskLayer = nil;
//    }
//}

#pragma mark ————— 点击事件 —————
- (void)selectBtnAction:(UIButton *)sender {
    //查询图片信息
//    if (_editRequestID) {
//        [_asset cancelContentEditingInputRequest:_editRequestID];
//    }
//    _editRequestID = [_asset checkIsICloudResource:^(BOOL isCloud) {
//        if (!isCloud) {
//            [sender setSelected:!sender.selected];
//            if (!sender.selected) {
//                [sender setTitle:@"" forState:UIControlStateNormal];
//            }
            if ([self.delegate respondsToSelector:@selector(albumCell:didSelectedSeltectBtn:)]) {
                [self.delegate albumCell:self didSelectedSeltectBtn:sender];
            }
//        } else {
//            [MBProgressHUD showError:@"iCloud请先下载到本地"];
//        }
//    }];
}
- (void)setSelected:(BOOL)selected {
    if (selected) {
        [_photoView.layer addSublayer:[self getMaskLayer]];
    } else if (_maskLayer){
        [_maskLayer removeFromSuperlayer];
        _maskLayer = nil;
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
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.right.mas_offset(-5);
        make.width.height.mas_equalTo(20);
    }];
}

- (CALayer *)getMaskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        [_maskLayer setFrame:self.bounds];
        [_maskLayer setBackgroundColor:kRGBColor(222, 222, 222, 0.5).CGColor];
        [_maskLayer setBorderColor:[UIColor blackColor].CGColor];
        [_maskLayer setBorderWidth:1 / kScale];
    }
    return _maskLayer;
}
#pragma mark ————— lazyLoad —————
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [selectBtn setBackgroundImage:kImageNamed(@"1Oval") forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:kImageNamed(@"Oval") forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectBtn];
        _selectBtn = selectBtn;
    }
    return _selectBtn;
}
- (UIImageView *)photoView {
    if (!_photoView) {
        UIImageView *photoView = [[UIImageView alloc] initWithImage:kPlaceholderImg];
        [self.contentView addSubview:photoView];
        _photoView = photoView;
    }
    return _photoView;
}
@end
