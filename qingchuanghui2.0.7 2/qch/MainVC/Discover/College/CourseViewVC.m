//
//  CourseViewVC.m
//  
//
//  Created by 青创汇 on 16/4/20.
//
//

#import "CourseViewVC.h"
#import "RecommendCell.h"
#import "DetialsCell.h"
#import "TeacherCell.h"
#import "TalkViewCell.h"
#import "ActivityPayVC.h"
#import "ApliaySelectVC.h"
#import "TutorDetailVC.h"
#import "SelectCourseVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CourseViewVC ()<UITableViewDelegate,UITableViewDataSource,CommitAlertViewDelegate,TalkViewCellDelegate,UIAlertViewDelegate,SelectCourseVCDeleage>{
    CGRect playerFrame;
    NSMutableArray *SourceArray;
    NSString *touserguid;
    NSDictionary *FundCoursedic;
    UIButton *supportbtn;
    UILabel *Informationlab;
    
    UILabel *selectLabel;
    UILabel *scanCount;
    UILabel *selectCourseCount;
    UILabel *priceLabel;
    UILabel *priceLab;
    
    UIButton *payCourseBtn;
    
    UIImageView *backgroundIV;
    NSString *Liveurl;

    //是否需要支付
    NSInteger ifPay;
    NSString *associateGuid;
    NSString *money;
    
}
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (strong, nonatomic) ZFPlayerView *playerView;

@end

@implementation CourseViewVC

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
         */
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         */
    }
}
- (void)dealloc
{
    Liu_DBG(@"%@释放了",self.class);
    [self.playerView cancelAutoFadeOutControlBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getdata];
    
    playerFrame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width)*1/2);
    backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*9./16)];
    backgroundIV.image = [UIImage imageNamed:@"nolive.jpg"];
    [self.view addSubview:backgroundIV];

    [self creattableview];
    [self creatfootview];
    [self creatheaderview];
    [self gettalk];

    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    if (!SourceArray) {
        SourceArray = [[NSMutableArray alloc]init];
    }
    if (_selectArray !=nil) {
        _selectArray=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem=shareView;
    ///[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreen) name:@"fullScreenAction1" object:nil];
    ///[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smallScreen) name:@"smallScreenAction1" object:nil];
}

-(void)updateData:(NSMutableArray*)array{
    
    _selectArray=array;
    selectCourseCount.text=[NSString stringWithFormat:@"选了%ld节课",[array count]];
    float price=0.00;
    
    for (NSDictionary *dict in array) {
        price+=[(NSNumber*)[dict objectForKey:@"t_Course_Price"]floatValue];
        NSString*Guid = [dict objectForKey:@"Guid"];
        if ([self isBlankString:associateGuid]) {
            associateGuid = Guid;
        }else{
            associateGuid = [associateGuid stringByAppendingString:[NSString stringWithFormat:@",%@",Guid]];
        }
    }
    if(price==0.00){
        priceLab.text=[NSString stringWithFormat:@"￥0.00"];
        
    }else{
        priceLab.text=[NSString stringWithFormat:@"￥%.2f",price];
        money = [NSString stringWithFormat:@"%.2f",price];
    }
    
}


- (void)Playaction{
    
    if ([[FundCoursedic objectForKey:@"isApply"]isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"请先购买" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        Reachability *wifi=[Reachability reachabilityForLocalWiFi];
        if ([wifi currentReachabilityStatus] != NotReachable) {
            if (_playerView == nil) {
                // 设置播放前的占位图（需要在设置视频URL之前设置）
                self.playerView.placeholderImageName = @"nolive.jpg";
                self.playerView = [[ZFPlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
                self.playerView.videoURL = [NSURL URLWithString:Liveurl];
                [self.view addSubview:_playerView];
                //self.playerView.controlView.backBtn.hidden = YES;
                self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
                [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(0);
                    make.left.right.equalTo(self.view);
                    // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
                    make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
                }];
                [self.playerView autoPlayTheVideo];
                __weak typeof(self) weakSelf = self;
                self.playerView.goBackBlock = ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
            }
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前网络非Wi-Fi，是否继续播放" delegate:self cancelButtonTitle:@"暂停播放" otherButtonTitles:@"继续播放", nil];
            [alert show];
        }
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     if (buttonIndex==1) {
         if (_playerView == nil) {
             // 设置播放前的占位图（需要在设置视频URL之前设置）
             self.playerView.placeholderImageName = @"loading_bgView1";
             self.playerView = [[ZFPlayerView alloc] initWithFrame:backgroundIV.bounds];
             self.playerView.videoURL = [NSURL URLWithString:Liveurl];
             [self.view addSubview:_playerView];
             self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
             
             //[self.playerView autoPlayTheVideo];
         }

     }
}

- (void)creattableview{
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ScreenWidth*9./16, SCREEN_WIDTH, SCREEN_HEIGHT-ScreenWidth*9./16-49) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableviewlist = tableView;
    [self.view addSubview:tableView];
    [self setExtraCellLineHidden:self.tableviewlist];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).offset(ScreenWidth*9./16);
//        make.height.mas_equalTo(SCREEN_HEIGHT-ScreenWidth*9./16-49);
//    }];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)creatheaderview{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180*PMBWIDTH)];
    _tableviewlist.tableHeaderView = headerView;
    
    Informationlab = [[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, 5*PMBWIDTH, ScreenWidth-105*PMBWIDTH, 20*PMBWIDTH)];
    Informationlab.textColor = [UIColor blackColor];
    Informationlab.font = Font(15);
    Informationlab.numberOfLines = 0;
    [headerView addSubview:Informationlab];
    
    UIImageView *signImageView=[[UIImageView alloc]initWithFrame:CGRectMake(Informationlab.right+20, Informationlab.top+5, 12*SCREEN_WSCALE, 12*SCREEN_WSCALE)];
    [signImageView setImage:[UIImage imageNamed:@"scan"]];
    [headerView addSubview:signImageView];
    
    scanCount=[[UILabel alloc]initWithFrame:CGRectMake(signImageView.right+2, signImageView.top, 80*SCREEN_WSCALE, signImageView.height)];
    scanCount.font=Font(13);
    scanCount.textColor=[UIColor lightGrayColor];
    scanCount.textAlignment=NSTextAlignmentLeft;
    [headerView addSubview:scanCount];
    
    selectLabel=[self createLabelFrame:CGRectMake(Informationlab.left, Informationlab.bottom+10, 100, 20) color:[UIColor lightGrayColor] font:Font(14) text:@"选中的课程："];
    [headerView addSubview:selectLabel];
    
    selectCourseCount=[self createLabelFrame:CGRectMake(selectLabel.right, selectLabel.top, SCREEN_WIDTH-120, selectLabel.height) color:[UIColor lightGrayColor] font:Font(13) text:@""];
    [headerView addSubview:selectCourseCount];
    
    
    priceLabel=[self createLabelFrame:CGRectMake(selectLabel.left, selectLabel.bottom+10*SCREEN_WSCALE, 80, 20) color:[UIColor lightGrayColor] font:Font(14) text:@"总金额："];
    [headerView addSubview:priceLabel];
    
    priceLab=[self createLabelFrame:CGRectMake(priceLabel.right, priceLabel.top, 80, priceLabel.height) color:[UIColor redColor] font:Font(13) text:@""];
    [headerView addSubview:priceLab];
    
    payCourseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    payCourseBtn.frame=CGRectMake(SCREEN_WIDTH-120, priceLabel.top-10, 100, 26);
    [payCourseBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payCourseBtn setTitleColor:[UIColor themeOrangeColor] forState:UIControlStateNormal];
    payCourseBtn.titleLabel.font=Font(15);
    payCourseBtn.backgroundColor=[UIColor whiteColor];
    payCourseBtn.layer.cornerRadius=payCourseBtn.height/2;
    payCourseBtn.layer.borderWidth=1.0;
    payCourseBtn.layer.borderColor=[UIColor themeOrangeColor].CGColor;
    [payCourseBtn addTarget:self action:@selector(payCoursePrice:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:payCourseBtn];
    
    selectLabel.hidden=YES;
    selectCourseCount.hidden=YES;
    priceLabel.hidden=YES;
    priceLab.hidden=YES;
    payCourseBtn.hidden=YES;
    
    UIButton *selectCourseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectCourseBtn.frame=CGRectMake(15*SCREEN_WSCALE, payCourseBtn.bottom+15*SCREEN_WSCALE, SCREEN_WIDTH-30*SCREEN_WSCALE, 20*SCREEN_WSCALE);
    [selectCourseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    selectCourseBtn.layer.cornerRadius=selectCourseBtn.height/2;
    selectCourseBtn.titleLabel.font=Font(15);
    selectCourseBtn.backgroundColor=[UIColor themeGrayColor];
    [selectCourseBtn setTitle:@"系列课程>>" forState:UIControlStateNormal];
    [selectCourseBtn addTarget:self action:@selector(selectCourse:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:selectCourseBtn];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, selectCourseBtn.bottom+10, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    line.backgroundColor=[UIColor themeGrayColor];
    [headerView addSubview:line];
    
    NSArray *menuArray = @[@"详情",@"讲师",@"推荐",@"评论"];
    CGFloat wid = (ScreenWidth-30*PMBWIDTH)/4;
    for (int i=0; i<[menuArray count]; i++) {
        
        NSString *name=[menuArray objectAtIndex:i];
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(20*SCREEN_WSCALE+wid*i, line.bottom+15*PMBWIDTH, wid,20*PMBWIDTH)];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, wid-20*PMBWIDTH, 20*SCREEN_WSCALE);
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor themeBlueColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = button.height/2;
        button.layer.borderColor = [UIColor themeBlueColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.titleLabel.font = Font(14);
        
        button.tag = i;
        [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:button];
        [headerView addSubview:btnView];
        
    }

}

-(void)payCoursePrice:(UIButton*)sender {
    if ([money floatValue]==0) {
        return;
    }
    
    NSString *payType = @"";
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpAlipayAction AddOrder:associateGuid userGuid:UserDefaultEntity.uuid ordertype:4 paytype:payType money:money name:[FundCoursedic objectForKey:@"t_Course_Title"] remark:[FundCoursedic objectForKey:@"t_Course_Title"] Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *param=[dict objectForKey:@"result"][0];
            
            NSString *orderNum=[param objectForKey:@"t_Order_No"];
            
            ActivityPayVC *activityPay=[[ActivityPayVC alloc]init];
            activityPay.price=[(NSNumber*)money floatValue];
            activityPay.titlestr=[FundCoursedic objectForKey:@"t_Course_Title"];
            activityPay.orderNum=orderNum;
            activityPay.type=2;
            
            [self.navigationController pushViewController:activityPay animated:YES];
        }
    }];
}

-(void)selectCourse:(UIButton*)sender{
    
    SelectCourseVC *selectCourse=[[SelectCourseVC alloc]init];
    selectCourse.courseGroup=[FundCoursedic objectForKey:@"t_Course_Group"];
    selectCourse.selectArray=_selectArray;
    selectCourse.selectDeleage=self;
    [self.navigationController pushViewController:selectCourse animated:YES];

}

- (void)ButtonClicked:(UIButton *)sender{

    UIButton *button=(UIButton *)sender;
    if (button.tag == 3) {
        if ([SourceArray count]>0) {
            [_tableviewlist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else{
        [_tableviewlist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

- (void)creatfootview{
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49, SCREEN_WIDTH, 49)];
    footerView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footerView];
//    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.view);
//        make.height.mas_equalTo(49);
//    }];
    CGFloat width=(SCREEN_WIDTH-1)/2;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(width, 8, 1, 33)];
    line.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:line];
    
    UIButton *talkBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, width, 30)];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn setTitle:@"评论" forState:UIControlStateNormal];
    [talkBtn setImage:[UIImage imageNamed:@"yuetan"] forState:UIControlStateNormal];
    talkBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    talkBtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    
    [talkBtn addTarget:self action:@selector(talkClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:talkBtn];
    
    
    UIButton *sharebtn=[[UIButton alloc]initWithFrame:CGRectMake(width+1, talkBtn.top, width, 30)];
    [sharebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sharebtn setTitle:@"分享" forState:UIControlStateNormal];
    
    [sharebtn setImage:[UIImage imageNamed:@"fenxiang_btn"] forState:UIControlStateNormal];
    sharebtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    sharebtn.imageEdgeInsets = UIEdgeInsetsMake(0, talkBtn.titleLabel.width, 0, -talkBtn.titleLabel.width);
    
    [sharebtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sharebtn];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return [_funlist count];
    }else if (section==3){
        return SourceArray.count;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*PMBWIDTH)];
    headView.backgroundColor=[UIColor themeGrayColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 5*PMBWIDTH,ScreenWidth-10*PMBWIDTH , 20*PMBWIDTH)];
    title.textColor = [UIColor lightGrayColor];
    title.font = Font(15);
    [headView addSubview:title];
    if (section==0) {
        title.text = @"详情";
    }else if (section==1){
        title.text = @"讲师";
    }else if (section==2){
        title.text = @"推荐";
    }else if (section==3){
        title.text = @"评论";
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30*PMBWIDTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        DetialsCell *cell = (DetialsCell*)[tableView dequeueReusableCellWithIdentifier:@"DetialsCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"DetialsCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[DetialsCell class]]) {
                    cell = (DetialsCell *)oneObject;
                }
            }
        }
        [cell setIntroductionText:[[FundCoursedic objectForKey:@"t_Course_Instruction"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"]];
        cell.selectionStyle =UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section==1){
        
        TeacherCell *cell = (TeacherCell*)[tableView dequeueReusableCellWithIdentifier:@"TeacherCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeacherCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[TeacherCell class]]) {
                    cell = (TeacherCell *)oneObject;
                }
            }
        }
        if ([[FundCoursedic objectForKey:@"T_Lecturer_Pic"]isEqualToString:@""]) {
            
        }else{
            [cell.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[FundCoursedic objectForKey:@"T_Lecturer_Pic"]]] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        }
        cell.Name.text = [FundCoursedic objectForKey:@"T_Lecturer_Name"];
        cell.Remark.text = [[FundCoursedic objectForKey:@"T_Lecturer_Intor"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
        
    }else if (indexPath.section==2) {
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
        RecommendCell *cell = (RecommendCell*)[tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[RecommendCell class]]) {
                    cell = (RecommendCell *)oneObject;
                }
            }
        }
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Course_Pic"]];
        [cell.HeadImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
        cell.Title.text=[dict objectForKey:@"t_Course_Title"];
        cell.Remark.text=[[dict objectForKey:@"t_Course_Instruction"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        cell.selectionStyle = UITableViewCellAccessoryNone;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section==3){
        
        DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row];
        TalkViewCell *cell = (TalkViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TalkViewCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TalkViewCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[TalkViewCell class]]) {
                    cell = (TalkViewCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        
        [cell updateData:model];
        
        cell.deleteBtn.tag = indexPath.row;
        
        cell.talkdelegate = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        
        TutorDetailVC *tutor = [[TutorDetailVC alloc]init];
        tutor.Guid = [FundCoursedic objectForKey:@"t_Lecturer_Guid"];
        [self.navigationController pushViewController:tutor animated:YES];
        
    }else if (indexPath.section==2){
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
        CourseViewVC *sourseView=[[CourseViewVC alloc]init];
        sourseView.guid=[dict objectForKey:@"Guid"];
        [self.navigationController pushViewController:sourseView animated:YES];
        
    }else if (indexPath.section==3){
        
        DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row];
        touserguid = model.tTalkFromUserGuid;
        if ([touserguid isEqualToString:UserDefaultEntity.uuid]) {
            
            [SVProgressHUD showErrorWithStatus:@"自己不能回复自己" maskType:SVProgressHUDMaskTypeBlack];
            touserguid = @"";
        }else{
            CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
            commit.delegate = self;
            commit.placeholder.text=[NSString stringWithFormat:@"回复%@：",model.tUserRealName];
            [self.view addSubview:commit];
        }
        
    }
}

- (void)getdata{
    
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpCollegeAction GetCourseView:_guid userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            FundCoursedic= [dict objectForKey:@"result"][0];
            Liu_DBG(@"%@",FundCoursedic);
            [backgroundIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[FundCoursedic objectForKey:@"t_Course_Pic"]]] placeholderImage:[UIImage imageNamed:@"logo1"]];
            Liveurl = [NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[FundCoursedic objectForKey:@"t_Course_Src"]];
            [self Playaction];
            Informationlab.text = [FundCoursedic objectForKey:@"t_Course_Title"];
            scanCount.text=[FundCoursedic objectForKey:@"t_Course_Counts"];
            
            ifPay=[(NSNumber*)[FundCoursedic objectForKey:@"ifPay"]integerValue];
            
            if (ifPay==0) {
//                selectLabel.hidden=NO;
//                selectCourseCount.hidden=NO;
//                priceLabel.hidden=NO;
//                priceLab.hidden=NO;
//                payCourseBtn.hidden=NO;
                
                selectLabel.hidden=YES;
                selectCourseCount.hidden=YES;
                priceLabel.hidden=YES;
                priceLab.hidden=YES;
                payCourseBtn.hidden=YES;
                
            } else {
                
                selectLabel.hidden=YES;
                selectCourseCount.hidden=YES;
                priceLabel.hidden=YES;
                priceLab.hidden=YES;
                payCourseBtn.hidden=YES;
                
            }
            
            [SVProgressHUD dismiss];
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重新请求" maskType:SVProgressHUDMaskTypeBlack];
        }
        [_tableviewlist reloadData];

    }];
    
    [HttpCollegeAction GetRecommendCourse:TOP userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"top"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
        }
        [_tableviewlist reloadData];
        
    }];

}

- (void)talkClicked:(UIButton *)sender
{
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"课程评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}

-(void)updateTextViewData:(NSString *)text{
    
    if ([self isBlankString:text]) {
        
        [SVProgressHUD showErrorWithStatus:@"评论内容不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSMutableDictionary *commit = [[NSMutableDictionary alloc]init];
    [commit setObject:UserDefaultEntity.uuid forKey:@"fromUserGuid"];
    [commit setObject:text forKey:@"fromContent"];
    [commit setObject:_guid forKey:@"associateGuid"];
    [commit setObject:[MyAes aesSecretWith:@"fromUserGuid"] forKey:@"Token"];
    [commit setObject:@"course" forKey:@"type"];
    if ([self isBlankString:touserguid]) {
        [commit setObject:@"" forKey:@"toUserGuid"];
    }else{
        [commit setObject:touserguid forKey:@"toUserGuid"];
    }
    [HttpDynamicAction commonAddTalk:commit complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]){
            touserguid = @"";
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
    [talkdic setObject:_guid forKey:@"associateGuid"];
    [talkdic setObject:@"1" forKey:@"page"];
    [talkdic setObject:@"5" forKey:@"pagesize"];
    [talkdic setObject:[MyAes aesSecretWith:@"associateGuid"] forKey:@"Token"];
    [HttpDynamicAction dynamictalk:talkdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:result];
            SourceArray = [rdtc.result mutableCopy];
        }else{
            SourceArray=[[NSMutableArray alloc]init];
        }
        [self.tableviewlist reloadData];
    }];
}

//删除评论
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

- (void)shareAction:(UIButton *)sender
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[FundCoursedic objectForKey:@"t_Course_Pic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareCourse.html?guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
        NSString *oneword = [[NSString stringWithFormat:@"%@",[FundCoursedic objectForKey:@"t_Course_Instruction"]]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (oneword.length>140) {
            oneword = [NSString stringWithFormat:@"%@",[oneword substringToIndex:140]];
        }
        NSString *title = [[NSString stringWithFormat:@"%@",[FundCoursedic objectForKey:@"t_Course_Title"]]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"3"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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
