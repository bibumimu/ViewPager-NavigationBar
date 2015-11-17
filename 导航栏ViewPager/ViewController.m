//
//  ViewController.m
//  导航栏ViewPager
//
//  Created by stefan on 15/11/17.
//  Copyright © 2015年 zy. All rights reserved.
//

#import "ViewController.h"
#import "HMSegmentedControl.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self initSegement];
    [self initScrollView];
    [self setupScrollView];
}

#pragma -mark 初始化segment
- (void)initSegement
{
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"实名动态",@"匿名八卦",@"商家"]];
    self.segment.frame = CGRectMake(0, 0, 280, 40);
    //未选中的字体颜色
    self.segment.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    //选中的字体颜色
    self.segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    self.segment.selectionIndicatorColor = [UIColor redColor];    //指示器线条颜色
    self.segment.selectedSegmentIndex = 0;   //默认选中第一个
    self.navigationItem.titleView =  self.segment;
}

#pragma -mark 初始化ScrollView
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 3, 1);  //这里不能设置为0
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, viewHeight) animated:NO];
    [self.view addSubview:self.scrollView];
    
  
}

#pragma -mark 添加视图到scrollView,并实现点击标签切换视图
- (void)setupScrollView
{
    //添加视图控制器到scrollView
    OneViewController *one = [[OneViewController alloc] init];
    TwoViewController *two = [[TwoViewController alloc] init];
    ThreeViewController *three = [[ThreeViewController alloc] init];
    NSArray *arrView = @[one,two,three];
    for (int i = 0; i<arrView.count; i++) {
        UIViewController *temp = arrView[i];
        temp.view.frame = CGRectMake(i *viewWidth, 0, viewWidth, viewHeight);
        [self.scrollView addSubview:temp.view];
    }
    //点击标签切换视图
    __weak typeof(self) weakSelf = self;
    [self.segment setIndexChangeBlock:^(NSInteger index) {
        CGFloat width =  weakSelf.view.frame.size.width;  //因为block中使用宏变量会造成循环引用
        CGFloat height = weakSelf.view.frame.size.height;
        [weakSelf.scrollView scrollRectToVisible:CGRectMake( width* index, 0, width, height) animated:YES];
    }];
}

#pragma mark -实现滑动视图,切换标题
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segment setSelectedSegmentIndex:page animated:YES];
}

@end
