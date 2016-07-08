//
//  MyCouponVC.m
//  qch
//
//  Created by 青创汇 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyCouponVC.h"
#import "LBSegment.h"
#import "DeductionVC.h"
#import "SubstituteVC.h"

@interface MyCouponVC ()<UIScrollViewDelegate,SegmentDelegate>
{
    UIButton *Rulebtn;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LBSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;
@end

@implementation MyCouponVC

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refeleshView" object:nil];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的优惠券";
    
    self.view.backgroundColor = [UIColor themeGrayColor];
    
    [self creatheaderview];
    //加载Segment
    [self setSegment];
    
    //加载ViewController
    [self addChildViewController];
    
    //加载ScrollView
    [self setContentScrollView];
}

- (void)creatheaderview{
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*PMBWIDTH)];
    headerview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerview];
    
    Rulebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Rulebtn.frame = CGRectMake(ScreenWidth-75*PMBWIDTH, 15*PMBWIDTH, 70*PMBWIDTH, 20*PMBWIDTH);
    [Rulebtn setTitle:@"使用规则 >" forState:UIControlStateNormal];
    Rulebtn.titleLabel.font = Font(14);
    [Rulebtn setTitleColor:[UIColor themeBlueColor] forState:UIControlStateNormal];
    [Rulebtn addTarget:self action:@selector(ruleAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:Rulebtn];
    
}

-(void)setSegment {
    
    [self buttonList];
    //初始化
    LBSegment *segment = [[LBSegment alloc]initWithFrame:CGRectMake(0,50*PMBWIDTH+15*PMBWIDTH, self.view.frame.size.width, 40*PMBWIDTH)];
    segment.delegate = self;
    self.segment = segment;
    segment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 50*PMBWIDTH+55*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = TSEColor(228, 228, 228);
    [self.view addSubview:line];
    
}

//加载ScrollView
-(void)setContentScrollView {
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50*PMBWIDTH+56*PMBWIDTH, self.view.frame.size.width, ScreenHeight-56*PMBWIDTH-64-50*PMBWIDTH)];
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
        vc.view.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight-55*PMBWIDTH-64);
        [sv addSubview:vc.view];
        
    }
    
    sv.contentSize = CGSizeMake(2 * ScreenWidth, 0);
    self.contentScrollView = sv;
}

-(void)addChildViewController{
    DeductionVC *deduction = [[DeductionVC alloc]init];
    [self addChildViewController:deduction];
    SubstituteVC *substitute = [[SubstituteVC alloc]init];
    [self addChildViewController:substitute];
    
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

- (void)ruleAction:(UIButton *)sender
{
    QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
    qchWeb.theme = @"优惠券规则";
    qchWeb.type=2;
    qchWeb.url = [NSString stringWithFormat:@"%@couponUseRule.html",SHARE_HTML];
    [self.navigationController pushViewController:qchWeb animated:YES];
}



@end
