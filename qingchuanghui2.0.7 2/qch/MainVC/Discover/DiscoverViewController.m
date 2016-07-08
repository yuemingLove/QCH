//
//  DiscoverViewController.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "DiscoverViewController.h"
#import "PoineerConsultVC.h"
#import "ActivityListViewController.h"
#import "ProjectViewController.h"
#import "PartnViewController.h"
#import "RoomViewController.h"
#import "PrivateVC.h"
#import "InvestmentVC.h"
#import "CollegeVC.h"
@interface DiscoverViewController (){

    NSMutableArray *Title;
    NSMutableArray *Pic;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View
@property (strong, nonatomic) NSArray *adsArray;

@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"发现"];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self createTableView];
    [self createItemView];
    
    [self loadData];
    
    if (!Pic) {
        Pic = [[NSMutableArray alloc]init];
    }
    if (!Title) {
        Title = [[NSMutableArray alloc]init];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self getdata];
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
    self.navigationController.navigationBarHidden=NO;
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)createTableView{

    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView=scrollView;
    
    [self.view addSubview:scrollView];
    
    //广告：定时器广告图片切换
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300*SCREEN_WSCALE)];
    _headerView.backgroundColor=[UIColor whiteColor];
    {
        __weak DiscoverViewController *weakSelf=self;
        self.adsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0*SCREEN_WSCALE ) animationDuration:3];
        
        [_adsView setFetchContentViewAtIndex:^UIView *(NSInteger pageIndex){
            if (pageIndex < [weakSelf.adsArray count]) {

                NSDictionary *model = [weakSelf.adsArray objectAtIndex:pageIndex];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  200.0 * SCREEN_WSCALE)];
                NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[model objectForKey:@"t_Ad_Pic"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
                
                return imageView;
                
            }
            return [[UIView alloc] initWithFrame:CGRectZero];
        }];
        
        [_adsView setTapActionBlock:^(NSInteger pageIndex){
            if (pageIndex <[weakSelf.adsArray count]) {
                
                NSDictionary *dict=weakSelf.adsArray[pageIndex];
                
                QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
                qchWeb.theme=[NSString stringWithFormat:@"%@详情",[dict objectForKey:@"t_Ad_Title"]];
                qchWeb.type=2;
                qchWeb.url=[NSString stringWithFormat:@"%@AdView.html?Guid=%@",SERIVE_HTML,[dict objectForKey:@"Guid"]];
                qchWeb.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:qchWeb animated:NO];
            }
        }];
        [_headerView addSubview:_adsView];
        
    }
    //服务菜单
{
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, _adsView.frame.size.height, SCREEN_WIDTH, 100.0*SCREEN_WSCALE)];

        NSArray *menuArray=@[@"活动",@"项目",@"投资人",@"创客空间"];

        CGFloat width=(self.menuView.frame.size.width-30*SCREEN_WSCALE)/4.0;
        for (int i=0; i<[menuArray count]; i++) {

            NSString *name=[menuArray objectAtIndex:i];

            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];

            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);

            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dis_1%d",i]] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(productListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

            [btnView addSubview:button];

            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+5, btnView.width, 16*SCREEN_WSCALE)];

            nameLabel.text=name;
            nameLabel.font=Font(15);
            nameLabel.textColor=[UIColor blackColor];
            nameLabel.textAlignment=NSTextAlignmentCenter;
            [btnView addSubview:nameLabel];

            [self.menuView addSubview:btnView];
        }
        [_headerView addSubview:_menuView];
        
    
    }
    
    [scrollView addSubview:_headerView];

}

- (void)creatheaderview
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, _adsView.frame.size.height, SCREEN_WIDTH, 100.0*SCREEN_WSCALE)];
    NSArray *array = [Pic mutableCopy];
    
    CGFloat width=(self.menuView.frame.size.width-30*SCREEN_WSCALE)/[array count];
    
    for (int i=0; i<[array count]; i++) {
        
        NSString*pic = [array objectAtIndex:i];
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
        NSString *url = [NSString stringWithFormat:@"%@%@",SERIVE_Discovery,pic];
        [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(productListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
        [self.menuView addSubview:btnView];
    }
    
    [_headerView addSubview:_menuView];

}

-(void)createItemView{
    
    self.footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _headerView.bottom+10, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    [self.footerView setBackgroundColor:[UIColor whiteColor]];
    //每天签到//@"备忘录"
    NSArray *cateArray = @[@"创业资讯",@"投资机构",@"双创学院",@"私人订制"];
    
    CGFloat width=SCREEN_WIDTH/2.0;
    for (int i=0; i<[cateArray count]; i++) {
        NSString *name=[cateArray objectAtIndex:i];
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake((i % 2) * width, (i / 2) * 80*SCREEN_WSCALE , width, 80*SCREEN_WSCALE)];
        [self.footerView addSubview:btnView];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btnView.frame;
        
        button.tag = i;
        [button addTarget:self action:@selector(communityClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(width-55*SCREEN_WSCALE, 17*SCREEN_WSCALE, 45*SCREEN_WSCALE, 45*SCREEN_WSCALE)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"item_10%d",i+1]]];
        [btnView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, imageView.top, width-55*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
        nameLabel.text=name;
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        [btnView addSubview:nameLabel];
        
        NSString *message;
        if (i==0) {
            message=@"政策市场一网打尽";
        }else if (i==1){
            message=@"千家机构虚位以待";
        }else if (i==2){
            message=@"百位导师倾囊相授";
        }else if (i==3){
            message=@"一站式创业管家";
        }
        
        UILabel *contentLabel=[self createLabelFrame:CGRectMake(nameLabel.left, nameLabel.bottom+10, nameLabel.width, 14*SCREEN_WSCALE) color:[UIColor grayColor] font:Font(13) text:message];
        [btnView addSubview:contentLabel];
    }
    
    for (int i = 1; i < [cateArray count] / 2; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 80 * SCREEN_WSCALE, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor themeGrayColor];
        [self.footerView addSubview:lineView];
    }
    for (int i = 1; i < 2; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, 1, 160 * SCREEN_WSCALE)];
        lineView.backgroundColor = [UIColor themeGrayColor];
        [self.footerView addSubview:lineView];
    }
    
    [self.scrollView addSubview:self.footerView];
    
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 550*SCREEN_WSCALE);
}

-(void)loadData{
    
    [HttpDiscoverAction GetData:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        NSArray *array=[NSArray new];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            array =[dict objectForKey:@"result"];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            array=[NSArray new];
        
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"数据问题，请重新请求" maskType:SVProgressHUDMaskTypeBlack];
        }
        self.adsArray=array;
        [_adsView setTotalPagesCount:^NSInteger{
            return [array count];
        }];
    }];
}

- (void)getdata{
    [HttpDiscoverAction Discovery:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {

        }
    }];
}

-(void)communityClicked:(UIButton*)sender{

    NSInteger index=[sender tag];
    if (index==0) {
        PoineerConsultVC *pointConsult=[[PoineerConsultVC alloc]init];
        pointConsult.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pointConsult animated:NO];
    }else if (index==1){
        InvestmentVC *invest = [[InvestmentVC alloc]init];
        invest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:invest animated:NO];
    }else if (index==2){
        CollegeVC *college = [[CollegeVC alloc]init];
        college.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:college animated:YES];
    }else if (index==3){
        PrivateVC *private=[[PrivateVC alloc]init];
        private.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:private animated:NO];
    }
}


-(IBAction)productListButtonClicked:(id)sender{
    
    UIButton *button=(UIButton*)sender;
    button.highlighted=NO;
    NSInteger listed=button.tag;
    
    if (listed==0) {
        ActivityListViewController *activityList=[[ActivityListViewController alloc]init];
        activityList.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:activityList animated:NO];
    }else if (listed==1) {
        ProjectViewController *projectVC=[[ProjectViewController alloc]init];
        projectVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:projectVC animated:NO];
    }else if (listed==2) {
        PartnViewController *partnVC=[[PartnViewController alloc]init];
        partnVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:partnVC animated:NO];
    }else if (listed==3) {
        RoomViewController *roomVC=[[RoomViewController alloc]init];
        roomVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:roomVC animated:NO];
    }
}

@end
