//
//  ProjectDetailVC.m
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectDetailVC.h"
#import "ProjectDetailCell.h"
#import "ProjectStatusCell.h"
#import "ProjectDetCell.h"
#import "PartnerneedsCell.h"
#import "ScrollViewCell.h"
#import "TeacherCell.h"
#import "ScanLineCell.h"
#import "ThemeCell.h"
#import "MoreBtnCell.h"
#import "TalkViewCell.h"
#import "NoMsgCell.h"
#import "UINavigationBar+Background.h"

@interface ProjectDetailVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ProjectStatusCellDelegate,CommitAlertViewDelegate,MoreBtnCellDelegate,TalkViewCellDelegate,ScanLineCellDelegate,XHImageViewerDelegate,UIActionSheetDelegate,ScrollViewCellDeleagte>{

    UIImageView *bgkImageView;
    
    TextEntity *entity;
    UIImageView *pIamgeView;
    UILabel *pName;
    UILabel *oneDetail;
    
    UIButton *careBtn;
    
    //评论人Guid；
    NSString *touserguid;
    
    NSInteger ifPraise;
    
    //是否是投资人
    NSString *Investors;
    
    NSMutableArray *SourceArray;

    
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *funlist;


@property(weak,nonatomic)UILabel *titleLabel;


/**
 *背景图片bgView
 */
@property (nonatomic,weak) UIView* bgView;

@end

@implementation ProjectDetailVC

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //禁用
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self GetIsInvestor];
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"backToSmall" object:nil];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationCapturesStatusBarAppearance=YES;
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    if (!SourceArray) {
        SourceArray = [[NSMutableArray alloc]init];
    }
    
    touserguid = @"";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    //share
    UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareViewBtn:)];
    self.navigationItem.rightBarButtonItem=shareView;
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
    
    [self createTableView];
    if ([[_projectDict objectForKey:@"t_User_Guid"]isEqualToString:UserDefaultEntity.uuid]) {
        return;
    } else {
        [self createFooterBtnView];
    }
    [self gettalk];
    if (_type==1) {
        [self updateFrame];
    } else {
        [self getDetailView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle:) name:@"quxiao" object:nil];
}
- (void)backAction {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar cnReset];
    // 如果前个页面也有导航栏渐变, 执行此block, 更改导航栏透明
    if (self.updateNav) {
        self.updateNav();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    
    if (self.tableView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    if (self.tableView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar cnReset];
    }
}
-(void)createTableView{

    if ([[_projectDict objectForKey:@"t_User_Guid"]isEqualToString:UserDefaultEntity.uuid]) {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor themeGrayColor]];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView=tableView;
        [self.view addSubview:tableView];
    } else {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor themeGrayColor]];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView=tableView;
        [self.view addSubview:tableView];
    }

    [self createHeadView];

    
}

-(void)getDetailView{
    
    [HttpProjectAction GetProjectView:_guId userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"guid"] omplete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSDictionary *param=[dict objectForKey:@"result"][0];

            NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[param objectForKey:@"t_Project_ConverPic"]];
            [pIamgeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            pName.text=[param objectForKey:@"t_Project_Name"];
            oneDetail.text=[param objectForKey:@"t_Project_OneWord"];
            _projectDict=param;
            
        }
        [self.tableView reloadData];
    }];
    
    [HttpProjectAction GetProjectTeam:_guId Token:[MyAes aesSecretWith:@"projectGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];;
        }else{
            _funlist=[[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
    
    [self gettalk];
}

-(void)updateFrame{
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_projectDict objectForKey:@"t_Project_ConverPic"]];
    [pIamgeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    pName.text=[_projectDict objectForKey:@"t_Project_Name"];
    oneDetail.text=[_projectDict objectForKey:@"t_Project_OneWord"];
    
    [HttpProjectAction GetProjectTeam:_guId Token:[MyAes aesSecretWith:@"projectGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];;
        }else{
            _funlist=[[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
}

-(void)createFooterBtnView{
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, 49)];
    footerView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footerView];
    
    CGFloat width=(SCREEN_WIDTH-2)/3;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(width, 8, 1, 33)];
    line.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:line];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(width*2+1, 8, 1, 33)];
    line2.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:line2];
    
    UIButton *talkBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, width, 30)];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn setTitle:@"私信" forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"sixin"] forState:UIControlStateNormal];
    talkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    talkBtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    
    [talkBtn addTarget:self action:@selector(myTalk:) forControlEvents:UIControlEventTouchUpInside];

    [footerView addSubview:talkBtn];
    
    careBtn=[[UIButton alloc]initWithFrame:CGRectMake(width+1, talkBtn.top, width, 30)];
    [careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ifPraise=[(NSNumber*)[_projectDict objectForKey:@"ifPraise"]integerValue];
    if (ifPraise==1) {
        [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    } else {
        [careBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    [careBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    careBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    careBtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    
    [careBtn addTarget:self action:@selector(myCare:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:careBtn];
    
    UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame=CGRectMake((width+1)*2, talkBtn.top, width, 30);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"yuetan"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentMsg:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commentBtn];
}

-(void)createHeadView{
    
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    UIImage *image = [UIImage imageNamed:@"beijingtu_img.png"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    /**
     *创建用户空间背景图片
     */
    UIImageView* BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT)];
    BgImage.image=blurredImage;
    bgkImageView=BgImage;
    [self.tableView addSubview:BgImage];
    
    /**
     *创建用户空间背景图片的容器View
     */
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.frame=CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT);
    self.bgView=bgView;
    [self.tableView addSubview:bgView];
    
    
    pIamgeView =[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60*SCREEN_WSCALE)/2, 84, 60*SCREEN_WSCALE, 60*SCREEN_WSCALE)];
    pIamgeView.layer.masksToBounds=YES;
    pIamgeView.layer.cornerRadius=pIamgeView.height/2;
    [pIamgeView setImage:[UIImage imageNamed:@"loading_1"]];
    [bgView addSubview:pIamgeView];
    
    pName=[self createLabelFrame:CGRectMake(50*SCREEN_WSCALE, pIamgeView.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH-100*SCREEN_WSCALE, 20*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(14) text:@""];
    pName.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:pName];
    
    oneDetail=[self createLabelFrame:CGRectMake(20*SCREEN_WSCALE, pName.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-40*SCREEN_WSCALE, 20*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(14) text:@""];
    oneDetail.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:oneDetail];
    
}

-(void)commentMsg:(UIButton*)sender{

    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"项目评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];

}

-(void)CommentList:(MoreBtnCell*)cell{
    CommentListVC *commentList=[[CommentListVC alloc]init];
    commentList.Guid=_guId;
    [self.navigationController pushViewController:commentList animated:YES];
}

-(void)updateTextViewData:(NSString *)text{
    
    if ([self isBlankString:text]) {
        
        [SVProgressHUD showErrorWithStatus:@"评论内容不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
   
    NSMutableDictionary *commit = [[NSMutableDictionary alloc]init];
    [commit setObject:UserDefaultEntity.uuid forKey:@"fromUserGuid"];
    [commit setObject:text forKey:@"fromContent"];
    [commit setObject:_guId forKey:@"associateGuid"];
    [commit setObject:[MyAes aesSecretWith:@"fromUserGuid"] forKey:@"Token"];
    [commit setObject:@"project" forKey:@"type"];
    if ([self isBlankString:touserguid]) {
        [commit setObject:@"" forKey:@"toUserGuid"];
    }else{
        [commit setObject:touserguid forKey:@"toUserGuid"];
    }
    [HttpDynamicAction commonAddTalk:commit complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]){
            touserguid=@"";
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [SourceArray removeAllObjects];
            [self gettalk];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

//获取评论
- (void)gettalk{
    
    NSMutableDictionary *talkdic = [[NSMutableDictionary alloc]init];
    [talkdic setObject:_guId forKey:@"associateGuid"];
    [talkdic setObject:@"1" forKey:@"page"];
    [talkdic setObject:@"50" forKey:@"pagesize"];
    [talkdic setObject:[MyAes aesSecretWith:@"associateGuid"] forKey:@"Token"];
    [HttpDynamicAction dynamictalk:talkdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:result];
            SourceArray = [rdtc.result mutableCopy];
        }else{
            SourceArray = [[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
}

- (void)deletetalkClick:(TalkViewCell *)cell index:(NSInteger)index{
    
    DynamicTalkModel *model = [SourceArray objectAtIndex:index];
    NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
    [deletedic setObject:model.guid forKey:@"talkGuid"];
    [deletedic setObject:[MyAes aesSecretWith:@"talkGuid"] forKey:@"Token"];
    [HttpDynamicAction talkdelete:deletedic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            
            [self gettalk];
        }
    }];
}

- (void)GetIsInvestor{
    [HttpProjectAction GetIsInvestor:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            Investors = [dict objectForKey:@"result"];
        }
    }];
}

-(void)shareViewBtn:(id)sender{
    if ([[_projectDict objectForKey:@"t_Project_Audit"]isEqualToString:@"0"]) {
          [SVProgressHUD showErrorWithStatus:@"该项目正在审核，暂时不能分享" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_projectDict objectForKey:@"t_Project_ConverPic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareProject.html?Guid=%@&UserGuid=%@",SHARE_HTML,[_projectDict objectForKey:@"Guid"],UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
        NSString *oneword = [[_projectDict objectForKey:@"t_Project_OneWord"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
        if (oneword.length>140) {
            oneword = [NSString stringWithFormat:@"%@",[oneword substringToIndex:140]];
        }
        NSString *title = [[NSString stringWithFormat:@"%@",[_projectDict objectForKey:@"t_Project_Name"]] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:oneword
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       //启动键盘
                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                       //启用/禁用键盘
                       manager.enable = YES;
                       //启用/禁用键盘触摸外面
                       manager.shouldResignOnTouchOutside = YES;
                       manager.shouldToolbarUsesTextFieldTintColor = YES;
                       manager.enableAutoToolbar = NO;
                       switch (state) {
                           case SSDKResponseStateSuccess:{
                               [self ShareIntegral:@"5"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:{
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 11;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==6){
        return [_funlist count]+1;
    }else if (section==7){
        return 2;
    }else if (section==10){
        if ([SourceArray count]>0) {
            return [SourceArray count]+2;
        } else {
            return 2;
        }
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 135*PMBWIDTH;
    }else if (indexPath.section==1){
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else if (indexPath.section==2){
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_Perfer"]]) {
            return 0;
        }else{
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==3){
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_Client"]]) {
            return 0;
        } else {
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==5){
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_ProfitWay"]]) {
            return 0;
        } else {
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==6){
        if (indexPath.row==0) {
            if ([_funlist count]==0) {
                return 0;
            } else {
                return 30*PMBWIDTH;
            }
        } else {
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==7){
        if (indexPath.row==0) {
            if ([[_projectDict objectForKey:@"Pic"] count]==0) {
                return 0;
            } else {
                return 30*PMBWIDTH;
            }
        } else {
            if ([[_projectDict objectForKey:@"Pic"] count]==0) {
                return 0;
            } else {
                return 180*PMBWIDTH;
            }
        }
    }else if (indexPath.section==10){
        
        if ([SourceArray count]>0) {
            if (indexPath.row==0) {
                return 38*SCREEN_WSCALE;
            }else{
                UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.height;
            }
        } else {
            return 36*SCREEN_WSCALE;
        }
    }else {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%zi%zi",indexPath.section,indexPath.row];
    
    if (indexPath.section==0) {
        
        ProjectDetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectDetCell"];
        cell = [[ProjectDetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellAccessoryNone;
 
        cell.cityStr.text=[_projectDict objectForKey:@"t_Project_CityName"];
        cell.fieldStr.text=[_projectDict objectForKey:@"FiledName"];
        cell.pStatusStr.text=[_projectDict objectForKey:@"PhaseName"];
        
        return cell;

    }else if(indexPath.section==1){
        
        ProjectDetailCell *cell = (ProjectDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetailCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ProjectDetailCell class]]) {
                    cell = (ProjectDetailCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        cell.content.textColor = [UIColor blackColor];
        cell.themeLabel.text = @"项目介绍";
        cell.themeLabel.textColor=[UIColor blackColor];
        cell.line.hidden=YES;
        NSString *text = [[_projectDict objectForKey:@"t_Project_Instruction"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if ([self isBlankString:text]) {
            text=@"";
        } else {
            text= text;
        }
        cell.content.text=text;
        [cell setIntroductionText:text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section==2) {
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_Perfer"]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            return cell;
        }else{
        ProjectDetailCell *cell = (ProjectDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetailCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ProjectDetailCell class]]) {
                    cell = (ProjectDetailCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        cell.content.textColor = [UIColor blackColor];
        cell.themeLabel.text = @"项目优势";
        cell.themeLabel.textColor=[UIColor blackColor];
        cell.line.hidden=YES;
        NSString *text=[[_projectDict objectForKey:@"t_Project_Perfer"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if ([self isBlankString:text]) {
            text=@"";
        } else {
            text= text;
        }
        cell.content.text=text;
        [cell setIntroductionText:text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    }else if (indexPath.section==3) {
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_Client"]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            return cell;
        } else {
        ProjectDetailCell *cell = (ProjectDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetailCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ProjectDetailCell class]]) {
                    cell = (ProjectDetailCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        cell.content.textColor = [UIColor blackColor];
        cell.themeLabel.text = @"目标用户";
        cell.themeLabel.textColor=[UIColor blackColor];
        cell.line.hidden=YES;
        NSString *text= [[_projectDict objectForKey:@"t_Project_Client"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if ([self isBlankString:text]) {
            text=@"";
        } else {
            text= text;
        }
        cell.content.text=text;
        [cell setIntroductionText:text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        }
    }else if (indexPath.section==4) {
        
        ProjectStatusCell *cell = (ProjectStatusCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectStatusCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectStatusCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ProjectStatusCell class]]) {
                    cell = (ProjectStatusCell *)oneObject;
                    cell.projectDelegate=self;
                }
            }
        }
        cell.tag = indexPath.row;
        
        if ([UserDefaultEntity.user_style isEqualToString:@"2"]) {
            if ([Investors isEqualToString:@"1"]) {
                cell.VCBtn.hidden=YES;
                cell.rongziLabel.text=[_projectDict objectForKey:@"PhaseName"];
                cell.rzPriceLabel.text=[_projectDict objectForKey:@"t_Project_Finance"];//
                cell.rzUseLabel.text=[[_projectDict objectForKey:@"t_Project_FinanceUse"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            }else if ([Investors isEqualToString:@"0"]){
                cell.VCBtn.hidden = YES;
            }
        }else if ([UserDefaultEntity.user_style isEqualToString:@"3"]){
            cell.VCBtn.hidden=YES;
        }else{
            cell.VCBtn.hidden=NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section==5){
        if ([self isBlankString:[_projectDict objectForKey:@"t_Project_ProfitWay"]]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            return cell;
        } else {
        ProjectDetailCell *cell = (ProjectDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectDetailCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetailCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ProjectDetailCell class]]) {
                    cell = (ProjectDetailCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        cell.content.textColor = [UIColor blackColor];
        cell.themeLabel.text = @"盈利途径";
        cell.themeLabel.textColor=[UIColor blackColor];
        cell.line.hidden=YES;
        NSString *text= [[_projectDict objectForKey:@"t_Project_ProfitWay"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];//t_Project_ProfitWay
        if ([self isBlankString:text]) {
            text=@"";
        } else {
            text= text;
        }
        cell.content.text=text;
        [cell setIntroductionText:text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        }
    }else if (indexPath.section==6){
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text=@"核心团队";
            cell.textLabel.font=Font(14);
            cell.textLabel.textColor=[UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            NSDictionary *dict=[_funlist objectAtIndex:indexPath.row-1];
            TeacherCell *cell = (TeacherCell*)[tableView dequeueReusableCellWithIdentifier:@"TeacherCell"];
            if (cell==nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeacherCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[TeacherCell class]]) {
                        cell = (TeacherCell *)oneObject;
                    }
                }
            }
            [cell.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]]] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            cell.Name.text = [dict objectForKey:@"t_User_RealName"];
            cell.Remark.text = [[dict objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            cell.position.hidden=NO;
            cell.position.text=[dict objectForKey:@"PositionName"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            
            return cell;

        }
    }else if (indexPath.section==7){
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell7"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text=@"产品展示";
            cell.textLabel.font=Font(14);
            cell.textLabel.textColor=[UIColor blackColor];
            
            return cell;
            
        } else {
            ScrollViewCell *cell = (ScrollViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ScrollViewCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ScrollViewCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ScrollViewCell class]]) {
                        cell = (ScrollViewCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            cell.ScrDelegate = self;
            NSArray *array=(NSArray*)[_projectDict objectForKey:@"Pic"];
            
            cell.adsArray=array;


            [cell.adsView setTotalPagesCount:^NSInteger{
                return [array count];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (indexPath.section==8){

        ScanLineCell *cell = (ScanLineCell *)[tableView dequeueReusableCellWithIdentifier:@"ScanLineCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ScanLineCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[ScanLineCell class]]) {
                    cell = (ScanLineCell *)oneObject;
                }
            }
        }
        cell.scanDelegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 判断是否改变当前图标高亮
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Website"]]) {
            cell.wangzhi_btn0.image = [UIImage imageNamed:@"wangzhi_btn0_n"];
        }
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Link"]]) {
            cell.wangzhi_btn1.image = [UIImage imageNamed:@"wangzhi_btn1_n"];
        }
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Weixin"]]) {
            cell.wangzhi_btn2.image = [UIImage imageNamed:@"wangzhi_btn2_n"];
        }

        return cell;
    }else if (indexPath.section==9){
        
        PartnerneedsCell *cell = (PartnerneedsCell *)[tableView dequeueReusableCellWithIdentifier:@"PartnerneedsCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PartnerneedsCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[PartnerneedsCell class]]) {
                    cell = (PartnerneedsCell *)oneObject;
                }
            }
        }
        [cell updateFrame:_projectDict];
        [cell setFrameHeight:_projectDict];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section==10){
        if ([SourceArray count]>0) {
            if (indexPath.row==0) {
                ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
                cell = [[ThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                
                return cell;
                
            }else if (indexPath.row==[SourceArray count]+1){
                
                MoreBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreBtnCell"];
                cell = [[MoreBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.moreDelegate=self;
                
                return cell;
            } else {
                
                DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row-1];
                
                TalkViewCell *cell = (TalkViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TalkViewCell"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TalkViewCell" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[TalkViewCell class]]) {
                            cell = (TalkViewCell *)oneObject;
                        }
                    }
                }
                cell.talkdelegate=self;
                cell.tag = indexPath.row-1;
                cell.deleteBtn.tag=indexPath.row-1;
                [cell updateData:model];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        } else {
            
            if (indexPath.row ==0) {
                ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
                cell = [[ThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                
                return cell;
            } else {
                NoMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoMsgCell"];
                cell = [[NoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                
                return cell;
            }
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==10){
        if ([SourceArray count]>0) {
            if (indexPath.row==0) {
                return;
            }else if (indexPath.row<=[SourceArray count]){
                // 回复
                DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row];
                touserguid = model.tTalkFromUserGuid;
                if ([touserguid isEqualToString:UserDefaultEntity.uuid]) {
                    
                    [SVProgressHUD showErrorWithStatus:@"自己不能回复自己" maskType:SVProgressHUDMaskTypeBlack];
                    touserguid = @"";
                }else{
                    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"项目评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
                    commit.delegate = self;
                    commit.placeholder.text=[NSString stringWithFormat:@"回复%@：",model.tUserRealName];
                    [self.view addSubview:commit];
                }
            }
        }
    }
}

-(void)cancle:(NSNotification *)text{
    
    touserguid=@"";
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quxiao" object:nil];
}

- (void)notice:(NSNotification *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:7];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tapImageWithObject:(ScrollViewCell *)cell
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageviews selectedView:cell.selectedimg];
}

#pragma mark - UIScrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BGK_HEIGHT)/2;
    if (yOffset < -BGK_HEIGHT) {
        CGRect rect = bgkImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        bgkImageView.frame = rect;
    }
    CGFloat alpha = MIN(1, (yOffset+BGK_HEIGHT)/BGK_HEIGHT);
    if (scrollView.contentOffset.y > -150) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    }
}
- (UIImage *)imageWithColor:(UIColor *)color{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

-(void)myTalk:(id)sender{
    
    QCHChatVcViewController *conversationVC = [[QCHChatVcViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = [_projectDict objectForKey:@"t_User_Guid"];
    conversationVC.title = [NSString stringWithFormat:@"与%@的对话",[_projectDict objectForKey:@"t_User_RealName"]];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

-(void)myCare:(id)sender{

    [HttpProjectAction AddOrCancelPraise:UserDefaultEntity.uuid projectGuid:[_projectDict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
             if (ifPraise==0) {
                 ifPraise=1;
                 [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
             } else {
                 ifPraise=0;
                 [careBtn setTitle:@"关注" forState:UIControlStateNormal];
             }
        }
    }];
}

-(void)setUserStyle:(ProjectStatusCell*)cell{
    
    InvestorsInformationVC *information = [[InvestorsInformationVC alloc]init];
    information.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:information animated:YES];
}

-(void)openScanLine:(ScanLineCell*)cell index:(NSInteger)index{
    if (index==0) {
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Website"]]) {
            NSString *text = [_projectDict objectForKey:@"t_Project_Website"];
            if ([[text substringToIndex:4] isEqualToString:@"HTTP"] || [[text substringToIndex:4] isEqualToString:@"http"]|| [[text substringToIndex:4] isEqualToString:@"Http"]|| [[text substringToIndex:4] isEqualToString:@"HTtp"]|| [[text substringToIndex:4] isEqualToString:@"HTTp"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_projectDict objectForKey:@"t_Project_Website"]]];
            }else{
                NSString *url = [NSString stringWithFormat:@"http://%@",[_projectDict objectForKey:@"t_Project_Website"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }

        }else{
          [SVProgressHUD showErrorWithStatus:@"项目方尚未添加官网链接" maskType:SVProgressHUDMaskTypeBlack];
        }
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://blog.csdn.net/duxinfeng2010"]];
    }else if (index==1){
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Link"]]) {
            NSString *text = [_projectDict objectForKey:@"t_Project_Link"];
            if ([[text substringToIndex:4] isEqualToString:@"HTTP"] || [[text substringToIndex:4] isEqualToString:@"http"]|| [[text substringToIndex:4] isEqualToString:@"Http"]|| [[text substringToIndex:4] isEqualToString:@"HTtp"]|| [[text substringToIndex:4] isEqualToString:@"HTTp"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_projectDict objectForKey:@"t_Project_Link"]]];
            }else{
                NSString *url = [NSString stringWithFormat:@"http://%@",[_projectDict objectForKey:@"t_Project_Website"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"项目方尚未添加客户端连接" maskType:SVProgressHUDMaskTypeBlack];
        }
    }else if (index==2){
        if (![self isBlankString:[_projectDict objectForKey:@"t_Project_Weixin"]]) {
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"拷贝链接" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拷贝", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"项目方尚未添加微信公众号" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[_projectDict objectForKey:@"t_Project_Weixin"]];
        [SVProgressHUD showSuccessWithStatus:@"拷贝成功" maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(UILabel *)createLabelFrame:(CGRect)frame color:(UIColor*)color font:(UIFont *)font text:(NSString *)text{
    
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.font=font;
    label.textColor=color;
    label.textAlignment=NSTextAlignmentLeft;
    label.text=text;
    
    return label;
}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backToSmall" object:nil];
}
@end
