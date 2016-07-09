//
//  ActivityDetailVC.m
//  qch
//
//  Created by 苏宾 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ActivityDetailVC.h"
#import "RootDynamicTalkClass.h"
#import "MoreBtnCell.h"
#import "ThemeCell.h"
#import "TalkViewCell.h"
#import "CarePersonListVC.h"
#import "NoMsgCell.h"
#import "UpLoadViewCell.h"
#import "MoreJoinCell.h"
#import "MakersVC.h"
#import "ParntDetailVC.h"
#import "QchpartnerVC.h"
#import "ActivityPayVC.h"
#import "SystemMessageVC.h"
#import "CertificateDetailVC.h"

@interface ActivityDetailVC ()<UITableViewDataSource,UITableViewDelegate,MoreJoinCellDelegate,UITextFieldDelegate,MoreBtnCellDelegate,UIScrollViewDelegate,TalkViewCellDelegate,CommitAlertViewDelegate,UIAlertViewDelegate>{
    
    UIImageView *bgkImageView;
    UILabel *titleLabel;
    
    UILabel *acticityUser;
    UILabel *acticityPrice;
    UILabel *consultTel;
    UILabel *acticityTime;
    UILabel *acticityAddress;
    
    UIButton *attionbtn;
    UIButton *joinBtn;
    
    //导航按钮：分享、收藏
    UIButton *shareBtn;
    UIButton *collectBtn;
    
    UIView *footView;
    
    //评论人Guid；
    NSString *fromGuid;
    
    UIView *talkView;
    
    NSString *applyGuid;
    

    //是否审核通过
    NSString *t_Activity_Audit;
    
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) PActivityModel *acticityModel;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *userlist;
@property (nonatomic,strong) NSMutableArray *talklist;

@end

@implementation ActivityDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"活动详情"];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_userlist!=nil) {
        _userlist=[[NSMutableArray alloc]init];
    }
    if (_talklist!=nil) {
        _talklist=[[NSMutableArray alloc]init];
    }
    
    fromGuid=@"";
    
    [self createBarBtn];
    [self createTableView];
    [self getData];
    
    if (_if_push) {
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)];
        self.navigationItem.leftBarButtonItem=leftItem;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activitysuccess:) name:@"activitysuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle:) name:@"quxiao" object:nil];
}

-(void)backItem:(id)sender{
    [ self .navigationController popToRootViewControllerAnimated: YES ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)activitysuccess:(NSNotification *)text{
    
    [self freePayAction];
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"activitysuccess" object:nil];
}

-(void)createBarBtn{
    
    shareBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.frame=CGRectMake(0, 0, 32, 32);
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    //给button添加委托方法，即点击触发的事件。
    [shareBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    collectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    collectBtn.frame=CGRectMake(0, 0, 32, 32);
    [collectBtn setImage:[UIImage imageNamed:@"care_normal"] forState:UIControlStateNormal];
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    //给button添加委托方法，即点击触发的事件。
    [collectBtn addTarget:self action:@selector(careClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *collectBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareBarButtonItem,collectBarButtonItem, nil];
    
}

-(void)createTableView{
    
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2);
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.scrollView.pagingEnabled =YES;
    [self.view addSubview:self.scrollView];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
    
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.scrollView addSubview:self.webView];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400*SCREEN_WHCALE)];
    headView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=headView;
    
    bgkImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    [bgkImageView setBackgroundColor:[UIColor grayColor]];
    [headView addSubview:bgkImageView];
    
    titleLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, bgkImageView.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, 20*SCREEN_WHCALE) color:[UIColor blackColor] font:Font(18) text:@"活动名称"];
    [headView addSubview:titleLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH, 8*SCREEN_WHCALE)];
    line.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line];
    
    UILabel *acticityName=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line.bottom+10*SCREEN_WHCALE, 60*SCREEN_WSCALE, 16*SCREEN_WHCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"主 办 方:"];
    [headView addSubview:acticityName];
    
    acticityUser=[self createLabelFrame:CGRectMake(acticityName.right+5*SCREEN_WSCALE,acticityName.top, SCREEN_WIDTH-85*SCREEN_WSCALE, acticityName.height) color:[UIColor blackColor] font:Font(14) text:@""];
    [headView addSubview:acticityUser];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, acticityName.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WHCALE)];
    line1.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line1];
    
    UILabel *acticityPriceLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line1.bottom+10*SCREEN_WHCALE, 60*SCREEN_WSCALE, 16*SCREEN_WHCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"活动费用:"];
    [headView addSubview:acticityPriceLabel];
    
    acticityPrice=[self createLabelFrame:CGRectMake(acticityPriceLabel.right+5*SCREEN_WSCALE,acticityPriceLabel.top, SCREEN_WIDTH-85*SCREEN_WSCALE, acticityName.height) color:[UIColor blackColor] font:Font(14) text:@""];
    [headView addSubview:acticityPrice];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, acticityPriceLabel.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WHCALE)];
    line2.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line2];
    
    UILabel *consultTelLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line2.bottom+10*SCREEN_WHCALE, 60*SCREEN_WSCALE, 16*SCREEN_WHCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"咨询电话:"];
    [headView addSubview:consultTelLabel];
    
    consultTel=[self createLabelFrame:CGRectMake(consultTelLabel.right+5*SCREEN_WSCALE,consultTelLabel.top, SCREEN_WIDTH-85*SCREEN_WSCALE, acticityName.height) color:[UIColor themeBlueTwoColor] font:Font(14) text:@""];
    [headView addSubview:consultTel];
    
    UIButton *telBtn=[[UIButton alloc]initWithFrame:consultTel.frame];
    [telBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:telBtn];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, consultTelLabel.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WHCALE)];
    line3.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line3];
    
    UILabel *acticityTimeLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line3.bottom+10*SCREEN_WHCALE, 60*SCREEN_WSCALE, 16*SCREEN_WHCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"活动时间:"];
    [headView addSubview:acticityTimeLabel];
    
    acticityTime=[self createLabelFrame:CGRectMake(acticityTimeLabel.right+5*SCREEN_WSCALE,acticityTimeLabel.top, SCREEN_WIDTH-85*SCREEN_WSCALE, acticityName.height) color:[UIColor blackColor] font:Font(14) text:@""];
    [headView addSubview:acticityTime];
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, acticityTimeLabel.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WHCALE)];
    line4.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line4];
    
    UILabel *acticityAddressLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line4.bottom+10*SCREEN_WHCALE, 60*SCREEN_WSCALE, 16*SCREEN_WHCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"活动地点:"];
    [headView addSubview:acticityAddressLabel];
    
    acticityAddress=[self createLabelFrame:CGRectMake(acticityAddressLabel.right+5*SCREEN_WSCALE,acticityAddressLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, acticityName.height) color:[UIColor blackColor] font:Font(14) text:@""];
    [headView addSubview:acticityAddress];
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(0, acticityAddressLabel.bottom+10*SCREEN_WHCALE, SCREEN_WIDTH, 8*SCREEN_WHCALE)];
    line5.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line5];
    
    footView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, 44)];
    footView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:footView];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5*SCREEN_WHCALE)];
    lab.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:lab];
    
    attionbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attionbtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 44);
    [attionbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attionbtn setTitle:@"我要评论" forState:UIControlStateNormal];
    attionbtn.titleLabel.font=Font(15);
    [attionbtn addTarget:self action:@selector(commitActivity) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:attionbtn];
    
    UILabel *xianlab = [[UILabel alloc]initWithFrame:CGRectMake(attionbtn.right, 10*SCREEN_WHCALE, 1*SCREEN_WSCALE, 44-20*SCREEN_WHCALE)];
    xianlab.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:xianlab];
    
    joinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame=CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44);
    joinBtn.titleLabel.font=Font(15);
    [footView addSubview:joinBtn];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        if(scrollView.contentOffset.y == 0){
            [self.tableView.mj_header beginRefreshing];
            footView.hidden=NO;
            
        }else if (scrollView.contentOffset.y==SCREEN_HEIGHT) {
            footView.hidden=YES;
        }
    }
}

-(void)getData{
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpActivityAction GetActivityView:self.guid userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PActivityModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
            _acticityModel=[_funlist objectAtIndex:0];
            t_Activity_Audit = _acticityModel.t_Activity_Audit;
            NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,_acticityModel.t_Activity_CoverPic];
            [bgkImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_3"]];
            [bgkImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            bgkImageView.contentMode =  UIViewContentModeScaleAspectFill;
            bgkImageView.clipsToBounds  = YES;
            
            titleLabel.text=_acticityModel.t_Activity_Title;
            acticityUser.text=_acticityModel.t_Activity_Holder;
            
            if ([_acticityModel.t_Activity_Fee isEqualToString:@"0.00"]) {
                acticityPrice.text=@"免费";
            } else {
                acticityPrice.text=[NSString stringWithFormat:@"￥%@",_acticityModel.t_Activity_Fee];
            }
            consultTel.text=_acticityModel.t_Activity_Tel;
            
            if ([_acticityModel.ifPraise isEqualToString:@"1"]) {
                [collectBtn setImage:[UIImage imageNamed:@"care_select"] forState:UIControlStateNormal];
            } else {
                [collectBtn setImage:[UIImage imageNamed:@"care_normal"] forState:UIControlStateNormal];
            }
            if ([_acticityModel.ifOver isEqualToString:@"1"]) {
                [joinBtn setTitle:@"已结束" forState:UIControlStateNormal];
                [joinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [joinBtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
            } else {
                if ([_acticityModel.ifApply isEqualToString:@"1"]) {
                    [joinBtn setTitle:@"已报名" forState:UIControlStateNormal];
                    [joinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [joinBtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    [joinBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                    [joinBtn setTitleColor:[UIColor themeBlueTwoColor] forState:UIControlStateNormal];
                    [joinBtn addTarget:self action:@selector(joinActivity:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            acticityTime.text=[NSString stringWithFormat:@"%@--%@",[self stringChangDate:_acticityModel.t_Activity_sDate],[self stringChangDate:_acticityModel.t_Activity_eDate]];
            
            acticityAddress.text=_acticityModel.t_Activity_Street;
            
            _userlist=(NSMutableArray *)[[dict objectForKey:@"result"][0] objectForKey:@"ApplyUsers"];
            
            NSString *Path=[NSString stringWithFormat:@"%@ActivityInstruction.html?Guid=%@",SERIVE_HTML,_acticityModel.Guid];
            NSURL *url = [NSURL URLWithString:Path];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            
            [self getTalkList];
            
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            _userlist=[[NSMutableArray alloc]init];
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            _funlist=[[NSMutableArray alloc]init];
            _userlist=[[NSMutableArray alloc]init];
            
        }
        [self.tableView reloadData];
    }];
}


-(void)getTalkList{
    
    NSMutableDictionary *talkdic = [[NSMutableDictionary alloc]init];
    [talkdic setObject:_acticityModel.Guid forKey:@"associateGuid"];
    [talkdic setObject:@"1" forKey:@"page"];
    [talkdic setObject:@"5" forKey:@"pagesize"];
    [talkdic setObject:[MyAes aesSecretWith:@"associateGuid"] forKey:@"Token"];
    [HttpDynamicAction dynamictalk:talkdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:result];
            NSMutableArray *array=[NSMutableArray new];
            array=[rdtc.result mutableCopy];
            _talklist=array;
        }else{
            _talklist=[[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 8*SCREEN_WHCALE;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([_talklist count]>0) {
                return [_talklist count]+2;
            } else {
                return 2;
            }
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80*SCREEN_WHCALE;
    }else if (indexPath.section==1){
        if ([_talklist count]>0) {
            if (indexPath.row==0) {
                return 38*SCREEN_WHCALE;
            }else{
                UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.height;
            }
        } else {
            return 36*SCREEN_WHCALE;
        }
    }else if (indexPath.section==2){
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 25*SCREEN_WHCALE;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%zi%zi",indexPath.section,indexPath.row];
    
    if (indexPath.section == 0) {
        
        MoreJoinCell *cell = (MoreJoinCell*)[tableView dequeueReusableCellWithIdentifier:@"MoreJoinCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"MoreJoinCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[MoreJoinCell class]]) {
                    cell = (MoreJoinCell *)oneObject;
                }
            }
        }
        NSString *numLabelText;
        if(![self isBlankString:_acticityModel.ApplyCount]){
            numLabelText=_acticityModel.ApplyCount;
            if (![self isBlankString:_acticityModel.t_Activity_LimitPerson]) {
                numLabelText=[numLabelText stringByAppendingFormat:@"/%@",_acticityModel.t_Activity_LimitPerson];
            } else {
                numLabelText=[numLabelText stringByAppendingFormat:@"/%@",@"0"];
            }
        }else{
            numLabelText=@"0";
            if (![self isBlankString:_acticityModel.t_Activity_LimitPerson]) {
                numLabelText=[numLabelText stringByAppendingFormat:@"/%@",_acticityModel.t_Activity_LimitPerson];
            } else {
                numLabelText=[numLabelText stringByAppendingFormat:@"/%@",@"0"];
            }
        }
        
        cell.numLabel.text=numLabelText;
        cell.joinDelegate=self;
        if ([_userlist count]>0) {
            [cell updateFrame:_userlist];
        }
        [cell.MoreBtn addTarget:self action:@selector(userInfoMore:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        if ([_talklist count]>0) {
            if (indexPath.row==0) {
                ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
                cell = [[ThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                
                return cell;
                
            }else if (indexPath.row==[_talklist count]+1){
                
                MoreBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreBtnCell"];
                cell = [[MoreBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.moreDelegate=self;
                
                return cell;
            } else {
                
                DynamicTalkModel *model = [_talklist objectAtIndex:indexPath.row-1];
                
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
    }else if(indexPath.section==2){
        
        UpLoadViewCell *cell = (UpLoadViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UpLoadViewCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"UpLoadViewCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[UpLoadViewCell class]]) {
                    cell = (UpLoadViewCell *)oneObject;
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return [[UITableViewCell alloc]init];
    
}

-(void)commitActivity{
    
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"活动评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}


-(void)updateTextViewData:(NSString *)text{
    
    NSMutableDictionary *commit = [[NSMutableDictionary alloc]init];
    [commit setObject:UserDefaultEntity.uuid forKey:@"fromUserGuid"];
    [commit setObject:text forKey:@"fromContent"];
    [commit setObject:_acticityModel.Guid forKey:@"associateGuid"];
    [commit setObject:[MyAes aesSecretWith:@"fromUserGuid"] forKey:@"Token"];
    [commit setObject:@"activity" forKey:@"type"];
    [commit setObject:fromGuid forKey:@"toUserGuid"];
    
    [HttpDynamicAction commonAddTalk:commit complete:^(id result, NSError *error) {
        
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]){
            fromGuid = @"";
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [self getTalkList];
        }else if([[result objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)cancle:(NSNotification *)text{
    
    fromGuid=@"";
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quxiao" object:nil];
}
-(void)CommentList:(MoreBtnCell*)cell{
    CommentListVC *commentList=[[CommentListVC alloc]init];
    commentList.Guid=_acticityModel.Guid;
    [self.navigationController pushViewController:commentList animated:YES];
}

-(void)noAction{

}

-(void)joinActivity:(id)sender{
    
    if ([_acticityModel.t_Activity_Fee isEqualToString:@"0.00"]) {
        [self freePayAction];
    } else {
        [HttpActivityAction IfApply:UserDefaultEntity.uuid activityGuid:_guid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict = result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"false"]) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"illegal"]){
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else{
                [self payActivity];
            }
        }];
    }
}

-(void)payActivity{
    
    NSString *payType=@"";
    
    [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
    [HttpAlipayAction AddOrder:_guid userGuid:UserDefaultEntity.uuid ordertype:2 paytype:payType money:_acticityModel.t_Activity_Fee name:_acticityModel.t_Activity_Title remark:_acticityModel.t_Activity_Title Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *param=[dict objectForKey:@"result"][0];
            
            NSString *orderNum=[param objectForKey:@"t_Order_No"];
            
            ActivityPayVC *activityPay=[[ActivityPayVC alloc]init];
            activityPay.price=[(NSNumber*)_acticityModel.t_Activity_Fee floatValue];
            activityPay.titlestr=_acticityModel.t_Activity_Title;
            activityPay.orderNum=orderNum;
            [self.navigationController pushViewController:activityPay animated:YES];
        }
    }];
}

-(void)freePayAction{
    
    [HttpActivityAction AddActivityApply:UserDefaultEntity.uuid activityGuid:_guid applyName:@"" applyMobile:@"" applyReamrk:_acticityModel.t_Activity_Title Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic = [dict objectForKey:@"result"][0];
            applyGuid = [dic objectForKey:@"Guid"];
            [joinBtn setTitle:@"已报名" forState:UIControlStateNormal];
            [joinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [joinBtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
            [self getData];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self fristAlertView];
            });
        } else if([[dict objectForKey:@"state"]isEqualToString:@"false"]) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
    
}

-(void)fristAlertView{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"报名成功" message:@"是否查看报名凭证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        CertificateDetailVC *certi = [[CertificateDetailVC alloc]init];
        certi.ApplyGuid = applyGuid;
        [self.navigationController pushViewController:certi animated:YES];
    }
}

-(void)shareClicked:(id)sender{
    if ([t_Activity_Audit isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"当前活动目前正在审核，暂时不能分享" maskType:SVProgressHUDMaskTypeBlack];
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
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,_acticityModel.t_Activity_CoverPic];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareActivity.html?Guid=%@&UserGuid=%@",SHARE_HTML,_acticityModel.Guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
        NSString *oneword = [[NSString stringWithFormat:@"%@",_acticityModel.OneWord] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (oneword.length>140) {
            oneword = [NSString stringWithFormat:@"%@",[oneword substringToIndex:140]];
        }
        NSString *title = [[NSString stringWithFormat:@"%@",_acticityModel.t_Activity_Title] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
        if (title.length>50) {
            title=[NSString stringWithFormat:@"%@",[title substringToIndex:50]];
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
                               
                           case SSDKResponseStateSuccess: {
                               [self ShareIntegral:@"2"];
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

-(void)careClicked:(id)sender{
    
    [HttpActivityAction AddOrCancelPraise:UserDefaultEntity.uuid activityGuid:_acticityModel.Guid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            if ([_acticityModel.ifPraise isEqualToString:@"0"]) {
                _acticityModel.ifPraise=@"1";
                [collectBtn setImage:[UIImage imageNamed:@"care_select"] forState:UIControlStateNormal];
            } else {
                _acticityModel.ifPraise=@"0";
                [collectBtn setImage:[UIImage imageNamed:@"care_normal"] forState:UIControlStateNormal];
            }
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求数据出错，请重新关注" maskType:SVProgressHUDMaskTypeBlack];
        }
        
        CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
        keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
        keyAnimation.calculationMode=kCAAnimationLinear;
        [collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
        
    }];
}

-(void)callPhone{
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",consultTel.text];
    UIWebView *callWebview =[[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)userInfoMore:(id)sender{
    CarePersonListVC *carePerson=[[CarePersonListVC alloc]init];
    carePerson.title=@"报名人数列表";
    carePerson.type=1;
    carePerson.model=_userlist;
    [self.navigationController pushViewController:carePerson animated:YES];
}

- (void)deletetalkClick:(TalkViewCell *)cell index:(NSInteger)index{
    
    DynamicTalkModel *model = [_talklist objectAtIndex:index];
    NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
    [deletedic setObject:model.guid forKey:@"talkGuid"];
    [deletedic setObject:[MyAes aesSecretWith:@"talkGuid"] forKey:@"Token"];
    [HttpDynamicAction talkdelete:deletedic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [self getTalkList];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row-1>=0 && indexPath.row<[_talklist count]+1) {
        DynamicTalkModel *model = [_talklist objectAtIndex:indexPath.row-1];
        if ([UserDefaultEntity.uuid isEqualToString:model.tTalkFromUserGuid]) {
            [SVProgressHUD showErrorWithStatus:@"自己不能回复自己" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }else{
            
            fromGuid=model.tTalkFromUserGuid;
            
            CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"活动评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
            
            commit.delegate = self;
            commit.placeholder.text=[NSString stringWithFormat:@"回复%@：",model.tUserRealName];
            [self.view addSubview:commit];
        }
    }
}

-(void)selectImageView:(MoreJoinCell*)cell index:(NSInteger)index{
    
    NSDictionary *dict=[_userlist objectAtIndex:index];
    
    if ([[dict objectForKey:@"ApplyUserStyle"] isEqualToString:@"2"]) {
        if ([[dict objectForKey:@"ApplyUserGuid"]isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = [dict objectForKey:@"ApplyUserGuid"];
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
        }else{
            if ([[dict objectForKey:@"ApplyUserAudit"] isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = [dict objectForKey:@"ApplyUserGuid"];
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = [dict objectForKey:@"ApplyUserGuid"];
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if ([[dict objectForKey:@"ApplyUserStyle"] isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = [dict objectForKey:@"ApplyUserGuid"];
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = [dict objectForKey:@"ApplyUserGuid"];
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }
    
    
}

@end
