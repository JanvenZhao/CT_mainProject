//
//  SubNavViewController.m
//  GitPodsTest
//
//  Created by Janven on 2018/9/11.
//  Copyright © 2018年 Janven. All rights reserved.
//

#import "SubNavViewController.h"
#import "TopLineViewController.h"
#import "KTNavScrollTool.h"

@interface SubNavViewController ()<UIScrollViewDelegate>
{
    
    float ScreenWidth;
    float ScreenHeight;
    
}
@property (nonatomic,weak) UIScrollView *titleScrollView;
@property (nonatomic,weak) UIScrollView *contentScrollView;


@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedButton;

@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) KTNavScrollTool *scrollowTool;

@end

@implementation SubNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"导航Demo";
    
    self.edgesForExtendedLayout = NO;
    
    ScreenWidth = self.view.bounds.size.width;
    ScreenHeight = self.view.bounds.size.height;
    
    UIScrollView *title_S = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    title_S.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:title_S];
    self.titleScrollView = title_S;
    
    UIScrollView *content_S = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-40)];
    [self.view addSubview:content_S];
    self.contentScrollView = content_S;
    
    // 1. 初始化标题滚动视图上的按钮
    [self initButtonsForButtonScrollView];
    
}

- (void) initButtonsForButtonScrollView {
    // 初始化子控制器
    [self initChildViewControllers];
    
    CGFloat buttonWidth = 80;
    CGFloat buttonHeight = 40;
    NSInteger childViewControllerCount = self.childViewControllers.count;
    for (NSInteger i = 0; i < childViewControllerCount; i++) {
        UIViewController *childViewController = self.childViewControllers[i];
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        CGFloat x = i * buttonWidth;
        titleButton.frame = CGRectMake(x, 0, buttonWidth, buttonHeight);
        [titleButton setTitle:childViewController.title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [titleButton addTarget:self action:@selector(titleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:titleButton];
        [self.buttons addObject:titleButton];
    }
    
    self.line.frame = CGRectMake(0, buttonHeight-3, buttonWidth, 3);
    [self.titleScrollView addSubview:self.line];

    self.titleScrollView.contentSize = CGSizeMake(buttonWidth * childViewControllerCount, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.bounces = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * childViewControllerCount, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    
    // 禁止额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化时默认选中第一个
    [self titleButtonOnClick:self.buttons[0]];
}


- (void)titleButtonOnClick:(UIButton *)button {
    // 1. 选中按钮
    [self selectingButton:button];
    
    // 2. 显示子视图
    [self addViewToContentScrollView:button];
}

- (void)selectingButton:(UIButton *)button {
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //注释掉的代码是 放大的...
//    [UIView animateWithDuration:0.25 animations:^{
//
//        _selectedButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
//
//        button.transform = CGAffineTransformMakeScale(1.3, 1.3); // 选中字体变大，按钮变大，字体也跟着变大
//
//    } completion:^(BOOL finished){
//
//        _selectedButton = button;
//
//    }];
    
    
    _selectedButton = button;

    
    
    // 选中按钮时要让选中的按钮居中
    
    CGFloat offsetX = button.frame.origin.x - ScreenWidth * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - ScreenWidth;
    
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)addViewToContentScrollView:(UIButton *)button {
    NSInteger i = button.tag;
    UIViewController *childViewController = self.childViewControllers[i];
    CGFloat x = i * ScreenWidth;
    
    // 防止添加多次
    if (childViewController.view.superview == nil) {
        childViewController.view.frame = CGRectMake(x, 0, ScreenWidth, ScreenHeight);
        [self.contentScrollView addSubview:childViewController.view];
    }
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetRate = offsetX/scrollView.bounds.size.width;
    
    
    //将偏移率传递给KTNavScrollTool执行动画
    [self.scrollowTool configLingWithOffsetRate:offsetRate];
    
}

// 滚动结束时，将对应的视图控制器的视图添加到内容滚动视图中
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = self.contentScrollView.contentOffset.x / ScreenWidth;
    [self addViewToContentScrollView:_buttons[i]];
    
    // 内容滚动视图结束后选中对应的标题按钮
    [self selectingButton:_buttons[i]];
}

- (void)initChildViewControllers {
    // 0.头条
    TopLineViewController * topViewController = [[TopLineViewController alloc] init];
    topViewController.title = @"头条";
    topViewController.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:topViewController];
    
    // 1.科技
    TopLineViewController * technologyViewController = [[TopLineViewController alloc] init];
    technologyViewController.title = @"科技";
    technologyViewController.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:technologyViewController];
    
    // 2.汽车
    TopLineViewController * carViewController = [[TopLineViewController alloc] init];
    carViewController.title = @"汽车";
    carViewController.view.backgroundColor = [UIColor blueColor];

    [self addChildViewController:carViewController];
    
    // 3.体育
    TopLineViewController * sportsViewController = [[TopLineViewController alloc] init];
    sportsViewController.title = @"体育";
    sportsViewController.view.backgroundColor = [UIColor orangeColor];

    [self addChildViewController:sportsViewController];
    
    // 4.视频
    TopLineViewController * videoViewController = [[TopLineViewController alloc] init];
    videoViewController.title = @"视频";
    videoViewController.view.backgroundColor = [UIColor redColor];

    [self addChildViewController:videoViewController];
    
    // 5.图片
    TopLineViewController * imageViewController = [[TopLineViewController alloc] init];
    imageViewController.title = @"图片";
    imageViewController.view.backgroundColor = [UIColor yellowColor];

    [self addChildViewController:imageViewController];
    
    // 6.热点
    TopLineViewController * hotViewController = [[TopLineViewController alloc] init];
    hotViewController.title = @"热点";
    hotViewController.view.backgroundColor = [UIColor blackColor];

    [self addChildViewController:hotViewController];
}

#pragma mark - Setter Getter

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor greenColor];
    }
    return _line;
}

- (KTNavScrollTool *)scrollowTool {
    if (!_scrollowTool) {
        _scrollowTool = [[KTNavScrollTool alloc]initWithTitleArr:self.buttons line:self.line];
    }
    return _scrollowTool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
