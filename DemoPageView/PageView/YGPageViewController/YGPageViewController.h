//
//  YGPageViewController.h
//  PageView
//
//  Created by yangjw on 2018/3/13.
//  Copyright © 2018年 yangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
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
 */

@class YGPageViewController;
@protocol YGPageViewDelegate <NSObject>
@optional
- (void)viewController:(YGPageViewController *)viewController didSelectRow:(NSInteger)row;
@end

@protocol YGPageViewDataSource <NSObject>

- (NSArray *)viewControllersAtTitles;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

- (CGFloat)viewControllerAtViewHeight;

@end

@interface YGPageViewController : UIViewController

@property (nonatomic,strong) id<YGPageViewDelegate> delegate;
@property (nonatomic,assign) id<YGPageViewDataSource> dataSource;
/* 默认颜色  */
@property (nonatomic,strong) UIColor *normalColor;
/* 选中颜色  */
@property (nonatomic,strong) UIColor *selecteColor;
/* 分割线颜色  */
@property (nonatomic,strong) UIColor *splitColor;
/* 当前页  */
@property (nonatomic,assign) NSInteger currentPage;
/* 是否冷加载  */
@property (nonatomic,assign) BOOL lazyloading;
/* 是否需要切换动画  */
@property (nonatomic,assign) BOOL isAnimation;
/* 游标字  */
@property (nonatomic,strong) UIFont *titleFont;
/* 分割线高度  */
@property (nonatomic,assign) CGFloat lineH;
@property (nonatomic,assign) CGFloat progressH;
@property (nonatomic,assign) CGFloat progressW;
/* 菜单高度  */
@property (nonatomic,assign) CGFloat menuH;
@property (nonatomic,assign) CGFloat menuTitleH;
@end
