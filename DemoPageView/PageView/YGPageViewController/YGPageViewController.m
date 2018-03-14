//
//  YGPageViewController.m
//  PageView
//
//  Created by yangjw on 2018/3/13.
//  Copyright © 2018年 yangjw. All rights reserved.
//

#import "YGPageViewController.h"
#import "UIColor+YGW.h"

//屏幕宽高
#define kPageScreenW [[UIScreen mainScreen] bounds].size.width
#define kPageScreenH [[UIScreen mainScreen] bounds].size.height
@interface YGPageViewController ()<UIScrollViewDelegate>
/*  菜单栏  */
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableArray *vcs;
@property (nonatomic, strong) NSArray   *titles;
/** 游标view  */
@property (nonatomic, strong) UIView *progressView;
/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttons;
@property(nonatomic,strong)NSArray   *phaseS;
@property (nonatomic,assign) CGFloat viewHeight;
@end

@implementation YGPageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalColor = [UIColor colorWithHex:@"#989898"];
        self.selecteColor = [UIColor colorWithHex:@"#ff9e2e"];
        self.splitColor = [UIColor colorWithHex:@"#D9D9D9"];
        self.currentPage = 0;
        self.titleFont  = [UIFont systemFontOfSize:14];
        self.lineH = 0.5;
        self.progressH = 2.5;
        self.progressW = 50;
        self.menuH = 44;
        self.menuTitleH = 30;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self initSource];
    [self initView];
    [self setUpVc:self.currentPage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSource
{
    NSAssert([_dataSource respondsToSelector:@selector(viewControllersAtTitles)], @"请实现viewControllersAtTitles代理方法");
    if (_dataSource && [_dataSource respondsToSelector:@selector(viewControllersAtTitles)])
    {
        self.titles = [NSArray arrayWithArray:[_dataSource viewControllersAtTitles]];
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(viewControllerAtViewHeight)])
    {
        self.viewHeight = [_dataSource viewControllerAtViewHeight];
    }
}

- (void)initView
{
    /** 菜单  */
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kPageScreenW, self.menuH)];
    self.menuView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.menuH - self.lineH, kPageScreenW, self.lineH)];
    lineView.backgroundColor = self.splitColor;
    [self.menuView addSubview:lineView];
    [self.view addSubview:self.menuView];
    /** 菜单  */
    [self initMenuView];
    
    /** 主页面  */
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame), kPageScreenW, self.viewHeight)];
    self.contentView.delegate = self;
    [self.contentView setShowsVerticalScrollIndicator:NO];
    [self.contentView setShowsHorizontalScrollIndicator:NO];
    self.contentView.bounces = NO;
    self.contentView.pagingEnabled = YES;
    [self.view addSubview:self.contentView];
    [self.contentView setContentSize:CGSizeMake(kPageScreenW * self.titles.count, CGRectGetHeight(self.contentView.frame))];
    /** 控制器  */
    [self addChildController];
}

/** 初始化menuView  */
- (void)initMenuView
{
    NSInteger count = self.titles.count;
    CGFloat btnW = kPageScreenW/count;
    
    CGFloat originX = (btnW - self.progressW);
    
    for (int i =  0; i< count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnW * i,(self.menuH - self.menuTitleH)/2, btnW, self.menuTitleH);
        button.titleLabel.font = self.titleFont;
        [button setTitle:[NSString stringWithFormat:@"%@",[self.titles objectAtIndex:i]] forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selecteColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(setupButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        
        [self.menuView addSubview:button];
    }
    /** 游标  */
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(originX/2,self.menuH - self.progressH, self.progressW, self.progressH)];
    self.progressView.backgroundColor = self.selecteColor;
    [self.menuView addSubview:self.progressView];
}
/** 添加控制器  */
- (void)addChildController
{
    /** 移除所有控制器  */
    [self.vcs removeAllObjects];
    /* 创建子控制器 */
    for (UIViewController *controller in self.childViewControllers) {
        [controller removeFromParentViewController];
    }
    NSAssert([_dataSource respondsToSelector:@selector(viewControllerAtIndex:)], @"请实现viewControllerAtIndex代理方法");
    for (NSInteger i = 0; i < self.titles.count; i++)
    {
        if (_dataSource && [_dataSource respondsToSelector:@selector(viewControllerAtIndex:)])
        {
            UIViewController *viewController = [_dataSource viewControllerAtIndex:i];
            viewController.view.frame =  CGRectMake(i * kPageScreenW, 0, kPageScreenW, self.viewHeight);
            [self addChildViewController:viewController];
            [viewController didMoveToParentViewController:self];
            if (!_lazyloading)
            {
                [self.contentView addSubview:viewController.view];
            }
            [self.vcs addObject:viewController];
        }
    }
}
/**
 设置展示的View
 
 @param index index
 */
- (void)setUpVc:(NSInteger)index
{
    for (UIButton *btn in self.buttons)
    {
        if (btn.tag == index) {
            [btn setSelected:YES];
            [self setupButtonStatus:btn];
        }else
        {
            [btn setSelected:NO];
        }
    }
}


- (void)setupButtonStatus:(UIButton *)sender
{
    for (UIButton *btn in self.buttons)
    {
        if (btn == sender) {
            [btn setSelected:YES];
        }else
        {
            [btn setSelected:NO];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didSelectRow:)])
    {
        [_delegate viewController:self didSelectRow:sender.tag];
    }
    
    NSInteger count = self.titles.count;
    CGFloat btnW = kPageScreenW/count;
    /** 下标移动动画 */
    [UIView animateWithDuration:0.25 animations:^{
        CGRect pageIndicatorFrame = self.progressView.frame;
        pageIndicatorFrame.origin.x = btnW*sender.tag + (btnW - self.progressW)/2;
        self.progressView.frame = pageIndicatorFrame;
    }];
    if (_lazyloading)
    {
        CGFloat height = CGRectGetHeight(self.contentView.frame);
        /** 获得当前控制器 */
        UIViewController *controller = [self.vcs objectAtIndex:sender.tag];
        controller.view.frame =  CGRectMake(sender.tag * kPageScreenW, 0, kPageScreenW, height);
        [self.contentView addSubview:controller.view];
    }
    [self.contentView setContentOffset:CGPointMake(kPageScreenW* sender.tag, 0) animated:_isAnimation];
}

#pragma mark - Protocol conformance

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = offsetX / scrollView.contentSize.width;
    [UIView animateWithDuration:0.15 animations:^{
        self.progressView.frame = CGRectMake(kPageScreenW * progress + (kPageScreenW/self.titles.count - self.progressW)/2, self.menuH - self.progressH, self.progressW, self.progressH);
    }];
}


/**
 手动滑动停止
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/kPageScreenW;
    [self setUpVc:index];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSMutableArray *)vcs
{
    if (!_vcs) {
        _vcs = [[NSMutableArray alloc] init];
    }
    return _vcs;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (void)dealloc
{
    NSLog(@"内存释放了");
}

@end

