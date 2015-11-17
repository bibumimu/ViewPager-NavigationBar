//
//  testViewController.m
//  HMSegmentedControlExample
//
//  Created by stefan on 15/11/17.
//  Copyright © 2015年 Hesham Abd-Elmegid. All rights reserved.
//

#import "testViewController.h"

#import "HMSegmentedControl.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

@interface testViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segment;
@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
     //初始化segment
     self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"实名动态",@"匿名八卦",@"商家"]];
     self.segment.frame = CGRectMake(0, 0, 280, 40);
     self.segment.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
     self.segment.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};

     self.navigationItem.titleView =  self.segment;
     self.segment.selectedSegmentIndex = 0;
    

    //初始化ScrollView
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 3, 1);  //这里不能设置为0
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, viewHeight) animated:NO];
    [self.view addSubview:self.scrollView];
    
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
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, viewHeight) animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segment setSelectedSegmentIndex:page animated:YES];
}



@end
