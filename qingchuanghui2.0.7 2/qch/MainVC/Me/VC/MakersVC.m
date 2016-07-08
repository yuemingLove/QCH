//
//  MakersVC.m
//  qch
//
//  Created by 青创汇 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MakersVC.h"
#import "PersonDynamicCell.h"
#import "BaseInformationCell.h"
#import "DynamicstateVC.h"
#import "MyDynamicVC.h"
#import "PersonInfomationVC.h"
#import "CertificationVC.h"
#import "UINavigationBar+Background.h"
#import "ShowView.h"

@interface MakersVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,XHImageViewerDelegate>
{
    UIButton *careBtn;
    NSInteger ifPraise;
    PartnerResult *model;
}

@property (weak, nonatomic) UITableView *tableListView;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong)UIButton *certifiBtn;
@property (nonatomic,strong) NSMutableArray *imageViews;


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
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation MakersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.modalPresentationCapturesStatusBarAppearance=YES;

    [self createTableView];
    [self creatfootview];
    [self createBgImageView];
    if (![_Guid isEqualToString:UserDefaultEntity.uuid]) {
        [self createFooterBtnView];
    }


    self.view.backgroundColor = [UIColor whiteColor];

    
    if (![_Guid isEqualToString:UserDefaultEntity.uuid]) {
        UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
        self.navigationItem.rightBarButtonItem=shareView;
    }
    
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
    UIImage *image = [UIImage imageNamed:@"beijing_img"];
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
        [tableView setBackgroundColor:[UIColor whiteColor]];
        //tableView.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
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
        //tableView.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
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

- (void)creatfootview
{
    if ([_Guid isEqualToString:UserDefaultEntity.uuid]) {
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 310*PMBWIDTH)];
        footview.backgroundColor = [UIColor themeGrayColor];
        self.tableListView.tableFooterView = footview;
        UIImageView *DefaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(100*PMBWIDTH, 40*PMBWIDTH, ScreenWidth-200*PMBWIDTH, ScreenWidth-200*PMBWIDTH)];
        DefaultImg.image = [UIImage imageNamed:@"jisurenzheng_img"];
        DefaultImg.layer.cornerRadius = DefaultImg.height/2;
        DefaultImg.layer.masksToBounds = YES;
        [footview addSubview:DefaultImg];
        
        _certifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _certifiBtn.frame = CGRectMake(DefaultImg.left+5*PMBWIDTH, DefaultImg.bottom+15*PMBWIDTH, DefaultImg.width-5*PMBWIDTH, 30*PMBWIDTH);
        _certifiBtn.layer.cornerRadius = _certifiBtn.height/2;
        _certifiBtn.layer.masksToBounds = YES;
        _certifiBtn.titleLabel.font = Font(15);
        _certifiBtn.backgroundColor = TSEColor(161, 201, 240);
        [_certifiBtn setTitle:@"极速认证" forState:UIControlStateNormal];
        [_certifiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_certifiBtn addTarget:self action:@selector(certifi:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:_certifiBtn];
    }else{
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 310*PMBWIDTH)];
        footview.backgroundColor = [UIColor themeGrayColor];
        self.tableListView.tableFooterView = footview;
        
        UIImageView *DefaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(100*PMBWIDTH, 40*PMBWIDTH, ScreenWidth-200*PMBWIDTH, ScreenWidth-200*PMBWIDTH)];
        DefaultImg.image = [UIImage imageNamed:@"meiyouziliao_img"];
        DefaultImg.layer.cornerRadius = DefaultImg.height/2;
        DefaultImg.layer.masksToBounds = YES;
        [footview addSubview:DefaultImg];
        
        UILabel *DefaultLab = [[UILabel alloc]initWithFrame:CGRectMake(0, DefaultImg.bottom+15*PMBWIDTH, ScreenWidth, 15*PMBWIDTH)];
        DefaultLab.text = @"未认证身份，没有更多信息了～";
        DefaultLab.textColor = [UIColor lightGrayColor];
        DefaultLab.font = Font(15);
        DefaultLab.textAlignment = NSTextAlignmentCenter;
        [footview addSubview:DefaultLab];

    }
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
           
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (void)getData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:_Guid forKey:@"guid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpPartnerAction GetUserView:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:result];
            model = rpnc.result[0];
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            _imageViews=[NSMutableArray new];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*PMBWIDTH)/2, 64*PMBWIDTH,70*PMBWIDTH, 0)];
            [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            [_imageViews addObject:image];
            
            ifPraise = [model.ifFoucs integerValue];
            if (ifPraise==1) {
                [careBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            } else {
                [careBtn setTitle:@"关注" forState:UIControlStateNormal];
            }
            [self.tableListView reloadData];
            _detailLabel.text=[NSString stringWithFormat:@"%@      %@",model.positionName,model.tUserCommpany];
            if ([self isBlankString:model.tUserRealName]) {
                _nameLabel.text = @"游客";
            } else {
                _nameLabel.text=model.tUserRealName;
            }
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        BaseInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseInformationCell"];
        if (cell == nil) {
            cell = [[BaseInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseInformationCell"];
        }
        cell.model = model;
        cell.FansLab.text = model.fCount;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row==1){
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
        }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 45*PMBWIDTH;
    }else if (indexPath.row == 1) {
        if (model.topic.count==0) {
            return 0;
        }else{
            return 138*PMBWIDTH;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        NSArray *array = model.topic;
        if (array.count>0) {
            PartnerTopic *topic = array[0];
            DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
            dynamic.guid = topic.guid;
            [self.navigationController pushViewController:dynamic animated:NO];
        }
    }
}

- (void)selectedAction:(UIButton *)sender
{
    MyDynamicVC *dynamic = [[MyDynamicVC alloc]init];
    dynamic.type = 1;
    dynamic.guid = _Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:NO];
    
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

- (void)certifi:(UIButton *)sender
{
    
    CertificationVC *certifi = [[CertificationVC alloc]init];
    [self.navigationController pushViewController:certifi animated:NO];
}

- (void)compile:(UIBarButtonItem *)sender
{
    PersonInfomationVC *person =[[PersonInfomationVC alloc]init];
    person.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:person animated:NO];
}

- (void)share:(UIButton *)sender
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
    NSString *imgurl = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
    [img sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"logo"]];
    NSString *path=[NSString stringWithFormat:@"%@ShareUserInfo.html?Guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
    
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"创客分享"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:@"创客"
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
                                [self ShareIntegral:@"11"];
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

