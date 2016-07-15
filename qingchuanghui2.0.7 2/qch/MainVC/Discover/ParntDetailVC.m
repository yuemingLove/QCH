//
//  ParntDetailVC.m
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ParntDetailVC.h"
#import "Theme2Cell.h"
#import "ParntIntCell.h"
#import "ParntViewCell.h"
#import "ProjectListCell.h"
#import "ProjectCollotionCell.h"
#import "ProjectDetailVC.h"
#import "InvestCell.h"
#import "InvestorsInformationVC.h"
#import "AddProjectVC.h"
#import "SelectProjectVC.h"
#import "UINavigationBar+Background.h"
#import "ShowView.h"
#import "PreferencesCell.h"
@interface ParntDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ProjectCollotionCellDelegate,SelectProjectVCDelegate,XHImageViewerDelegate>{

    UIButton *careBtn;
    NSInteger ifPraise;
}

@property (weak, nonatomic) UITableView *tableListView;
@property (nonatomic,strong) NSDictionary *parntDict;

@property (nonatomic,strong) NSMutableArray *imageViews;

@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *usePlist;

@property (nonatomic,strong) NSMutableArray *projectlist;

/**
 *背景图片BgImage
 */
@property(strong,nonatomic)UIImageView *BgImage;

@property(weak,nonatomic)UILabel *titleLabel;

/**
 *背景图片bgView
 */
@property (nonatomic,weak) UIView* bgView;

@property (nonatomic,strong) UIImageView *faceImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;


@end

@implementation ParntDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_usePlist !=nil) {
        _usePlist=[[NSMutableArray alloc]init];
    }
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationCapturesStatusBarAppearance=YES;
    [self createTableView];
    [self createBgImageView];
    if (![_Guid isEqualToString:UserDefaultEntity.uuid]) {
        [self createFooterView];
    }

    
    if ([_Guid isEqualToString:UserDefaultEntity.uuid]) {
        
        UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithTitle:@"编辑资料" style:UIBarButtonItemStylePlain target:self action:@selector(compile:)];
        self.navigationItem.rightBarButtonItem = rightbar;
        
    }else{
        //share
        UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareViewBtn:)];
        self.navigationItem.rightBarButtonItem=shareView;

    }
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
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
- (void)backAction {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar cnReset];
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getData{
    
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:_Guid forKey:@"guid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpPartnerAction GetUserView:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            _parntDict = [result objectForKey:@"result"][0];
            
            _funlist=(NSMutableArray *)[_parntDict objectForKey:@"InvestCase"];
            _usePlist=(NSMutableArray *)[_parntDict objectForKey:@"UserProject"];
            
            NSString *bgkPath=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_parntDict objectForKey:@"t_BackPic"]];
            [self.BgImage sd_setImageWithURL:[NSURL URLWithString:bgkPath] placeholderImage:[UIImage imageNamed:@"beijing_img.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //高斯模糊
                GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
                blurFilter.blurSize=2.0;
                UIImage *blurredImage = [blurFilter imageByFilteringImage:self.BgImage.image];
                self.BgImage.image = blurredImage;
            }];
            
            NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,[_parntDict objectForKey:@"t_User_Pic"]];
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            
            _imageViews=[NSMutableArray new];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*PMBWIDTH)/2, 64*PMBWIDTH,70*PMBWIDTH, 0)];
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            [_imageViews addObject:image];
            
            _nameLabel.text=[_parntDict objectForKey:@"t_User_RealName"];
            _detailLabel.text=[NSString stringWithFormat:@"%@  %@",[_parntDict objectForKey:@"PositionName"],[_parntDict objectForKey:@"t_User_Commpany"]];
            
            ifPraise=[(NSNumber*)[_parntDict objectForKey:@"ifFoucs"]integerValue];
            if (ifPraise==1) {
                [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [careBtn setTitle:@"关注" forState:UIControlStateNormal];
            }
            [SVProgressHUD dismiss];
            [_tableListView reloadData];
        }
    }];
}

-(void)createTableView{
    if (![_Guid isEqualToString:UserDefaultEntity.uuid]) {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor themeGrayColor]];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableListView=tableView;
        [self.view addSubview:tableView];
        
        [self setExtraCellLineHidden:self.tableListView];
    }else{
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [tableView setBackgroundColor:[UIColor themeGrayColor]];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableListView=tableView;
        [self.view addSubview:tableView];
        
        [self setExtraCellLineHidden:self.tableListView];
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)createBgImageView{

    /**
     *创建用户空间背景图片
     */
    self.BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT)];
    [self.tableListView addSubview:self.BgImage];
    
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
    
    [_faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBigImage:)]];
    _faceImageView.userInteractionEnabled = YES;
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, _faceImageView.bottom+10, SCREEN_WIDTH-100, 24*SCREEN_WSCALE)];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=Font(14);
    [self.bgView addSubview:_nameLabel];
    
    _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _detailLabel.textAlignment=NSTextAlignmentCenter;
    _detailLabel.textColor=[UIColor whiteColor];
    _detailLabel.font=Font(14);
    [self.bgView addSubview:_detailLabel];
    
}

-(void)createFooterView{

    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableListView.bottom, SCREEN_WIDTH, 49)];
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
    [careBtn setTitle:@"关注" forState:UIControlStateNormal];
    
    [careBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    careBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    careBtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    [careBtn addTarget:self action:@selector(myCare:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:careBtn];

    UIButton *submitProBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitProBtn=[[UIButton alloc]initWithFrame:CGRectMake((width+1)*2, talkBtn.top, width, 30)];
    [submitProBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitProBtn setTitle:@"提交项目" forState:UIControlStateNormal];
    [submitProBtn addTarget:self action:@selector(submitProjectAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitProBtn];
    
}

- (void)tapBigImage:(UITapGestureRecognizer *)tap{
    //  获取点击图片在父视图的位置
    UIImageView *imageView = (UIImageView*)tap.view;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    ShowView *showView = [[[NSBundle mainBundle] loadNibNamed:@"ShowView" owner:nil options:nil] firstObject];
    showView.frame = self.view.bounds;
    showView.alpha = 1;
    [window addSubview:showView];
    CGRect frame = [imageView convertRect:imageView.bounds toView:window];
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:frame];
    showImage.layer.cornerRadius = showImage.height / 2;
    showImage.layer.masksToBounds = YES;
    showImage.image = imageView.image;
    [showView addSubview:showImage];
    UIImageView *showImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    showImage2.center = window.center;
    __weak typeof(showImage) photoView = showImage;
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        photoView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        photoView.center = window.center;
        
    } completion:^(BOOL finished) {
        showImage2.image = photoView.image;
        [showView addSubview:showImage2];
    }];
    
    __weak typeof(showView) show = showView;
    [showView setBlock:^{
        [showImage2 removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            photoView.frame = frame;
            show.alpha = 0;
        }completion:^(BOOL finished) {
            [show removeFromSuperview];
        }];
    }];
}

-(void)myTalk:(id)sender{

    
    QCHChatVcViewController *conversationVC = [[QCHChatVcViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = _Guid;
    conversationVC.title = [NSString stringWithFormat:@"与%@的对话",[_parntDict objectForKey:@"t_User_RealName"]];
    [self.navigationController pushViewController:conversationVC animated:YES];

}

-(void)myCare:(id)sender{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:[_parntDict objectForKey:@"Guid"] forKey:@"foucsUserGuid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpPartnerAction AddCareOrCancelPraise:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if (ifPraise==0) {
                ifPraise=1;
                [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                [self getData];
            }else{
                ifPraise=0;
                [careBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self getData];
            }
        }
    }];
}

-(void)submitProjectAction:(id)sender{
    
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
        }
    }];

}


-(void)selectProject:(NSString *)projectGuid{
    
    [HttpProjectAction AddSendProject:UserDefaultEntity.uuid projectGuid:projectGuid investuserGuid:[_parntDict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return [_funlist count]+1;
            break;
        case 5:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        if ([[_parntDict objectForKey:@"Intention"] count]==0) {
            return 0;
        }else{
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==5) {
        if (_usePlist.count==0) {
            return 0;
        }else{
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 0;
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
        cell.careNumLabel.text=[_parntDict objectForKey:@"PCount"];
        cell.fensiNumLabel.text=[_parntDict objectForKey:@"FCount"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    } else if (indexPath.section==1) {
        
        if (indexPath.row==0) {
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
            cell.themeLabel.text=@"个人简介";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            ParntIntCell *cell = (ParntIntCell*)[tableView dequeueReusableCellWithIdentifier:@"ParntIntCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ParntIntCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ParntIntCell class]]) {
                        cell = (ParntIntCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            cell.contentLabel.text = [_parntDict objectForKey:@"t_User_Remark"];
            [cell setIntroductionText:[_parntDict objectForKey:@"t_User_Remark"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (indexPath.section==2){
        if ([[_parntDict objectForKey:@"Intention"] count]==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            return cell;
    }else{
        if (indexPath.row==0) {
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
            cell.themeLabel.text=@"创业偏好";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
    }else{
        PreferencesCell *cell = (PreferencesCell*)[tableView dequeueReusableCellWithIdentifier:@"PreferencesCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PreferencesCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[PreferencesCell class]]) {
                    cell = (PreferencesCell *)oneObject;
                }
            }
        }
       [cell updataFrame:_parntDict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
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
            cell.themeLabel.text=@"投资风格";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            InvestCell *cell = (InvestCell*)[tableView dequeueReusableCellWithIdentifier:@"InvestCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"InvestCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[InvestCell class]]) {
                        cell = (InvestCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            [cell updateFrame:_parntDict];
            [cell setFrameHeight:_parntDict];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (indexPath.section==4){
        if (indexPath.row==0) {
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
            cell.themeLabel.text=@"投资案例";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            NSDictionary *dict=[_funlist objectAtIndex:indexPath.row-1];
            
            ProjectListCell *cell = (ProjectListCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectListCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ProjectListCell class]]) {
                        cell = (ProjectListCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            [cell updateFrame:dict];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }else if (indexPath.section==5){
        if (indexPath.row==0) {
            if (_usePlist.count==0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                return cell;
            }else{
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
                cell.themeLabel.text=@"关注的项目";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        } else {
            if (_usePlist.count==0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                return cell;
            }else{
            ProjectCollotionCell *cell = (ProjectCollotionCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectCollotionCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectCollotionCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ProjectCollotionCell class]]) {
                        cell = (ProjectCollotionCell *)oneObject;
                    }
                }
            }
            cell.projectDelegate=self;
            cell.tag = indexPath.row;
            cell.funlist=_usePlist;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            }
        }
    }
    
    return nil;
}

-(void)projectSelectBtn:(ProjectCollotionCell*)cell index:(NSInteger)index{

    NSDictionary *dict=[_usePlist objectAtIndex:index];
    ProjectDetailVC *project = [[ProjectDetailVC alloc]init];
    project.guId = [dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:project animated:YES];
}

-(void)shareViewBtn:(id)sender{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_USER,[_parntDict objectForKey:@"t_User_Pic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareUserInfo.html?Guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {

        NSString *title = [NSString stringWithFormat:@"创业投资人推荐 %@",[_parntDict objectForKey:@"t_User_RealName"]];
        NSDictionary *dict = [_parntDict objectForKey:@"InvestArea"][0];
        NSString *InvestArea = [dict objectForKey:@"InvestAreaName"];
        NSString *description = [NSString stringWithFormat:@"%@,%@,正在寻找%@领域好项目,快来提交吧",[_parntDict objectForKey:@"t_User_RealName"],[_parntDict objectForKey:@"PositionName"],InvestArea];
        
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
                               [self ShareIntegral:@"4"];
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

- (void)compile:(UIBarButtonItem *)sender{
    
    InvestorsInformationVC *person =[[InvestorsInformationVC alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    person.title = @"编辑资料";
    person.InvestArray = (NSMutableArray *)[_parntDict objectForKey:@"InvestCase"];
    NSString *purpose = @"";
    NSString *purposeid = @"";
    
    for (int i = 0; i<[[_parntDict objectForKey:@"Intention"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"Intention"] objectAtIndex:i];
        NSString *intention = [dict objectForKey:@"IntentionName"];
        NSString *ID = [dict objectForKey:@"IntentionID"];
        if ([self isBlankString:purpose]) {
            purpose = intention;
        }else{
            purpose = [purpose stringByAppendingString:[NSString stringWithFormat:@" %@",intention]];
        }
        if ([self isBlankString:purposeid]) {
            purposeid = ID;
        }else{
            purposeid = [purposeid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.purpose = purpose;
    person.purposeID = purposeid;
    person.type = 1;
    
    NSString *beststr =@"";
    NSString *bestid = @"";
    
    for (int i = 0; i<[[_parntDict objectForKey:@"Best"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"Best"] objectAtIndex:i];
        NSString *best = [dict objectForKey:@"BestName"];
        NSString *ID = [dict objectForKey:@"BestID"];
        
        if ([self isBlankString:beststr]) {
            beststr = best;
        }else{
            beststr = [beststr stringByAppendingString:[NSString stringWithFormat:@" %@",best]];
        }
        
        if ([self isBlankString:bestid]) {
            bestid = ID;
        }else{
            bestid = [bestid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.Best = beststr;
    person.Bestid = bestid;
    person.type = 1;
    
    NSString *attention = @"";
    NSString *attentionid = @"";
    
    for (int i = 0; i<[[_parntDict objectForKey:@"FoucsArea"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"FoucsArea"] objectAtIndex:i];
        NSString *atten = [dict objectForKey:@"FoucsName"];
        NSString *ID = [dict objectForKey:@"FoucsID"];
        if ([self isBlankString:attention]) {
            attention = atten;
        }else{
            attention = [attention stringByAppendingString:[NSString stringWithFormat:@" %@",atten]];
        }
        if ([self isBlankString:attentionid]) {
            attentionid = ID;
        }else{
            attentionid = [attentionid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.Attentionstr = attention;
    person.Attentionid = attentionid;
    person.type = 1;
    
    NSString *nowneed = @"";
    NSString *nowneedid = @"";
    
    for (int i = 0; i<[[_parntDict objectForKey:@"NowNeed"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"NowNeed"] objectAtIndex:i];
        NSString *need = [dict objectForKey:@"NowNeedName"];
        NSString *ID = [dict objectForKey:@"NowNeedID"];
        if ([self isBlankString:nowneed]) {
            nowneed = need;
        }else{
            nowneed = [nowneed stringByAppendingString:[NSString stringWithFormat:@" %@",need]];
        }
        if ([self isBlankString:nowneedid]) {
            nowneedid = ID;
        }else{
            nowneedid = [nowneedid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    
    person.NowneedStr = nowneed;
    person.NowneedID = nowneedid;
    person.type = 1;
    
    NSString *beststring = @"";
    NSString *bestID = @"";
    for (int i=0; i<[[_parntDict objectForKey:@"InvestArea"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"InvestArea"] objectAtIndex:i];
        NSString *best = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestAreaName"]];
        NSString*ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestAreaID"]];
        if ([self isBlankString:beststring]) {
            beststring = best;
        }else{
            beststring = [beststring stringByAppendingString:[NSString stringWithFormat:@" %@",best]];
        }
        if ([self isBlankString:bestID]) {
            bestID=ID;
        } else {
            bestID = [bestID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.DomainIDstr = bestID;
    person.type=1;
    person.DomainStr = beststring;
    
    NSString *DomainS = @"";
    NSString *Id = @"";
    for (int i =0; i<[[_parntDict objectForKey:@"InvestPhase"] count]; i++) {
        NSDictionary *dict = [[_parntDict objectForKey:@"InvestPhase"] objectAtIndex:i];
        NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestPhaseName"]];
        NSString *domainID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestPhaseID"]];
        if ([self isBlankString:DomainS]) {
            DomainS = domain;
        }else{
            DomainS = [DomainS stringByAppendingString:[NSString stringWithFormat:@" %@",domain]];
        }
        if ([self isBlankString:Id]) {
            Id = domainID;
        } else {
            Id = [Id stringByAppendingString:[NSString stringWithFormat:@";%@",domainID]];
        }
    }
    person.StateIDstr = Id;
    person.type=1;
    person.IforNo=NO;
    person.StateStr = DomainS;
    [self.navigationController pushViewController:person animated:NO];
    
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
@end
