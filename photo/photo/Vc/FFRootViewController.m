//
//  FFRootViewController.m
//
//  Created by Stephen Hu on 2018/7/13.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFRootViewController.h"
@interface FFRootViewController ()

@end

@implementation FFRootViewController

#pragma mark - 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.tableView.scrollIndicatorInsets =_tableView.contentInset;
        self.groupTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.groupTableView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.groupTableView.scrollIndicatorInsets =_groupTableView.contentInset;
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.collectionView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.collectionView.scrollIndicatorInsets = _collectionView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.tableView.scrollIndicatorInsets =_tableView.contentInset;
        self.groupTableView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.groupTableView.scrollIndicatorInsets =_groupTableView.contentInset;
        self.collectionView.contentInset = UIEdgeInsetsMake(kNavigationHeight, 0, kTabbarHeight, 0);
        self.collectionView.scrollIndicatorInsets = _collectionView.contentInset;
    }
//    self.automaticallyAdjustsScrollViewInsets = NO;

//    self.navBarTintColor  = kWhiteColor;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma TableView和CollectionView的代理方法
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - 刷新
- (void)headerRereshingWithScrollView:(UIScrollView *)scrollView headerRereshingBlock:(void (^)(void))headerRereshingBlock {
    if (scrollView) {
        scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            headerRereshingBlock();
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)scrollView.mj_header;
        header.stateLabel.alpha = header.arrowView.alpha = header.lastUpdatedTimeLabel.alpha = header.stateLabel.alpha = 0.6;
        header.lastUpdatedTimeLabel.hidden = YES;
    }
}

- (void)footerRereshingWithScrollView:(UIScrollView *)scrollView footerRereshingBlock:(void (^)(void))footerRereshingBlock {
    if (scrollView) {
        scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            footerRereshingBlock();
        }];
    }
}

/**
 *  是否显示返回按钮
 */
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        //self.navigationItem.leftBarButtonItems = [UIBarButtonItem itemWithTarget:self action:@selector(backBtnClicked) image:@"导航_返回" highImage:@"导航_返回" offset:-10];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kImageNamed(@"导航_返回") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];

    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)backBtnClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    // 是否支持旋转
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 默认进去类型
    return   UIInterfaceOrientationPortrait;
}

#pragma mark - 懒加载
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */

- (UITableView *)groupTableView {
    if (_groupTableView == nil) {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;

        _groupTableView.estimatedRowHeight = 0;
        _groupTableView.estimatedSectionHeaderHeight = 0;
        _groupTableView.estimatedSectionFooterHeight = 0;

        _groupTableView.backgroundColor=kTableViewGrounpBgColor;
        _groupTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        _groupTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];

    }
    return _groupTableView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        _tableView.backgroundColor=kTableViewGrounpBgColor;
        _tableView.tableFooterView = [UIView new]; // 这行代码可以隐藏掉tableView不满一屏时多余的分割线
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight) collectionViewLayout:flow];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor=kTableViewGrounpBgColor;
    }
    return _collectionView;
}
@end
