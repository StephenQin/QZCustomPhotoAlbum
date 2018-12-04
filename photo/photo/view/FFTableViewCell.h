//
//  FFTableViewCell.h
//  FashionFox
//
//  Created by Stephen Hu on 2018/9/28.
//  Copyright © 2018 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFAlbumListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFTableViewCell : UITableViewCell
@property (nonatomic, strong) FFAlbumListModel *model;
@end

NS_ASSUME_NONNULL_END
