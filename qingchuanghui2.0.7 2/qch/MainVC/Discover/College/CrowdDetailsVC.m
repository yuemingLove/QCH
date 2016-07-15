//
//  CrowdDetailsVC.m
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CrowdDetailsVC.h"
#import "RecommendCell.h"
#import "DetialsCell.h"
#import "TeacherCell.h"
#import "TalkViewCell.h"
#import "ActivityPayVC.h"
#import "ApliaySelectVC.h"
#import "TutorDetailVC.h"
#import "CourseViewVC.h"
@interface CrowdDetailsVC ()<UITableViewDelegate,UITableViewDataSource,CommitAlertViewDelegate,TalkViewCellDelegate,UIAlertViewDelegate>{
    CGRect playerFrame;
    UILabel *Informationlab;
    UILabel *countlab;
    UIProgressView *progressView;
    UILabel *Moneylab;
    UILabel *Supportlab;
    UILabel *Schedulelab;
    UILabel *OfflineMoney;
    NSMutableArray *SourceArray;
    NSString *touserguid;
    NSDictionary *FundCoursedic;
    UIButton *supportbtn;
    UIImageView *backgroundIV;

}

@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (strong, nonatomic) ZFPlayerView *playerView;

@end

@implementation CrowdDetailsVC

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
    self.title = @"众筹";
    touserguid = @"";
    playerFrame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width)/2);
    backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*9./16)];
    [self.view addSubview:backgroundIV];
    [self creattableview];
    [self creatheaderView];
    [self creatfootview];
    [self gettalk];

    
    if (!SourceArray) {
        SourceArray = [[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem=shareView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle:) name:@"quxiao" object:nil];
}

- (void)Playaction
{
    if ([[FundCoursedic objectForKey:@"isApply"]isEqualToString:@"0"]) {
        //[self.view bringSubviewToFront:backgroundIV];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否继续" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去支持", nil];
        [alert show];
    }else{
//    wmPlayer = [[WMPlayer alloc]initWithFrame:backgroundIV.bounds videoURLStr:@"http://192.168.1.77:8004/Attach/Media/1.mp4"];
        //[self.view sendSubviewToBack:backgroundIV];
        if (_playerView == nil) {
            // 设置播放前的占位图（需要在设置视频URL之前设置）
            self.playerView.placeholderImageName = @"nolive.jpg";
            self.playerView = [[ZFPlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
            self.playerView.videoURL = [NSURL URLWithString:_LiveURL];
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

    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        ApliaySelectVC *Apliay = [[ApliaySelectVC alloc]init];
        Apliay.hidesBottomBarWhenPushed = YES;
        if ([[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Online"]]) {
            Apliay.onlinemoney = @"0";
        }else{
            Apliay.onlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Online"];
        }
        if ([[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Offline"]]){
            Apliay.offlinemoney = @"0";
        }else{
            Apliay.offlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Offline"];
        }
        Apliay.Street = [FundCoursedic objectForKey:@"t_FundCourse_Street"];
        Apliay.guid = [FundCoursedic objectForKey:@"Guid"];
        Apliay.titlestr = [FundCoursedic objectForKey:@"T_FundCourse_Title"];
        [self.navigationController pushViewController:Apliay animated:YES];
    }
}
- (void)creattableview
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ScreenWidth*9./16, SCREEN_WIDTH, SCREEN_HEIGHT-ScreenWidth*9./16-49) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableviewlist = tableView;
    [self.view addSubview:tableView];
    [self setExtraCellLineHidden:self.tableviewlist];

}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)creatfootview
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49, SCREEN_WIDTH, 49)];
    footerView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footerView];
    
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

- (void)creatheaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 190*PMBWIDTH)];
    _tableviewlist.tableHeaderView = headerView;
    
    Informationlab = [[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, 5*PMBWIDTH, ScreenWidth-105*PMBWIDTH, 40*PMBWIDTH)];
    Informationlab.textColor = [UIColor blackColor];
    Informationlab.font = Font(15);
    Informationlab.numberOfLines = 0;
    [headerView addSubview:Informationlab];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Informationlab.right+5*PMBWIDTH, Informationlab.top+6*PMBWIDTH, 18*PMBWIDTH, 18*PMBWIDTH)];
    image.image = [UIImage imageNamed:@""];
    [headerView addSubview:image];
    
    countlab = [[UILabel alloc]initWithFrame:CGRectMake(image.left, image.top, 65*PMBWIDTH, 15*PMBWIDTH)];
    countlab.textColor = [UIColor lightGrayColor];
    countlab.font = Font(13);
    countlab.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:countlab];
    
    progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(Informationlab.left, Informationlab.bottom+5*PMBWIDTH, ScreenWidth-10*PMBWIDTH, 5*PMBWIDTH)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
    progressView.trackTintColor = [UIColor themeGrayColor];
    progressView.tintColor = [UIColor themeBlueColor];
    [headerView addSubview:progressView];
    
    CGFloat width = (ScreenWidth-20*PMBWIDTH)/3;
    Moneylab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, progressView.bottom+8*PMBWIDTH, width, 15*PMBWIDTH)];
    Moneylab.textAlignment = NSTextAlignmentLeft;
    Moneylab.textColor = [UIColor themeOrangeColor];
    Moneylab.font = Font(13);
    [headerView addSubview:Moneylab];
    
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(Moneylab.left, Moneylab.bottom+3*PMBWIDTH, width, Moneylab.height)];
    money.textColor = [UIColor lightGrayColor];
    money.text = @"已筹款";
    money.font = Font(13);
    money.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:money];
    
    Supportlab = [[UILabel alloc]initWithFrame:CGRectMake(Moneylab.right, Moneylab.top, width, Moneylab.height)];
    Supportlab.textAlignment = NSTextAlignmentCenter;
    Supportlab.textColor = [UIColor lightGrayColor];
    Supportlab.font = Font(13);
    [headerView addSubview:Supportlab];
    
    UILabel *count = [[UILabel alloc]initWithFrame:CGRectMake(Supportlab.left, Supportlab.bottom+3*PMBWIDTH, width, Supportlab.height)];
    count.text = @"支持数";
    count.textColor = [UIColor lightGrayColor];
    count.font = Font(13);
    count.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:count];
    
    Schedulelab = [[UILabel alloc]initWithFrame:CGRectMake(Supportlab.right, Supportlab.top, width, Supportlab.height)];
    Schedulelab.textColor = [UIColor lightGrayColor];
    Schedulelab.font = Font(13);
    Schedulelab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:Schedulelab];
    
    UILabel *support = [[UILabel alloc]initWithFrame:CGRectMake(Schedulelab.left, Schedulelab.bottom+3*PMBWIDTH, width, Schedulelab.height)];
    support.text = @"筹款进度";
    support.textColor = [UIColor lightGrayColor];
    support.font = Font(13);
    support.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:support];
    
    OfflineMoney = [[UILabel alloc]initWithFrame:CGRectMake(Moneylab.left, Moneylab.bottom+30*PMBWIDTH, 180*PMBWIDTH, 32*PMBWIDTH)];
    OfflineMoney.textColor = [UIColor themeRedColor];
    OfflineMoney.font = Font(16);
    OfflineMoney.numberOfLines=0;
    [headerView addSubview:OfflineMoney];
    
    supportbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    supportbtn.frame = CGRectMake(ScreenWidth-120*PMBWIDTH,OfflineMoney.top, 100*PMBWIDTH, 25*PMBWIDTH);
    supportbtn.titleLabel.font = Font(14);
    supportbtn.layer.borderColor = TSEColor(240, 140, 0).CGColor;
    supportbtn.layer.cornerRadius = supportbtn.height/2;
    supportbtn.layer.borderWidth = 1.0f;
    [headerView addSubview:supportbtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, supportbtn.bottom+15*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
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
        [cell setIntroductionText:[[FundCoursedic objectForKey:@"T_FundCourse_OneWord"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"]];
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
        cell.Remark.text = [[FundCoursedic objectForKey:@"T_Lecturer_Intor"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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
        tutor.Guid = [FundCoursedic objectForKey:@"T_LecturerGuid"];
        [self.navigationController pushViewController:tutor animated:YES];
        
    }else if (indexPath.section==2){
        
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
        CourseViewVC *course = [[CourseViewVC alloc]init];
        course.guid = [dict objectForKey:@"Guid"];
        [self.navigationController pushViewController:course animated:YES];
        
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
    [HttpCollegeAction GetFundCourseView:_guid userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            FundCoursedic= [dict objectForKey:@"result"][0];
            [SVProgressHUD dismiss];
            NSString *path = [[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[FundCoursedic objectForKey:@"T_FundCourse_Pic"]]stringByReplacingOccurrencesOfString:@"min" withString:@""];
            [backgroundIV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"logo1"]];
            [self Playaction];
            Informationlab.text = [FundCoursedic objectForKey:@"T_FundCourse_Title"];
            Moneylab.text = [NSString stringWithFormat:@"¥%@",[FundCoursedic objectForKey:@"hadMoney"]];
            
            Supportlab.text = [FundCoursedic objectForKey:@"count"];
            Schedulelab.text =[FundCoursedic objectForKey:@"percent"];
            float progValue = [(NSNumber*)[FundCoursedic objectForKey:@"hadMoney"]floatValue]/[(NSNumber*)[FundCoursedic objectForKey:@"T_FundCourse_Money"]floatValue];
            progressView.progress = progValue;
            if ([[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Online"]]) {
                OfflineMoney.text = [NSString stringWithFormat:@"线下:¥%@",[FundCoursedic objectForKey:@"T_PayMoney_Offline"]];
            }else if ([[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Offline"]]){
                OfflineMoney.text = [NSString stringWithFormat:@"线上:¥%@",[FundCoursedic objectForKey:@"T_PayMoney_Online"]];
            }else{
                OfflineMoney.text = [NSString stringWithFormat:@"线上:¥%@  线下:¥%@",[FundCoursedic objectForKey:@"T_PayMoney_Online"],[FundCoursedic objectForKey:@"T_PayMoney_Offline"]];
            }
            if ([(NSNumber *)[FundCoursedic objectForKey:@"isApply"]integerValue]==1) {
                [supportbtn setTitle:@"已支持" forState:UIControlStateNormal];
                [supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
                [supportbtn setTitleColor:[UIColor themeOrangeColor] forState:UIControlStateNormal];
                [supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
            }else if ([(NSNumber *)[FundCoursedic objectForKey:@"isApply"]integerValue]==2){
                [supportbtn setTitle:@"已完结" forState:UIControlStateNormal];
                [supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
                [supportbtn setTitleColor:[UIColor themeOrangeColor] forState:UIControlStateNormal];
                [supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [supportbtn setTitle:@"立即支持" forState:UIControlStateNormal];
                [supportbtn setTitleColor:[UIColor themeOrangeColor] forState:UIControlStateNormal];
                [supportbtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }

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
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
        [_tableviewlist reloadData];
        
    }];
}

- (void)noAction{
    
}

- (void)buttonAction:(UIButton *)sender
{
    ApliaySelectVC *Apliay = [[ApliaySelectVC alloc]init];
    Apliay.hidesBottomBarWhenPushed = YES;
    if ([[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Online"]]) {
        Apliay.onlinemoney = @"0";
    }else{
        Apliay.onlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Online"];
    }
    if ([[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Offline"]]){
        Apliay.offlinemoney = @"0";
    }else{
        Apliay.offlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Offline"];
    }
    Apliay.Street = [FundCoursedic objectForKey:@"t_FundCourse_Street"];
    Apliay.guid = [FundCoursedic objectForKey:@"Guid"];
    Apliay.titlestr = [FundCoursedic objectForKey:@"T_FundCourse_Title"];
    [self.navigationController pushViewController:Apliay animated:YES];
}

- (void)talkClicked:(UIButton *)sender
{
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"众筹课程评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
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
    [commit setObject:@"funcourse" forKey:@"type"];
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
    [talkdic setObject:@"50" forKey:@"pagesize"];
    [talkdic setObject:[MyAes aesSecretWith:@"associateGuid"] forKey:@"Token"];
    [HttpDynamicAction dynamictalk:talkdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:result];
            SourceArray = [rdtc.result mutableCopy];
          
        }else{
            
            SourceArray = [[NSMutableArray alloc]init];
            
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
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[FundCoursedic objectForKey:@"T_FundCourse_Pic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareCrowdfunding.html?guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
        NSString *oneword = [[NSString stringWithFormat:@"%@",[FundCoursedic objectForKey:@"T_FundCourse_OneWord"]]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (oneword.length>140) {
            oneword = [NSString stringWithFormat:@"%@",[oneword substringToIndex:140]];
        }
        NSString *title = [[NSString stringWithFormat:@"%@",[FundCoursedic objectForKey:@"T_FundCourse_Title"]]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
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
                               [self ShareIntegral:@"10"];
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

-(void)cancle:(NSNotification *)text{
    
    touserguid=@"";
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quxiao" object:nil];
    Liu_DBG(@"%@释放了",self.class);
    [self.playerView cancelAutoFadeOutControlBar];
}

@end
