//
//  ViewController.m
//  CT_mainProject
//
//  Created by Janven on 17/7/10.
//  Copyright © 2017年 Janven. All rights reserved.
//

#import "ViewController.h"
#import <CTMediator+A.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 100, 200, 60)];
    [btn addTarget: self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击跳转A业务线" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}

-(void)push{

    UIViewController *a = [[CTMediator sharedInstance] A_aViewController];
    [self.navigationController pushViewController:a animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
