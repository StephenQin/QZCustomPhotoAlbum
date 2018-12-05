//
//  FFAlbumListViewController.h
//
//  Created by Stephen Hu on 2018/9/28.
//  Copyright © 2018 iDress. All rights reserved.
//

#import "FFRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^FFAlbumClickBlcok)(NSInteger index);
@interface FFAlbumListViewController : FFRootViewController
@property (nonatomic, copy) NSArray *albumInfoArr;
@property (copy, nonatomic) FFAlbumClickBlcok clickBlock;
@end

NS_ASSUME_NONNULL_END
