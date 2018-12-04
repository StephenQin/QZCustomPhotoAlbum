//
//  FFAlbumListModel.h
//
//  Created by Stephen Hu on 2018/9/28.
//  Copyright © 2018 iDress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface FFAlbumListModel : NSObject
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *photoNum;
@property (nonatomic, strong) PHAsset *asset;
@end

NS_ASSUME_NONNULL_END
