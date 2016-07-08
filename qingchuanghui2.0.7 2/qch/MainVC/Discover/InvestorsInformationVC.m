//
//  InvestorsInformationVC.m
//  qch
//
//  Created by 青创汇 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestorsInformationVC.h"
#import "QCHPositionViewController.h"
#import "DadeCell.h"
#import "MyInvestCell.h"
#import "PositionViewController.h"
#import "UIView+Extras.h"
#import "TextViewAlertView.h"
#import "CommitAlertView.h"

@interface InvestorsInformationVC ()<UITableViewDataSource,UITableViewDelegate,QchCityViewControllerDelegate,PositionDelegate,CommitAlertViewDelegate,SWTableViewCellDelegate,UITextFieldDelegate>
{
    NSArray *DataArray;
    UIView *HeaderView;
    UIImageView *headerimage;
    UIImageView *IconBtn;
    NSString *IconStr;
    UITextField *Namefield;
    UITextField *Moneyfield;
    UILabel *SexLab;
    UILabel *BirthdateLab;
    UILabel *CityLab;
    UITextField *Companyfield;
    UILabel *PositionLab;
    UILabel *informationlab;
    UILabel *DomainLab;
    UILabel *StageLab;
    NSString *positionId;
    NSMutableArray *DomainArray;
    NSMutableArray *StageArray;
    NSString *DomainID;
    NSString *StateID;
    UIImageView *addimg;
    UILabel *Addlab;
    UIImageView *PhotoImg;
    UILabel *CardLab;
    UIImageView *CardImg;
    NSString *CardStr;
    UILabel *Intentionlab;
    UILabel *Bestlab;
    UILabel *Attentionlab;
    UILabel *Nowneedlab;
    NSMutableArray *IntentionArray;
    NSString *IntentionID;
    NSMutableArray *BestArray;
    NSMutableArray *AttentionArray;
    NSString *BestID;
    NSString *AttentionID;
    NSMutableArray *RequirementArray;
    NSString *RequirementID;



}

@property (nonatomic,strong)UITableView *Incestorstableview;


@end

@implementation InvestorsInformationVC


- (void)viewDidLoad {
    [super viewDidLoad];
    CardStr=@"";
    // Do any additional setup after loading the view.
    DataArray = @[@"个人资料",@"姓名",@"性别",@"出生日期",@"地区",@"公司",@"职位",@"个人简介",@"创业偏好",@"创业意向",@"我最擅长",@"关注领域",@"现阶段需求",@"投资风格",@"投资领域",@"投资阶段",@"投资金额",@"投资案例"];
    [self creatHeaderImg];
    
    StateID = _StateIDstr;
    DomainID = _DomainIDstr;
    BestID = _Bestid;
    IntentionID = _purposeID;
    AttentionID = _Attentionid;
    RequirementID = _NowneedID;
    
    
    if (!DomainArray) {
        DomainArray = [[NSMutableArray alloc]init];
    }
    if (!StageArray) {
        StageArray = [[NSMutableArray alloc]init];
    }
    if (!_InvestArray) {
        _InvestArray=[[NSMutableArray alloc]init];
    }
    if (!IntentionArray) {
        IntentionArray = [[NSMutableArray alloc]init];
    }
    if (!BestArray) {
        BestArray = [[NSMutableArray alloc]init];
    }
    if (!AttentionArray) {
        AttentionArray = [[NSMutableArray alloc]init];
    }
    
    if (!RequirementArray) {
        RequirementArray = [[NSMutableArray alloc]init];
    }
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(SaveAction:)];
    [self.navigationItem setRightBarButtonItem:item];
    
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
}

- (void)backAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"信息尚未保存，确定离开吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okActon];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //禁用
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)creatHeaderImg{
    self.Incestorstableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.Incestorstableview.delegate = self;
    self.Incestorstableview.dataSource = self;
    [self.Incestorstableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.Incestorstableview];
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180*PMBWIDTH)];
    headerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HeaderView.width, 180*PMBWIDTH)];
    
    NSString *bgkPath=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,UserDefaultEntity.bgkPath];
    [headerimage sd_setImageWithURL:[NSURL URLWithString:bgkPath] placeholderImage:[UIImage imageNamed:@"beijing_img"]];
    
    //headerimage.image = [Utils GPUImageGaussianBlurImage:bgkPath];
    [HeaderView addSubview:headerimage];
    
    UIButton *bgkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bgkBtn.frame=headerimage.frame;
    [bgkBtn addTarget:self action:@selector(updateBgkImage:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderView addSubview:bgkBtn];
    
    
    IconBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*PMBWIDTH, 80*PMBWIDTH)];
    IconBtn.center = CGPointMake(ScreenWidth/2, 90*PMBWIDTH);
    IconBtn.layer.cornerRadius = IconBtn.height/2;
    IconBtn.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateIcon:)];
    IconBtn.userInteractionEnabled = YES;
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    [IconBtn sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    [IconBtn addGestureRecognizer:tap];
    [HeaderView addSubview:IconBtn];

    
    UILabel *tishiLab = [[UILabel alloc]initWithFrame:CGRectMake(0, IconBtn.bottom+15*PMBWIDTH, ScreenWidth, 14*PMBWIDTH)];
    tishiLab.text = @"点击更换头像";
    tishiLab.font = Font(14);
    tishiLab.textColor = [UIColor whiteColor];
    tishiLab.textAlignment = NSTextAlignmentCenter;
    [HeaderView addSubview:tishiLab];
    self.Incestorstableview.tableHeaderView = HeaderView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 18;
    }else if (section==1){
        return [_InvestArray count];
    }
    else if (section==2){
        return 1;
    }else if (section==3){
        return 2;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [DataArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = Font(14);
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0*PMBWIDTH, 44*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
        line.backgroundColor = [UIColor themeGrayColor];
        [cell addSubview:line];
        if (indexPath.row==0) {
            line.hidden=YES;
        }else if (indexPath.row==7) {
            line.hidden = YES;
        }else if (indexPath.row==8){
            line.hidden = YES;
        }else if (indexPath.row==13){
            line.hidden = YES;
        }else if (indexPath.row==17){
            line.hidden = YES;
        }
        if (indexPath.row==0) {
                cell.backgroundColor = [UIColor themeGrayColor];
        }else if (indexPath.row==1) {
            if (!Namefield) {
                Namefield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Namefield.font = Font(14);
                Namefield.textAlignment = NSTextAlignmentRight;
                Namefield.text = UserDefaultEntity.realName;
                [cell addSubview:Namefield];
            }
        }else if (indexPath.row==2){
            if (!SexLab) {
                SexLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                SexLab.textAlignment = NSTextAlignmentRight;
                SexLab.text = UserDefaultEntity.sex;
                SexLab.font = Font(14);
                [cell addSubview:SexLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==3){
            if (!BirthdateLab) {
                BirthdateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                BirthdateLab.font =Font(14);
                BirthdateLab.textAlignment = NSTextAlignmentRight;
                BirthdateLab.text = UserDefaultEntity.birDate;
                [cell addSubview:BirthdateLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==4){
            if (!CityLab) {
                CityLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                CityLab.font =Font(14);
                CityLab.textAlignment = NSTextAlignmentRight;
                CityLab.text = UserDefaultEntity.user_city;
                [cell addSubview:CityLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==5){
            if (!Companyfield) {
                Companyfield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Companyfield.font = Font(14);
                Companyfield.textAlignment = NSTextAlignmentRight;
                Companyfield.text = UserDefaultEntity.commpany;
                [cell addSubview:Companyfield];
            }
        }else if (indexPath.row==6){
            if (!PositionLab) {
                PositionLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                PositionLab.font = Font(14);
                PositionLab.textAlignment = NSTextAlignmentRight;
                PositionLab.text = UserDefaultEntity.positionName;
                positionId = UserDefaultEntity.positionId;
                [cell addSubview:PositionLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==7){
            if (!informationlab) {
                informationlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 18*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                informationlab.textAlignment = NSTextAlignmentRight;
                informationlab.font = Font(14);
                informationlab.text = UserDefaultEntity.remark;
                [cell addSubview:informationlab];
            }
        }else if (indexPath.row==8){
            cell.backgroundColor = [UIColor themeGrayColor];
        }else if (indexPath.row==9){
            if (!Intentionlab) {
                Intentionlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Intentionlab.textAlignment = NSTextAlignmentRight;
                Intentionlab.font = Font(14);
                [cell addSubview:Intentionlab];
            }
            NSString *intentionstr = @"";
            NSString *intentionID = @"";
            for (int i=0; i<[IntentionArray count]; i++) {
                NSDictionary *dict = [IntentionArray objectAtIndex:i];
                NSString *intention = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
                if ([self isBlankString:intentionstr]) {
                    intentionstr = intention;
                }else{
                    intentionstr = [intentionstr stringByAppendingString:[NSString stringWithFormat:@" %@",intention]];
                }
                if ([self isBlankString:intentionID]) {
                    intentionID = ID;
                }else{
                    intentionID = [intentionID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                }
            }
            if (_type==1) {
                Intentionlab.text = _purpose;
            }else if(_type==4){
                Intentionlab.text = intentionstr;
                IntentionID = intentionID;
                _purpose = intentionstr;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==10){
            if (!Bestlab) {
                Bestlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Bestlab.textAlignment = NSTextAlignmentRight;
                Bestlab.font = Font(14);
                [cell addSubview:Bestlab];
            }
            NSString *beststring = @"";
            NSString *bestID = @"";
            for (int i=0; i<[BestArray count]; i++) {
                NSDictionary *dict = [BestArray objectAtIndex:i];
                NSString *best = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString*ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
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
            if (_type==1) {
                Bestlab.text = _Best;
            }else if (_type==5){
                Bestlab.text = beststring;
                BestID = bestID;
                _Best = beststring;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==11){
            if (!Attentionlab) {
                Attentionlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Attentionlab.textAlignment = NSTextAlignmentRight;
                Attentionlab.font = Font(14);
                [cell addSubview:Attentionlab];
            }
            NSString *DomainS = @"";
            NSString *Id = @"";
            for (int i =0; i<[AttentionArray count]; i++) {
                NSDictionary *dict = [AttentionArray objectAtIndex:i];
                NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *domainID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
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
            if (_type==1) {
                Attentionlab.text = _Attentionstr;
            }else if (_type==6){
                Attentionlab.text =DomainS;
                AttentionID = Id;
                _Attentionstr = DomainS;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==12){
            if (!Nowneedlab) {
                Nowneedlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Nowneedlab.textAlignment = NSTextAlignmentRight;
                Nowneedlab.font = Font(14);
                [cell addSubview:Nowneedlab];
            }
            NSString *requirementstr = @"";
            NSString *requirementID = @"";
            for (int i=0; i<[RequirementArray count]; i++) {
                NSDictionary *dict = [RequirementArray objectAtIndex:i];
                NSString *string = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
                if ([self isBlankString:requirementstr]) {
                    requirementstr = string;
                }else{
                    requirementstr = [requirementstr stringByAppendingString:[NSString stringWithFormat:@" %@",string]];
                }
                if ([self isBlankString:requirementID]) {
                    requirementID =ID;
                }else{
                    requirementID = [requirementID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                    
                }
            }
            if (_type==1) {
                Nowneedlab.text = _NowneedStr;
            }else if (_type==7){
                Nowneedlab.text = requirementstr;
                RequirementID = requirementID;
                _NowneedStr = requirementstr;
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==13){
            cell.backgroundColor = [UIColor themeGrayColor];
        }else if (indexPath.row==14){
            if (!DomainLab) {
                DomainLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                DomainLab.font = Font(14);
                DomainLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:DomainLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *domainstring = @"";
            NSString *domainID = @"";
            for (int i=0; i<[DomainArray count]; i++) {
                NSDictionary *dict = [DomainArray objectAtIndex:i];
                NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
                if ([self isBlankString:domainstring]) {
                    domainstring = domain;
                }else{
                    domainstring = [domainstring stringByAppendingString:[NSString stringWithFormat:@" %@",domain]];
                }
                if ([self isBlankString:domainID]) {
                    domainID = ID;
                }else{
                    domainID = [domainID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                }
            }
            if (_type==1) {
                DomainLab.text = _DomainStr;
            }else if(_type==2){
                DomainID = domainID;
                DomainLab.text = domainstring;
                _DomainStr = domainstring;
            }
        }else if (indexPath.row==15){
            if (!StageLab) {
                StageLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                StageLab.font =Font(14);
                StageLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:StageLab];
            }
            NSString *stagestring = @"";
            NSString *stageID = @"";
            for (int i=0; i<[StageArray count]; i++) {
                NSDictionary *dict = [StageArray objectAtIndex:i];
                NSString *stage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
                if ([self isBlankString:stagestring]) {
                    stagestring = stage;
                }else{
                    stagestring = [stagestring stringByAppendingString:[NSString stringWithFormat:@" %@",stage]];
                }
                if ([self isBlankString:stageID]) {
                    stageID = ID;
                }else{
                    stageID = [stageID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                }
            }
            if (_type==1) {
                StageLab.text = _StateStr;
            }else if(_type==3){
                StateID = stageID;
                StageLab.text = stagestring;
                _StateStr = stagestring;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row==16){
            if (!Moneyfield) {
                Moneyfield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Moneyfield.textAlignment = NSTextAlignmentRight;
                Moneyfield.font = Font(14);
                Moneyfield.text = UserDefaultEntity.t_User_InvestMoney;
                if (_IforNo==NO) {
                    Moneyfield.userInteractionEnabled=NO;
                }else{
                    Moneyfield.userInteractionEnabled=YES;
                }
                [cell addSubview:Moneyfield];
                
            }
        }else if (indexPath.row==17){
            cell.backgroundColor = [UIColor themeGrayColor];
        }
        return cell;
    }else if (indexPath.section==1){
        
        NSDictionary *dict=[_InvestArray objectAtIndex:indexPath.row];
        
        MyInvestCell *cell = (MyInvestCell*)[tableView dequeueReusableCellWithIdentifier:@"MyInvestCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"MyInvestCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[MyInvestCell class]]) {
                    cell = (MyInvestCell *)oneObject;
                }
            }
        }
        cell.tag=indexPath.row;
        
        NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Invest_Pic"]];
        [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        
        cell.nameLabel.text = [dict objectForKey:@"t_Invest_Project"];
        NSDate *date = [DateFormatter stringToDateCustom:[dict objectForKey:@"t_Invest_Date"] formatString:def_YearMonthDayHourMinuteSec_];
        NSString *Date = [DateFormatter dateToStringCustom:date formatString:def_YearMobth];

        cell.timeLabel.text=Date;
        NSString *StageString;
        for (int i=0; i<[[dict objectForKey:@"InvestPhase"] count]; i++) {
            NSDictionary *item = [[dict objectForKey:@"InvestPhase"] objectAtIndex:i];
            NSString *stage =[item objectForKey:@"InvestPhaseName"];
            if ([self isBlankString:StageString]) {
                StageString = stage;
            }else{
                StageString = [StageString stringByAppendingString:[NSString stringWithFormat:@"  %@",stage]];
            }
        }
        cell.statusLabel.text=StageString;
        
        cell.delegate=self;
        if (_IforNo==YES) {
            [cell setRightUtilityButtons: [self rightButtons]];
        }else if (_IforNo==NO){
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section==2){
        
        DadeCell *cell = (DadeCell*)[tableView dequeueReusableCellWithIdentifier:@"DadeCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DadeCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[DadeCell class]]) {
                    cell = (DadeCell *)oneObject;
                }
            }
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==3){
        
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            cell.textLabel.text = @"上传名片";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = Font(14);
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor themeGrayColor];
            return cell;
            
        }else if (indexPath.row==1){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell10"];
            }
            if (!PhotoImg) {
                PhotoImg = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-50*PMBWIDTH)/2, 70*PMBWIDTH, 50*PMBWIDTH, 50*PMBWIDTH)];
                PhotoImg.image = [UIImage imageNamed:@"photo_btn"];
                [cell addSubview:PhotoImg];
            }
            if (!CardLab) {
                CardLab = [[UILabel alloc]initWithFrame:CGRectMake(0, PhotoImg.bottom+5*PMBWIDTH, ScreenWidth, 14*PMBWIDTH)];
                CardLab.text = @"添加名片";
                CardLab.textColor = [UIColor lightGrayColor];
                CardLab.textAlignment = NSTextAlignmentCenter;
                CardLab.font = Font(14);
                [cell addSubview:CardLab];
            }
            if (!CardImg) {
                CardImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200*PMBWIDTH)];
                if (![self isBlankString:UserDefaultEntity.t_User_BusinessCard]) {
                    [CardImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,UserDefaultEntity.t_User_BusinessCard]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        NSData *imageData = [self imageWithImage:CardImg.image scaledToSize:CGSizeMake(ScreenWidth, 200*PMBWIDTH)];
                        CardStr = [CommonDes base64EncodedStringFrom:imageData];
                    }];
                }else{
                    CardStr = @"";
                }
                [cell addSubview:CardImg];
            }
                cell.selectionStyle =UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 30*PMBWIDTH;
        }else if (indexPath.row==8){
            return 30*PMBWIDTH;
        }else if (indexPath.row==13){
            return 30*PMBWIDTH;
        }else if (indexPath.row==17){
            return 30*PMBWIDTH;
        }else{
            return 45*PMBWIDTH;
        }
    }else if (indexPath.section==1){
        return 80*PMBWIDTH;
    }
    else if (indexPath.section==2){
        return 90*PMBWIDTH;
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            return 30*PMBWIDTH;
        }else if(indexPath.row==1){
            return 200*PMBWIDTH;
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            [BlockActionSheet showActionSheetWithTitle:@"性别" block:^(BlockActionSheet *clickView, int index) {
                NSString *title = [clickView buttonTitleAtIndex:index];
                if ([title isEqualToString:@"男"]) {
                    SexLab.text = title;
                }else if ([title isEqualToString:@"女"]) {
                    SexLab.text = title;
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            
        }else if (indexPath.row==3) {
            //隐藏键盘
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"出生日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(BirthdateSelected:birth:) origin:BirthdateLab];
            datePicker.minuteInterval = 5;
            [datePicker showActionSheetPicker];
        }else if (indexPath.row==4){
            QchCityViewController *selectcity = [[QchCityViewController alloc]init];
            selectcity.cityDelegate = self;
            selectcity.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:selectcity animated:YES];
        }else if (indexPath.row==6){
            PositionViewController *position = [[PositionViewController alloc]init];
            position.positonDelegate = self;
            [self.navigationController pushViewController:position animated:YES];
        }else if (indexPath.row==7){
            CommitAlertView *showView=[[CommitAlertView alloc]initWithView:@"填写描述" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textViewPlaceholder:informationlab.text];
            showView.delegate = self;
            [self.view addSubview:showView];

        }else if (indexPath.row==9){
            BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
            best.Byid = 1362;
            _type=4;
            best.selectStr = _purpose;
            [best returnArray:^(NSArray *SelectedArray) {
                IntentionArray = [SelectedArray mutableCopy];
                [self.Incestorstableview reloadData];
            }];
            [self.navigationController pushViewController:best animated:YES];
        }else if (indexPath.row==10){
            BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
            best.Byid = 81;
            _type=5;
            best.selectStr = _Best;
            [best returnArray:^(NSArray *SelectedArray) {
                BestArray = [SelectedArray mutableCopy];
                [self.Incestorstableview reloadData];
            }];
            [self.navigationController pushViewController:best animated:YES];
        }else if (indexPath.row==11){
            BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
            best.Byid = 80;
            _type=6;
            best.selectStr = _Attentionstr;
            [best returnArray:^(NSArray *SelectedArray) {
                AttentionArray = [SelectedArray mutableCopy];
                [self.Incestorstableview reloadData];
            }];
            [self.navigationController pushViewController:best animated:YES];

        }else if (indexPath.row==12){
            BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
            best.Byid = 1361;
            _type=7;
            best.selectStr = _NowneedStr;
            [best returnArray:^(NSArray *SelectedArray) {
                RequirementArray = [SelectedArray mutableCopy];
                [self.Incestorstableview reloadData];
            }];
            [self.navigationController pushViewController:best animated:YES];

        }
        else if(indexPath.row==14){
            if (_IforNo==NO) {
                [SVProgressHUD showErrorWithStatus:@"暂不支持修改" maskType:SVProgressHUDMaskTypeBlack];
            }else{
                BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
                best.Byid=94;
                best.selectStr = _DomainStr;
                _type=2;
                [self.navigationController pushViewController:best animated:YES];
                [best returnArray:^(NSArray *SelectedArray) {
                    DomainArray = [SelectedArray mutableCopy];
                    [self. Incestorstableview reloadData];
                }];
            }
        }else if (indexPath.row == 15){
            if (_IforNo==NO) {
                [SVProgressHUD showErrorWithStatus:@"暂不支持修改" maskType:SVProgressHUDMaskTypeBlack];
            }else{
                BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
                best.Byid=95;
                _type=3;
                best.selectStr = _StateStr;
                [self.navigationController pushViewController:best animated:YES];
                [best returnArray:^(NSArray *SelectedArray) {
                    StageArray = [SelectedArray mutableCopy];
                    [self. Incestorstableview reloadData];
                }];
            }
            }
    }else if (indexPath.section==2){
        if (_IforNo==NO) {
            [SVProgressHUD showErrorWithStatus:@"暂不支持修改" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            InvestorsCaseVC *casevc = [[InvestorsCaseVC alloc]init];
            casevc.hidesBottomBarWhenPushed = YES;
            [casevc returnArray:^(NSMutableArray *InvestCase) {
                _InvestArray = InvestCase;
                [self.Incestorstableview reloadData];
            }];
            [self.navigationController pushViewController:casevc animated:YES];
        }
        
    }else if (indexPath.section==3){
        if (indexPath.row==1) {
            if (_IforNo==NO) {
                [SVProgressHUD showErrorWithStatus:@"暂不支持修改" maskType:SVProgressHUDMaskTypeBlack];
            }else{
            [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
                if(image != nil){
                    NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(ScreenWidth, 200*PMBWIDTH)];
                    CardStr = [CommonDes base64EncodedStringFrom:imageData];
                    CardImg.image = image;
                }
            }];
            }
        }
    }
}

- (NSArray *)rightButtons{
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [self.Incestorstableview indexPathForCell:cell];
    NSDictionary *model=[_InvestArray objectAtIndex:indexPath.row];
    
    [self delete:[model objectForKey:@"Guid"]];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (int i=0; i<[_InvestArray count]; i++) {
        NSDictionary *dict=[_InvestArray objectAtIndex:i];
        if (i!=indexPath.row) {
            [array addObject:dict];
        }
    }
    _InvestArray=array;
    [self.Incestorstableview reloadData];

}

-(void)updateTextViewData:(NSString *)text{
    if (text.length<10) {
        [SVProgressHUD showErrorWithStatus:@"个人描述限制最少10个字" maskType:SVProgressHUDMaskTypeBlack];
        informationlab.text=text;
    }else{
        informationlab.text=text;
    }
    
}

- (void)delete:(NSString*)guId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:guId forKey:@"guid"];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
    [HttpPartnerAction DelInvestCase:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)BirthdateSelected:(NSDate *)selectedTime birth:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[dateFormatter stringFromDate:selectedTime];
    [element setText:date];
}

- (void)SaveAction:(id)sender{
    

    if ([self isBlankString:IconStr]&[self isBlankString:UserDefaultEntity.headPath]) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:SexLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请选择性别" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:BirthdateLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请完善出生日期" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Namefield.text]){
       [SVProgressHUD showErrorWithStatus:@"请填写姓名" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Namefield.text.length>10){
       [SVProgressHUD showErrorWithStatus:@"姓名限制10个字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:CityLab.text]){
       [SVProgressHUD showErrorWithStatus:@"请选择城市" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Companyfield.text]){
        [SVProgressHUD showErrorWithStatus:@"请填写公司名称" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Companyfield.text.length>20){
        [SVProgressHUD showErrorWithStatus:@"公司名称限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:PositionLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请选择职位" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:informationlab.text]){
        [SVProgressHUD showErrorWithStatus:@"请完善个人简介" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:IntentionID]){
        [SVProgressHUD showErrorWithStatus:@"请选择创业意向" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:BestID]){
        [SVProgressHUD showErrorWithStatus:@"请选择我最擅长" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:AttentionID]){
        [SVProgressHUD showErrorWithStatus:@"请选择关注领域" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:RequirementID]){
        [SVProgressHUD showErrorWithStatus:@"请选择现阶段需求" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:DomainID]){
        [SVProgressHUD showErrorWithStatus:@"请选择投资领域" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:StateID]){
        [SVProgressHUD showErrorWithStatus:@"请选择投资阶段" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([_InvestArray count]==0){
        [SVProgressHUD showErrorWithStatus:@"请添加投资案例" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:CardStr]){
        [SVProgressHUD showErrorWithStatus:@"请上传名片" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Moneyfield.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入投资金额" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Moneyfield.text.length>20){
        [SVProgressHUD showErrorWithStatus:@"请输入合理的投资金额" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([informationlab.text length]<10){
        [SVProgressHUD showErrorWithStatus:@"个人描述至少填写10个字" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showWithStatus:@"上传中……" maskType:SVProgressHUDMaskTypeBlack];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        if (_IforNo==YES) {
            [dict setObject:@"2" forKey:@"userStyle"];
        }else if (_IforNo==NO){
             [dict setObject:@"" forKey:@"userStyle"];
        }
        [dict setObject:Namefield.text forKey:@"realName"];
        [dict setObject:CityLab.text forKey:@"city"];
        [dict setObject:Companyfield.text forKey:@"commpany"];
        [dict setObject:positionId forKey:@"position"];
        [dict setObject:SexLab.text forKey:@"sex"];
        [dict setObject:BirthdateLab.text forKey:@"birth"];
        [dict setObject:informationlab.text forKey:@"remark"];
        [dict setObject:AttentionID forKey:@"focusarea"];
        [dict setObject:BestID forKey:@"best"];
        [dict setObject:DomainID forKey:@"investarea"];
        [dict setObject:StateID forKey:@"investphase"];
        [dict setObject:Moneyfield.text forKey:@"investmoney"];
        [dict setObject:RequirementID forKey:@"nowneed"];
        [dict setObject:IntentionID forKey:@"intention"];
        [dict setObject:@"" forKey:@"base64Pic"];
        [dict setObject:CardStr forKey:@"base64CardPic"];
        [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpPartnerAction CompleteUserVersion2:dict complete:^(id result, NSError *error) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                NSArray *array = [result objectForKey:@"result"];
                NSDictionary *dict=array[0];
                UserDefaultEntity.user_style = [dict objectForKey:@"t_User_Style"];
                UserDefaultEntity.realName = [dict objectForKey:@"t_User_RealName"];
//                UserDefaultEntity.audit_type = [dict objectForKey:@"t_UserStyleAudit"];
                UserDefaultEntity.remark = [[dict objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.headPath = [dict objectForKey:@"t_User_Pic"];
                UserDefaultEntity.commpany = [dict objectForKey:@"t_User_Commpany"];
                UserDefaultEntity.positionName = [dict objectForKey:@"PositionName"];
                UserDefaultEntity.positionId = [dict objectForKey:@"t_User_Position"];
                UserDefaultEntity.user_city = [dict objectForKey:@"t_User_City"];
                UserDefaultEntity.birDate = [dict objectForKey:@"t_User_Birth"];
                UserDefaultEntity.sex = [dict objectForKey:@"t_User_Sex"];
                UserDefaultEntity.t_User_BusinessCard = [dict objectForKey:@"t_User_BusinessCard"];
                UserDefaultEntity.t_User_InvestMoney = [dict objectForKey:@"t_User_InvestMoney"];
                UserDefaultEntity.bgkPath=[dict objectForKey:@"t_BackPic"];
                UserDefaultEntity.NowNeed = [NSString stringWithFormat:@"%lu",[[dict objectForKey:@"NowNeed"]count]];
                [UserDefault saveUserDefault];
                if (_IforNo==NO) {
                    [SVProgressHUD showSuccessWithStatus:@"成功" maskType:SVProgressHUDMaskTypeBlack];
                }else if (_IforNo==YES){
                    [SVProgressHUD showSuccessWithStatus:@"信息提交成功,请等待审核" maskType:SVProgressHUDMaskTypeBlack];
                }

                [self.navigationController popToRootViewControllerAnimated:YES];

            }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }

        }];
        
    }
}

-(void)selectCityData:(NSString *)city{
    CityLab.text = city;
}
-(void)selectPosition:(NSDictionary*)dict{
    PositionLab.text=[dict objectForKey:@"t_Style_Name"];
    positionId=[dict objectForKey:@"Id"];
}
- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateIcon:(UIButton *)sender{
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(80*PMBWIDTH, 80*PMBWIDTH)];
            NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
            
            [dic setObject:imageStr forKey:@"base64Pic"];
            [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
            
            [HttpLoginAction updateImage:dic complete:^(id result, NSError *error) {
                
                if (error==nil) {
                    NSString *imageurl=[result objectForKey:@"t_User_Pic"];
                    if (![self isBlankString:imageurl]) {
                        IconStr=imageurl;
                        UserDefaultEntity.headPath=imageurl;
                        [UserDefault saveUserDefault];
                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,imageurl]];
//                        [IconBtn sd_setImageWithURL:url forState:UIControlStateNormal];
                        [IconBtn sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading_1"]];
                    }
                }
            }];
        }
    }];

}
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}


-(void)updateBgkImage:(id)sender{
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            [self submit:image];
        }
    }];
}

-(void)submit:(UIImage*)image{
    
    NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(headerimage.frame.size.width, headerimage.frame.size.height)];
    
    NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    
    [dic setObject:imageStr forKey:@"base64Pic"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpLoginAction EditBackPic:dic complete:^(id result, NSError *error) {
        if (error==nil) {
            if (![self isBlankString:result]) {
                UserDefaultEntity.bgkPath=result;
                [UserDefault saveUserDefault];
                NSString *url=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,result];
                [headerimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"beijing_img"]];
            }
        }
    }];
}


@end
