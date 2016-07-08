//
//  MyCollectVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyCollectVC.h"
#import "LGSegment.h"
#import "ProjectVC.h"
#import "ActivityVC.h"
#import "PartnerVC.h"
#import "InvestorsVC.h"


@interface MyCollectVC ()<UIScrollViewDelegate,SegmentDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;

@end

@implementation MyCollectVC


- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    //加载Segment
    [self setSegment];
    //加载ViewController
    [self addChildViewController];
    //加载ScrollView
    [self setContentScrollView];
    // Do any additional setup after loading the view.
}


-(void)setSegment {
    
    [self buttonList];
    //初始化
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40*PMBWIDTH)];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
}

//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40*PMBWIDTH, self.view.frame.size.width, ScreenHeight-40*PMBWIDTH-64)];
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
        vc.view.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight-40*PMBWIDTH-64);
        [sv addSubview:vc.view];
        
    }
    
    sv.contentSize = CGSizeMake(5 * ScreenWidth, 0);
    self.contentScrollView = sv;
}

//加载3个ViewController
-(void)addChildViewController{
    
    ProjectVC *project = [[ProjectVC alloc]init];
    [self addChildViewController:project];
    ActivityVC *activity = [[ActivityVC alloc]init];
    [self addChildViewController:activity];
    PartnerVC *partner = [[PartnerVC alloc]init];
    [self addChildViewController:partner];
    InvestorsVC *investor = [[InvestorsVC alloc]init];
    [self addChildViewController:investor];
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
    
}


@end
