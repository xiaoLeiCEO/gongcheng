//
//  ViewController.m
//  侧滑到指定控制器
//
//  Created by 王长磊 on 2017/7/29.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FirstViewController *firstVC = [[FirstViewController alloc]init];
    [self.navigationController pushViewController:firstVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
