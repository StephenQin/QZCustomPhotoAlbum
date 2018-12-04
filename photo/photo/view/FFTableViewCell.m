//
//  FFTableViewCell.m
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/28.
//  Copyright © 2018 iDress. All rights reserved.
//

#import "FFTableViewCell.h"

@interface FFTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *albumPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumNum;
@property (assign, nonatomic) PHImageRequestID requestId;
@end
@implementation FFTableViewCell
#pragma mark ————— 赋值 —————
- (void)setModel:(FFAlbumListModel *)model {
    _model = model;
    [self setPhotoWithAsset:model.asset];
    self.albumTitle.text = model.albumTitle;
    self.albumNum.text   = model.photoNum;
}
- (void)setPhotoWithAsset:(PHAsset *)asset {
    if (_requestId) {
        [[PHImageManager defaultManager] cancelImageRequest:_requestId];
    }
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    CGFloat width = self.frame.size.width * 2;
    CGFloat height = width / asset.pixelWidth * asset.pixelHeight;
    if (height < self.frame.size.height) {
        height = self.frame.size.height * 2;
        width = height / asset.pixelHeight * asset.pixelWidth;
    }
    if (asset) {
        kWeakSelf(self);
        _requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(width, height) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
//                [weakself.albumPhotoView setImage:nil];
                [weakself.albumPhotoView setImage:result];
            }
        }];
    } else {
        [self.albumPhotoView setImage:kPlaceholderImg];
    }
}
#pragma mark ————— 基本设置 —————
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
