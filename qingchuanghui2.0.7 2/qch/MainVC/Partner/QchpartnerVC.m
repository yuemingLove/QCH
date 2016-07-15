//
//  QchpartnerVC.m
//  qch
//
//  Created by 青创汇 on 16/2/17.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchpartnerVC.h"
#import "PersonDynamicCell.h"
#import "PartnerProjectCell.h"
#import "BaseInformationCell.h"
#import "ProjectDetailVC.h"
#import "DynamicstateVC.h"
#import "PersonInfomationVC.h"
#import "MyDynamicVC.h"
#import "MyProject2VC.h"
#import "ProjectDetailCell.h"
#import "BestAndDocell.h"
#import "UINavigationBar+Background.h"
#import "ShowView.h"

@interface QchpartnerVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,XHImageViewerDelegate>
{

    UIButton *careBtn;
    NSInteger ifPraise;
    PartnerResult *model;
    NSString *EDate;
    UIButton *Nowneed;


}
@property (weak, nonatomic) UITableView *tableListView;
@property (nonatomic,strong) NSDictionary *item;

/**
 *背景图片BgImage
 */
@property(strong,nonatomic)UIImageView* BgImage;
@property (nonatomic,strong) NSMutableArray *imageViews;


@property(weak,nonatomic)UILabel *titleLabel;

/**
 *背景图片bgView
 */
@property (nonatomic,weak) UIView* bgView;

@property (nonatomic,strong) UIImageView *faceImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;


@end

@implementation QchpartnerVC


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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationCapturesStatusBarAppearance=YES;

    [self createTableView];
    [self createBgImageView];

    if (![_Guid isEqualToString:UserDefaultEntity.uuid]) {
        [self createFooterBtnView];
    }

    if ([_Guid isEqualToString:UserDefaultEntity.uuid]) {
        
        UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithTitle:@"编辑资料" style:UIBarButtonItemStylePlain target:self action:@selector(compile:)];
        self.navigationItem.rightBarButtonItem = rightbar;
        
    }else{
        UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
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

- (void)backAction {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar cnReset];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createBgImageView{

    /**
     *创建用户空间背景图片
     */
    self.BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT)];
    self.BgImage.image = [UIImage imageNamed:@"beijing_img.jpg"];
    [self.tableListView addSubview:self.BgImage];
    
    /**
     *创建用户空间背景图片的容器View
     */
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.frame=CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT);
    self.bgView=bgView;
    [self.tableListView addSubview:bgView];
    
    _faceImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*PMBWIDTH)/2, 44*PMBWIDTH, 70*PMBWIDTH, 70*PMBWIDTH)];
    _faceImageView.layer.masksToBounds=YES;
    _faceImageView.layer.cornerRadius=_faceImageView.bounds.size.height/2;
    [self.bgView addSubview:_faceImageView];
    
    [_faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbigImage:)]];
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



-(void)createFooterBtnView{
    
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableListView.bottom, SCREEN_WIDTH, 49)];
    footerView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footerView];
    
    CGFloat width=(SCREEN_WIDTH-1)/2;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(width, 8, 1, 33)];
    line.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:line];
    
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
    
    
    [careBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    careBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    careBtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    
    [careBtn addTarget:self action:@selector(myCare:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:careBtn];
}

-(void)myTalk:(id)sender{

    QCHChatVcViewController *conversationVC = [[QCHChatVcViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = _Guid;
    conversationVC.title = [NSString stringWithFormat:@"与%@的对话",model.tUserRealName];
    [self.navigationController pushViewController:conversationVC animated:YES];
}

-(void)myCare:(id)sender{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:_Guid forKey:@"foucsUserGuid"];
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
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
           
        }
    }];
}

- (void)getData
{
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:_Guid forKey:@"guid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpPartnerAction GetUserView:dict complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:result];
            _item = [result objectForKey:@"result"][0];
            model = rpnc.result[0];
            
            NSArray *needarray = [_item objectForKey:@"Intention"];
            if ([needarray count]>0) {
                NSDictionary *dict = needarray[0];
                NSString *intentionname = [NSString stringWithFormat:@"  %@",[dict objectForKey:@"IntentionName"]];
                [Nowneed setTitle:intentionname forState:UIControlStateNormal];
            }else{
                Nowneed.hidden = YES;
            }
            NSString *bgkPath=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_item objectForKey:@"t_BackPic"]];
            [self.BgImage sd_setImageWithURL:[NSURL URLWithString:bgkPath] placeholderImage:[UIImage imageNamed:@"beijing_img.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //高斯模糊
                GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
                blurFilter.blurSize=2.0;
                UIImage *blurredImage = [blurFilter imageByFilteringImage:self.BgImage.image];
                self.BgImage.image = blurredImage;
            }];
            _imageViews=[NSMutableArray new];
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_imageViews addObject:_faceImageView];
            }];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*PMBWIDTH)/2, 64*PMBWIDTH,70*PMBWIDTH, 0)];
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            _detailLabel.text=[NSString stringWithFormat:@"%@      %@",model.positionName,model.tUserCommpany];
            _nameLabel.text=model.tUserRealName;
            
            ifPraise = [model.ifFoucs integerValue];
            if (ifPraise==1) {
                [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [careBtn setTitle:@"关注" forState:UIControlStateNormal];
            }
            [_tableListView reloadData];

        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    else if (section==2){
        return [model.historyWork count];
    }
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 1*PMBWIDTH;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            BaseInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseInformationCell"];
            if (cell == nil) {
                cell = [[BaseInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseInformationCell"];
            }
            cell.model = model;
            cell.FansLab.text = model.fCount;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1 ) {
            if (model.topic.count==0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                return cell;
            }else{
                PersonDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonDynamicCell"];
                if (cell == nil) {
                    cell = [[PersonDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonDynamicCell"];
                }
                cell.model = model;
                [cell.SelctedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if (indexPath.row == 2){
            if (model.userProject.count==0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                return cell;
            }else{
                PartnerProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartnerProjectCell"];
                if (cell==nil) {
                    cell = [[PartnerProjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PartnerProjectCell"];
                }
                cell.model = model;
                [cell.MoreBtn addTarget:self action:@selector(moreproject:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if (indexPath.row==3){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            if([UserDefaultEntity.uuid isEqualToString:_Guid]){
                cell.textLabel.text = @"我的信息";
            }else{
                cell.textLabel.text = @"Ta的信息";
            }
            cell.textLabel.textColor = TSEColor(102, 102, 102);
            cell.textLabel.font = Font(14);
            cell.backgroundColor = TSEColor(243, 243, 243);
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row==4){
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
            cell.themeLabel.text = @" 个人描述";
            cell.themeLabel.textColor = [UIColor blackColor];
            NSString *text= [model.tUserRemark stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
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
    }else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = Font(14);
        cell.textLabel.text = @"工作经历";
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        HistoryWork *work = [model.historyWork objectAtIndex:indexPath.row];
        NSDate *Sdate = [DateFormatter stringToDateCustom:work.tSDate formatString:def_YearMonthDay_DF];
        NSString *SDate = [DateFormatter dateToStringCustom:Sdate formatString:def_YearMobth];
        if ([work.tEDate isEqualToString:@""]) {
            EDate = @"至今";
        }else{
            NSDate *Edate = [DateFormatter stringToDateCustom:work.tEDate formatString:def_YearMonthDay_DF];
            EDate = [DateFormatter dateToStringCustom:Edate formatString:def_YearMobth];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@--%@   %@   %@",SDate,EDate,work.tPosition,work.tCommpany];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = Font(14);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==3){
        BestAndDocell *cell = [tableView dequeueReusableCellWithIdentifier:@"BestAndDocell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"BestAndDocell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[BestAndDocell class]]) {
                    cell = (BestAndDocell *)oneObject;
                }
            }
        }
        [cell updateFrame:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 45*PMBWIDTH;
        }else if (indexPath.row == 1) {
            if (model.topic.count==0) {
                return 0;
            }
            return 135*PMBWIDTH;
        }else if (indexPath.row == 2){
            if (model.userProject.count==0) {
                return 0;
            }
            return 145*PMBWIDTH;
        }else if (indexPath.row==3){
            return 35*PMBWIDTH;
        }else if (indexPath.row==4){
            
            UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
    }else if (indexPath.section==1){
        return 25*PMBWIDTH;
    }else if (indexPath.section==2){
        return 25*PMBWIDTH;
    }else if (indexPath.section ==3){
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            NSArray *array = model.topic;
            if (array.count>0) {
                PartnerTopic *topic = array[0];
                DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
                dynamic.guid = topic.guid;
                [self.navigationController pushViewController:dynamic animated:NO];
            }
        }else if (indexPath.row==2){
            NSArray *array = model.userProject;
            if (array.count>0) {
                UserProject *pro = array[0];
                ProjectDetailVC *project = [[ProjectDetailVC alloc]init];
                project.guId = pro.guid ;
                [self.navigationController pushViewController:project animated:NO];
            }
        }
    }
}
- (void)tapbigImage:(UITapGestureRecognizer *)tap{

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


- (void)share:(UIButton *)sender{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_USER,[_item objectForKey:@"t_User_Pic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareUserInfo.html?Guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {

        NSString *title = [NSString stringWithFormat:@"创业合伙人推荐 %@",[_item objectForKey:@"t_User_RealName"]];
        NSString *Intention = @"";
        NSString *description=@"";
        NSDictionary *dict1 = [_item objectForKey:@"FoucsArea"][0];
        NSString *FoucsArea = [dict1 objectForKey:@"FoucsName"];
        if ([[_item objectForKey:@"Intention"] count]>0) {
            NSDictionary *dict = [_item objectForKey:@"Intention"][0];
            Intention = [dict objectForKey:@"IntentionName"];
            description = [NSString stringWithFormat:@"%@,%@,目前%@,希望在%@行业大展拳脚",[_item objectForKey:@"t_User_RealName"],[_item objectForKey:@"PositionName"],Intention,FoucsArea];
        }else{
            description = [NSString stringWithFormat:@"%@,%@,希望在%@行业大展拳脚",[_item objectForKey:@"t_User_RealName"],[_item objectForKey:@"PositionName"],FoucsArea];
        }
        
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
                               [self ShareIntegral:@"12"];
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
- (void)selectedAction:(UIButton *)sender{
    
    MyDynamicVC *dynamic = [[MyDynamicVC alloc]init];
    dynamic.type = 1;
    dynamic.guid = _Guid;
    dynamic.title = [NSString stringWithFormat:@"%@的动态",model.tUserRealName];
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:NO];
    
}
- (void)moreproject:(UIButton *)sender{
    
    MyProject2VC *project = [[MyProject2VC alloc]init];
    project.guid = _Guid;
    project.title = [NSString stringWithFormat:@"%@的项目",model.tUserRealName];
    project.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:project animated:NO];
}

- (void)compile:(UIBarButtonItem *)sender
{
    
    PersonInfomationVC *person =[[PersonInfomationVC alloc]init];
    person.title = @"编辑资料";
    person.hidesBottomBarWhenPushed = YES;
    person.HistoryWorkArray = [model.historyWork mutableCopy];
    NSString *beststring = @"";
    NSString *bestID = @"";
    for (int i=0; i<[[_item objectForKey:@"Best"] count]; i++) {
        NSDictionary *dict = [[_item objectForKey:@"Best"] objectAtIndex:i];
        NSString *best = [NSString stringWithFormat:@"%@",[dict objectForKey:@"BestName"]];
        NSString*ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"BestID"]];
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
    person.BestIDstr = bestID;
    person.type=1;
    person.BestStr = beststring;
    
    
    NSString *DomainS = @"";
    NSString *Id = @"";
    for (int i =0; i<[[_item objectForKey:@"FoucsArea"] count]; i++) {
        NSDictionary *dict = [[_item objectForKey:@"FoucsArea"] objectAtIndex:i];
        NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"FoucsName"]];
        NSString *domainID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"FoucsID"]];
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
    person.DomainIDstr = Id;
    person.type=1;
    person.DomainStr = DomainS;
    
    NSString *IntentionName = @"";
    NSString *IntentionID = @"";
    
    for (int i = 0; i<[[_item objectForKey:@"Intention"] count]; i++) {
        NSDictionary *dict = [[_item objectForKey:@"Intention"] objectAtIndex:i];
        NSString *Name = [dict objectForKey:@"IntentionName"];
        NSString *ID = [dict objectForKey:@"IntentionID"];
        if ([self isBlankString:IntentionName]) {
            IntentionName = Name;
        } else {
            IntentionName = [IntentionName stringByAppendingString:[NSString stringWithFormat:@" %@",Name]];
        }
        if ([self isBlankString:IntentionID]) {
            IntentionID = ID;
        } else {
            IntentionID = [IntentionID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.IntentionIDStr = IntentionID;
    person.IntentionName = IntentionName;
    person.type = 1;
    
    NSString *NowNeedName=@"";
    NSString *NowNeedID = @"";
    
    for (int i = 0; i<[[_item objectForKey:@"NowNeed"] count]; i++) {
        NSDictionary *dict = [[_item objectForKey:@"NowNeed"] objectAtIndex:i];
        NSString *Name = [dict objectForKey:@"NowNeedName"];
        NSString *ID =[dict objectForKey:@"NowNeedID"];
        
        if ([self isBlankString:NowNeedName]) {
            NowNeedName = Name;
        } else {
            NowNeedName = [NowNeedName stringByAppendingString:[NSString stringWithFormat:@" %@",Name]];
        }
        if ([self isBlankString:NowNeedID]) {
            NowNeedID = ID;
        }else{
            NowNeedID = [NowNeedID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
        }
    }
    person.NowNeedName = NowNeedName;
    person.NowNeedID = NowNeedID;
    person.type = 1;
    [self.navigationController pushViewController:person animated:NO];
    
}

#pragma mark - UIScrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
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
