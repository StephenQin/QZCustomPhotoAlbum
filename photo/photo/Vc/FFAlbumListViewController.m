//
//  FFAlbumListViewController.m
//
//  Created by Stephen Hu on 2018/9/28.
//  Copyright © 2018 iDress. All rights reserved.
//

#import "FFAlbumListViewController.h"
#import "FFTableViewCell.h"

@interface FFAlbumListViewController ()
@property (nonatomic, copy) NSArray *albumModelArr;
@end

@implementation FFAlbumListViewController
#pragma mark ————— dismiss —————
- (void)backBtnClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark ————— 代理方法 —————
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.clickBlock) {
            self.clickBlock(indexPath.row);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell"];
    FFAlbumListModel *model = self.albumModelArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
#pragma mark ————— 基本设置 —————
- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseSet];
    [self getAlbumData];
}
- (void)getAlbumData {
    NSMutableArray *tmpArr = [NSMutableArray array];
    [self.albumInfoArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull album, NSUInteger idx, BOOL * _Nonnull stop) {
        FFAlbumListModel *model = [FFAlbumListModel new];
        NSArray * photos = [[album allValues] lastObject];
        model.albumTitle = [[album allKeys] lastObject];
        model.photoNum = [NSString stringWithFormat:@"%ld",photos.count];
        if (photos.count > 0) {
            model.asset = photos[0];
        }
        [tmpArr addObject:model];
    }];
    self.albumModelArr = tmpArr.copy;
    [self.tableView reloadData];
}
- (void)baseSet {
    self.title = @"相册";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_offset(0);
        make.top.mas_offset(kNavigationHeight);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomToolBarHeight, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kBottomToolBarHeight, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"FFTableViewCell" bundle:nil] forCellReuseIdentifier:@"albumCell"];
}
@end
