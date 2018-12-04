//
//  FFTestViewController.m
//
//  Created by Stephen Hu on 2018/9/19.
//  Copyright © 2018年 iDress. All rights reserved.
//

#import "FFTestViewController.h"
#import <Masonry.h>

@interface FFTestViewController ()
@property (nonatomic, weak) UIImageView *imgv;
@end

@implementation FFTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [[UIImageView alloc] init];
    img.contentMode = UIViewContentModeScaleToFill;
    self.imgv = img;
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        [make center];
        make.width.height.mas_equalTo(200);
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.imgv setImage:self.img];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
