//
//  ViewController.m
//  PageView
//
//  Created by yangjw on 2018/3/13.
//  Copyright © 2018年 yangjw. All rights reserved.
//

#import "ViewController.h"
#import "YGPageViewController.h"
#import "TestViewController.h"
#import "UIColor+YGW.h"

#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height
#define kNavigationBarH self.navigationController.navigationBar.frame.size.height
/*  状态栏高度  */
#define kStatusBarH ([[UIApplication sharedApplication]statusBarFrame].size.height)
@interface ViewController ()<YGPageViewDataSource,YGPageViewDelegate>

- (IBAction)actionjump:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionjump:(id)sender
{
    YGPageViewController *pageViewController = [[YGPageViewController alloc] init];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    pageViewController.lazyloading = YES;
    [self.navigationController pushViewController:pageViewController animated:YES];
}

- (NSArray *)viewControllersAtTitles
{
    return @[@"全部",@"设计",@"议价"];
}

- (CGFloat)viewControllerAtViewHeight
{
    return kScreenH - kNavigationBarH - kStatusBarH - 44 - 34;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    TestViewController *vc = [[TestViewController alloc] init];
    vc.view.backgroundColor = [UIColor randomColor];
    return vc;
}

@end
