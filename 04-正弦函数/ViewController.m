//
//  ViewController.m
//  04-正弦函数
//
//  Created by 袁统 on 2016/11/7.
//  Copyright © 2016年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "SinView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize viewSize = self.view.frame.size;
    SinView *sinView = [[SinView alloc] initWithFrame:CGRectMake(0, 20, viewSize.width, viewSize.height - 20)];
    sinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sinView];
}
@end
