//
//  ViewController.m
//  photo
//
//  Created by Stephen Hu on 2018/12/3.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "FFPhotoPickerViewController.h"
#import "QZSectorProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QZSectorProgressView *proView = [[QZSectorProgressView alloc] init];//WithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:proView];
    [proView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(100);
        make.width.height.mas_equalTo(50);
    }];
    proView.progress = 0.4;
    
}

- (IBAction)go2Photo:(UIButton *)sender {
    FFPhotoPickerViewController *photoVc = [FFPhotoPickerViewController new];
    [self presentViewController:photoVc animated:YES completion:nil];
}

@end
