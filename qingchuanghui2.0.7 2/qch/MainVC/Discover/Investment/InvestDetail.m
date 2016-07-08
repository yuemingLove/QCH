//
//  InvestDetail.m
//  qch
//
//  Created by 青创汇 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestDetail.h"
#import "ParntViewCell.h"
#import "InvestCell.h"
#import "HatchCell.h"
#import "ProjectDetailVC.h"
#import "SettledCell.h"
#import "SelectProjectVC.h"
#import "Theme2Cell.h"
#import "InvectProjectVC.h"
#import "TextEntity.h"
#import "TextShowCell.h"
#import "AddProjectVC.h"
#import "UINavigationBar+Background.h"
@interface InvestDetail ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HatchCellDelegate,SelectProjectVCDelegate,UIAlertViewDelegate>{

    TextEntity *entity;
}


@property (weak, nonatomic) UITableView *tableListView;
@property (nonatomic,strong) NSDictionary *parntDict;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *caselist;
@property (nonatomic,strong) NSMutableArray *memberlist;
@property (nonatomic,strong) NSMutableArray *projectlist;


/**
 *背景图片BgImage
 */
@property(weak,nonatomic)UIImageView* BgImage;

@property(weak,nonatomic)UILabel *titleLabel;

/**
 *背景图片bgView
 */
@property (nonatomic,weak) UIView* bgView;

@property (nonatomic,strong) UIImageView *faceImageView;
@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation InvestDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_caselist !=nil) {
        _caselist = [[NSMutableArray alloc]init];
    }
    if (_memberlist !=nil) {
        _memberlist = [[NSMutableArray alloc]init];
    }
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationCapturesStatusBarAppearance=YES;
    [self getData];
    [self createTableView];
    [self createBgImageView];
    [self createFooterView];
    
    self.view.backgroundColor=[UIColor lightGrayColor];

    
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
    
}
- (void)backAction {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar cnReset];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableListView.delegate = self;
    [self scrollViewDidScroll:self.tableListView];
    
    if (self.tableListView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableListView.delegate = nil;
    if (self.tableListView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar cnReset];
    }
}

-(void)createBgImageView{
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    UIImage *image = [UIImage imageNamed:@"beijing_img.jpg"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    /**
     *创建用户空间背景图片
     */
    UIImageView* BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT)];
    BgImage.image=blurredImage;
    self.BgImage=BgImage;
    [self.tableListView addSubview:BgImage];
    
    /**
     *创建用户空间背景图片的容器View
     */
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.frame=CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT);
    self.bgView=bgView;
    [self.tableListView addSubview:bgView];
    
    _faceImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 64, 70, 70)];
    _faceImageView.layer.masksToBounds=YES;
    _faceImageView.layer.cornerRadius=_faceImageView.bounds.size.height/2;
    [_faceImageView setImage:[UIImage imageNamed:@"loading_1"]];
    [self.bgView addSubview:_faceImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, _faceImageView.bottom+10, SCREEN_WIDTH-100, 24*SCREEN_WSCALE)];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=Font(14);
    [self.bgView addSubview:_nameLabel];
    
}

-(void)createTableView{
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor themeGrayColor]];
    //tableView.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableListView=tableView;
    [self.view addSubview:tableView];
    
    [self setExtraCellLineHidden:self.tableListView];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)createFooterView{
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableListView.bottom, SCREEN_WIDTH, 49)];
    footerView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footerView];
    
    UIButton *submitProBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitProBtn.frame = CGRectMake(0, 0, ScreenWidth, 49);
    [submitProBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitProBtn setTitle:@"提交项目" forState:UIControlStateNormal];
    [submitProBtn addTarget:self action:@selector(submitProjectAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitProBtn];
}

- (void)getData{
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpInvestPlaceAction GetInvestPlaceView:_Guid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _parntDict=[dict objectForKey:@"result"][0];
            _caselist = (NSMutableArray *)[_parntDict objectForKey:@"Cases"];
            _memberlist = (NSMutableArray *)[_parntDict objectForKey:@"Members"];
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_parntDict objectForKey:@"t_InvestPlace_ConverPic"]];
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            _nameLabel.text= [[_parntDict objectForKey:@"t_InvestPlace_Title"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            
            entity=[TextEntity new];
            entity.isShowMoreText=NO;
            entity.textId=1;
            entity.textName=@"详细介绍";
            entity.textContent=[[_parntDict objectForKey:@"t_InvestPlace_Instruction"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
        }
        [self.tableListView reloadData];
    }];
}

- (void)submitProjectAction:(UIButton *)sender{
    
    [HttpCenterAction GetMyProject:UserDefaultEntity.uuid ifAudit:-1 page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _projectlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
            if ([_projectlist count]>0) {
                
                SelectProjectVC *selectProject=[[SelectProjectVC alloc]init];
                selectProject.spDelegate=self;
                selectProject.funlist=_projectlist;
                [self.navigationController pushViewController:selectProject animated:NO];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];
            }
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _projectlist=[[NSMutableArray alloc]init];
            
            [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            _projectlist=[[NSMutableArray alloc]init];

            [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载"];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==5) {
        return _memberlist.count;
    }else if (section==3){
        if ([_caselist count]==0) {
            return 0;
        } else {
            return 1;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        return 1*SCREEN_WSCALE;
    }else if (section==1 || section==3 || section==2){
        return 5*SCREEN_WSCALE;
    }else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==3) {
        CGFloat width=(SCREEN_WIDTH-100)/4;
        if ([_caselist count]==0) {
            return 0;
        }else if ([_caselist count]>4) {
            return 34*SCREEN_WSCALE+(width+33*SCREEN_WSCALE)*2;
        } else {
            return 67*SCREEN_WSCALE+width;
        }
    }else if(indexPath.section==2){
        //根据isShowMoreText属性判断cell的高度
        if (entity.isShowMoreText){
            return [TextShowCell cellMoreHeight:entity];
        }else{
            return [TextShowCell cellDefaultHeight:entity];
        }

    }else{
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
            ParntViewCell *cell = (ParntViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ParntViewCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ParntViewCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ParntViewCell class]]) {
                        cell = (ParntViewCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            cell.receiveLabel.text = @"接收项目";
            cell.SettledLabel.text = @"入驻成员";
            cell.careNumLabel.text=[_parntDict objectForKey:@"CaseCount"];
            cell.fensiNumLabel.text=[_parntDict objectForKey:@"MemberCount"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
    }else if (indexPath.section==1){
        InvestCell *cell = (InvestCell*)[tableView dequeueReusableCellWithIdentifier:@"InvestCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"InvestCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[InvestCell class]]) {
                    cell = (InvestCell *)oneObject;
                }
            }
        }
        cell.type=1;
        cell.tag = indexPath.row;
        [cell updateFrame:_parntDict];
        [cell setFrameHeight:_parntDict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section==2){
        
        static NSString *identifier = @"cell";
        TextShowCell *cell = (TextShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[TextShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //这里的判断是为了防止数组越界
        cell.entity = entity;
        //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
        cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
            NSIndexPath *indexRow = [self.tableListView indexPathForCell:currentCell];
            [self.tableListView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;
        
    }else if (indexPath.section==3){
        HatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HatchCell"];
        if (cell==nil) {
            cell = [[HatchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HatchCell"];
        }
        cell.hatchDelegate=self;
        cell.type=1;
        [cell updateData:_caselist];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section==4){
        Theme2Cell *cell = (Theme2Cell*)[tableView dequeueReusableCellWithIdentifier:@"Theme2Cell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"Theme2Cell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[Theme2Cell class]]) {
                    cell = (Theme2Cell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        cell.themeLabel.text=@"入驻成员";
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        return cell;
    }else if(indexPath.section==5){
            NSDictionary *dict = [_memberlist objectAtIndex:indexPath.row];
            SettledCell *cell = (SettledCell *)[tableView dequeueReusableCellWithIdentifier:@"SettledCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"SettledCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[SettledCell class]]) {
                        cell = (SettledCell *)oneObject;
                    }
                }
            }
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"UserPic"]];
            [cell.HeadImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            cell.NameImg.text = [dict objectForKey:@"UserName"];
            cell.Remak.text = [[dict objectForKey:@"OneWord"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        return nil;
}

-(void)moreProject:(HatchCell*)cell index:(NSInteger)index{
    
    InvectProjectVC *projectVC=[[InvectProjectVC alloc]init];
    projectVC.projectlist=_caselist;
    [self.navigationController pushViewController:projectVC animated:YES];
}

-(void)selectProject:(HatchCell*)cell index:(NSInteger)index{
    
    NSDictionary *dict=[_caselist objectAtIndex:index];
    ProjectDetailVC *projectDetail=[[ProjectDetailVC alloc]init];
    // 后个页面导航栏也是渐变
    [projectDetail setUpdateNav:^{
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }];
    projectDetail.guId=[dict objectForKey:@"CaseGuid"];
    [self.navigationController pushViewController:projectDetail animated:YES];
}

-(void)selectProject:(NSString *)projectGuid{
    
    
    [HttpInvestPlaceAction AddInvestPlaceProject:projectGuid investplaceGuid:[_parntDict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"projectGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"请求数据出错，请重新提交" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


#pragma mark - UIScrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BGK_HEIGHT)/2;
    if (yOffset < -BGK_HEIGHT) {
        CGRect rect = self.BgImage.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        self.BgImage.frame = rect;
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

- (void)shareViewBtn:(UIButton *)sender
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    UIImageView *img = [[UIImageView alloc]init];
    NSString *imgurl = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_parntDict objectForKey:@"t_InvestPlace_ConverPic"]];
    [img sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"logo"]];
    NSString *path=[NSString stringWithFormat:@"%@ShareInvestPlace.html?Guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
    
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    if (imageArray) {
        
        NSString *title = [NSString stringWithFormat:@"青创汇入驻投资机构推荐 %@",[_parntDict objectForKey:@"t_InvestPlace_Title"]];
        NSDictionary *dict = [_parntDict objectForKey:@"InvestArea"][0];
        NSString *InvestArea = [dict objectForKey:@"InvestAreaName"];
        NSString *description = [NSString stringWithFormat:@"%@,正在关注%@领域创业项目,投资金额%@,快来提交吧",title,InvestArea,[_parntDict objectForKey:@"t_InvestPlace_Money"]];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:description
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
                               [self ShareIntegral:@"6"];
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

@end
