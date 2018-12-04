//
//  ViewController.m
//  photo
//
//  Created by Stephen Hu on 2018/12/3.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "FFPhotoPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)go2Photo:(UIButton *)sender {
    FFPhotoPickerViewController *photoVc = [FFPhotoPickerViewController new];
    [self presentViewController:photoVc animated:YES completion:nil];
}

@end
