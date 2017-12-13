//
//  ViewController.m
//  ASignARDemo
//
//  Created by chenxi on 2017/12/8.
//  Copyright © 2017年 chenxi. All rights reserved.
//

#import "ViewController.h"
#import "ARSCNViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 100, 100, 100);
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(presentAR) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
}

- (void)presentAR{
    ARSCNViewController *arView = [[ARSCNViewController alloc]init];
    [self presentViewController:arView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
