//
//  ViewController.m
//  CT_mainProject
//
//  Created by Janven on 17/7/10.
//  Copyright © 2017年 Janven. All rights reserved.
//

#import "ViewController.h"
#import <CTMediator+A.h>
#import <CTMediator+B.h>

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
    
    
    UIButton *btn_b = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_b setFrame:CGRectMake(100, 200, 200, 60)];
    [btn_b addTarget: self action:@selector(pushB) forControlEvents:UIControlEventTouchUpInside];
    [btn_b setTitle:@"点击跳转B业务线" forState:UIControlStateNormal];
    [btn_b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:btn_b];
    
}

-(void)push{

    UIViewController *a = [[CTMediator sharedInstance] A_aViewController];
    [self.navigationController pushViewController:a animated:YES];
}

-(void)pushB{

    UIViewController *a = [[CTMediator sharedInstance] B_ViewController];
    [self.navigationController pushViewController:a animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
