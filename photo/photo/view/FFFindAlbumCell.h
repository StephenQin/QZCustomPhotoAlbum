//
//  FFFindAlbumCell.h
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/17.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class FFFindAlbumCell;
@protocol FFFindAlbumCellDelegate <NSObject>
- (void)albumCell:(FFFindAlbumCell *)albumCell didSelectedSeltectBtn:(UIButton *)seltectBtn;
@end
@interface FFFindAlbumCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *photoView;
//@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) PHAsset * asset;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) id<FFFindAlbumCellDelegate> delegate;
@end
