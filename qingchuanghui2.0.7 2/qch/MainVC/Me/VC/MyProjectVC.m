//
//  MyProjectVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyProjectVC.h"
#import "ProjectSegment.h"
#import "MyProjectStatusVC.h"
#import "MyDeliverPVC.h"
#import "MyShowPVC.h"
#import "MyMovePVC.h"

@interface MyProjectVC ()<UIScrollViewDelegate,SegmentDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic, strong) NSMutableArray *buttonList;
@property (nonatomic, weak) ProjectSegment *segment;
@property(nonatomic, weak) CALayer *LGLayer;

@end

@implementation MyProjectVC

- (NSMutableArray *)buttonList{
    if (!_buttonList){
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的项目";

    //加载Segment
    [self setSegment];
    //加载ViewController
    [self addChildViewController];
    //加载ScrollView
    [self setContentScrollView];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)setSegment {
    
    [self buttonList];
    //初始化
    ProjectSegment *segment = [[ProjectSegment alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40)];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    
    self.LGLayer = segment.LGLayer;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, ScreenHeight-40-64)];
    [self.view addSubview:sv];
    sv.bounces = NO;
    sv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    sv.contentOffset = CGPointMake(0, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.scrollEnabled = YES;
    sv.userInteractionEnabled = YES;
    sv.delegate = self;
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight-40-64);
        [sv addSubview:vc.view];
        
    }
    
    sv.contentSize = CGSizeMake(4 * ScreenWidth, 0);
    self.contentScrollView = sv;
}


-(void)addChildViewController{
    
    MyProjectStatusVC *projectStatus=[[MyProjectStatusVC alloc]init];
    [self addChildViewController:projectStatus];
    
    MyDeliverPVC *deliver=[[MyDeliverPVC alloc]init];
    [self addChildViewController:deliver];
    
    MyShowPVC *showP=[[MyShowPVC alloc]init];
    [self addChildViewController:showP];
    
    MyMovePVC *moveP=[[MyMovePVC alloc]init];
    [self addChildViewController:moveP];
}

#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
    
}


@end
