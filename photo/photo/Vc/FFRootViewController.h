//
//  FFRootViewController.h
//
//  Created by Stephen Hu on 2018/7/13.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EmptyDataSetDidTapButtonBlock)(UIScrollView *scrollView,UIButton *button);

/**
 VC 基类
 */
@interface FFRootViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

// 刷新
-(void)headerRereshingWithScrollView:(UIScrollView *)scrollView headerRereshingBlock:(void (^)(void))headerRereshingBlock;
-(void)footerRereshingWithScrollView:(UIScrollView *)scrollView footerRereshingBlock:(void (^)(void))footerRereshingBlock;


/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;


@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView *groupTableView;
@property (nonatomic, strong) UICollectionView * collectionView;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;





@end


