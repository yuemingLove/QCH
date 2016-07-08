//
//  PersonInfomationVC.m
//  qch
//
//  Created by 青创汇 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PersonInfomationVC.h"
#import "WorkExperienceVC.h"
#import "QCHPositionViewController.h"
#import "PositionViewController.h"
#import "UIView+Extras.h"
#import "TextViewAlertView.h"
//#import "ShowAlertView.h"
#import "CommitAlertView.h"

@interface PersonInfomationVC ()<UITableViewDelegate,UITableViewDataSource,QchCityViewControllerDelegate,PositionDelegate,CommitAlertViewDelegate>
{
    UIView *HeaderView;
    UIImageView *headerimage;
    UIImageView *IconBtn;
    NSArray *DataArray;
    UITextField *Namefield;
    UILabel *BirthdateLab;
    UILabel *CityLab;
    UITextField *Companyfield;
    UILabel *PositionLab;
    UILabel *informationLab;
    NSString *IconStr;
    UILabel *FocusareaLab;
    UILabel *BestLab;
    UILabel *Addlab;
    UIImageView *addimg;
    NSString *BestID;
    NSString *DomainID;
    NSString *positionId;
    NSString *IntentionID;
    NSString *RequirementID;
    UILabel *SexLab;
    NSMutableArray *BestArray;
    NSMutableArray *DomainArray;
    NSMutableArray *IntentionArray;
    NSMutableArray *RequirementArray;
    NSString *EDate;
    UILabel *Intentionlab;
    UILabel *Requirementlab;

}

@property (nonatomic,strong)UITableView *PersonInformationtableview;
@property (nonatomic,strong)NSMutableArray *cityList;

@end

@implementation PersonInfomationVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHotCity];
    [self creatHeaderImg];
    DataArray = @[@"个人资料",@"姓名",@"性别",@"出生日期",@"地区",@"公司",@"职位",@"个人描述"];
    
    if (!_HistoryWorkArray) {
        _HistoryWorkArray = [[NSMutableArray alloc]init];
    }
    if (!BestArray) {
        BestArray = [[NSMutableArray alloc]init];
    }
    if (!DomainArray) {
        DomainArray = [[NSMutableArray alloc]init];
    }
    if (!IntentionArray) {
        IntentionArray = [[NSMutableArray alloc]init];
    }
    if (!RequirementArray) {
        RequirementArray = [[NSMutableArray alloc]init];
    }
    
    if (_cityList !=nil) {
        _cityList=[[NSMutableArray alloc]init];
    }
    
    BestID = _BestIDstr;
    DomainID = _DomainIDstr;
    IntentionID = _IntentionIDStr;
    RequirementID = _NowNeedID;
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
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
    
    self.PersonInformationtableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.PersonInformationtableview.delegate = self;
    self.PersonInformationtableview.dataSource = self;
    [self.PersonInformationtableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.PersonInformationtableview];
    
    HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180*PMBWIDTH)];
    headerimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HeaderView.width, 180*PMBWIDTH)];
    UITapGestureRecognizer *bakTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateBgkImage:)];
    [HeaderView addGestureRecognizer:bakTap];
    NSString *bgkPath=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,UserDefaultEntity.bgkPath];
    [headerimage sd_setImageWithURL:[NSURL URLWithString:bgkPath] placeholderImage:[UIImage imageNamed:@"beijing_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];


    [HeaderView addSubview:headerimage];

    
    IconBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80*PMBWIDTH, 80*PMBWIDTH)];
    IconBtn.center = CGPointMake(ScreenWidth/2, 90*PMBWIDTH);
    IconBtn.layer.cornerRadius = IconBtn.height/2;
    IconBtn.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateIconImage:)];
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
    self.PersonInformationtableview.tableHeaderView = HeaderView;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 8;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return _HistoryWorkArray.count;
    }else if (section==3){
        return 1;
    }else if (section==5){
        return 4;
    }else if (section==4){
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
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
            line.hidden = YES;
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
    
        }else if (indexPath.row ==6){
            if (!PositionLab) {
                PositionLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                PositionLab.font = Font(14);
                PositionLab.textAlignment = NSTextAlignmentRight;
                PositionLab.text = UserDefaultEntity.positionName;
                positionId = UserDefaultEntity.positionId;
                [cell addSubview:PositionLab];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row ==7){
            if (!informationLab) {
                informationLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 15*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                informationLab.textAlignment = NSTextAlignmentRight;
                informationLab.font = Font(14);
                informationLab.text = UserDefaultEntity.remark;
                [cell addSubview:informationLab];
            }

        }
        return cell;

    }else if (indexPath.section==1){
        NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"工作经历";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = Font(14);
        cell.backgroundColor = [UIColor themeGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section==2){
        AddHistoryWork *work = [_HistoryWorkArray objectAtIndex:indexPath.row];
        NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSDate *Sdate = [DateFormatter stringToDateCustom:work.tSDate formatString:def_YearMonthDay_DF];
        NSString *SDate = [DateFormatter dateToStringCustom:Sdate formatString:def_YearMobth];
        if ([work.tEDate isEqualToString:@""]) {
            EDate = @"至今";
        }else{
            NSDate *Edate = [DateFormatter stringToDateCustom:work.tEDate formatString:def_YearMonthDay_DF];
            EDate = [DateFormatter dateToStringCustom:Edate formatString:def_YearMobth];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"      %@---%@   %@     %@",SDate,EDate,work.tCommpany,work.tPosition];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = Font(14);
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==3){

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (!addimg) {
            addimg = [[UIImageView alloc]initWithFrame:CGRectMake(35*PMBWIDTH, 10*PMBWIDTH, 18*PMBWIDTH, 18*PMBWIDTH)];
            addimg.image = [UIImage imageNamed:@"tianjia_btn"];
            [cell addSubview:addimg];
        }
        if (!Addlab) {
            Addlab = [[UILabel alloc]initWithFrame:CGRectMake(addimg.right+3*PMBWIDTH, addimg.top+2*PMBWIDTH, 80*PMBWIDTH, 14*PMBWIDTH)];
            Addlab.text = @"继续添加";
            Addlab.font = Font(14);
            Addlab.textColor = [UIColor lightGrayColor];
            [cell addSubview:Addlab];
        }
        
        return cell;
    }else if (indexPath.section==4){
        NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"创业偏好";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = Font(14);
        cell.backgroundColor = [UIColor themeGrayColor];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section==5){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = Font(14);
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row==0) {

            if (!Intentionlab) {
                Intentionlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 18*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                Intentionlab.font = Font(14);
                Intentionlab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:Intentionlab];
            }
            cell.textLabel.text=@"创业意向";
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
            if (_type == 1) {
                Intentionlab.text = _IntentionName;
                IntentionID = _IntentionIDStr;
            }else if (_type==4){
                Intentionlab.text = intentionstr;
                IntentionID = intentionID;
                _IntentionName = intentionstr;
            }
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
            line.backgroundColor = [UIColor themeGrayColor];
            [cell addSubview:line];
            
        }
        if (indexPath.row==1) {
            if (!BestLab) {
                BestLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 18*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                BestLab.font = Font(14);
                BestLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:BestLab];
            }
            cell.textLabel.text = @"我最擅长";
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
                BestLab.text = _BestStr;
                BestID= _BestIDstr;
            }else if (_type==2){
                BestLab.text = [NSString stringWithFormat:@"%@",beststring];
                BestID = bestID;
                _BestStr = beststring;
            }
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
            line.backgroundColor = [UIColor themeGrayColor];
            [cell addSubview:line];
        }else if (indexPath.row==2){
            if (!FocusareaLab) {
                FocusareaLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 18*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                FocusareaLab.font = Font(14);
                FocusareaLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:FocusareaLab];
            }
            NSString *DomainS = @"";
            NSString *Id = @"";
            for (int i =0; i<[DomainArray count]; i++) {
                NSDictionary *dict = [DomainArray objectAtIndex:i];
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
                FocusareaLab.text = _DomainStr;
                DomainID = _DomainIDstr;
            }else if(_type==3){
                FocusareaLab.text =[NSString stringWithFormat:@"%@",DomainS];
                DomainID = Id;
                _DomainStr=DomainS;
            }
            cell.textLabel.text = @"关注领域";
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
            line.backgroundColor = [UIColor themeGrayColor];
            [cell addSubview:line];
        }else if (indexPath.row==3){
                if (!Requirementlab) {
                    Requirementlab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 18*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                    Requirementlab.font = Font(14);
                    Requirementlab.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:Requirementlab];
            }
            cell.textLabel.text = @"现阶段需求";
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
                Requirementlab.text = _NowNeedName;
                RequirementID = _NowNeedID;
            }else if (_type==5){
                Requirementlab.text = requirementstr;
                RequirementID = requirementID;
                _NowNeedName = requirementstr;
            }
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 30*PMBWIDTH;
        }else{
            return 45*PMBWIDTH;
        }
    }else if (indexPath.section==1) {
        return 30*PMBWIDTH;
    }else if (indexPath.section==2){
        return 25*PMBWIDTH;
    }else if (indexPath.section==5){
        return 50*PMBWIDTH;
    }else if (indexPath.section==3){
        return 45*PMBWIDTH;
    }else if (indexPath.section==4){
        return 30*PMBWIDTH;
    }else{
        return 45*PMBWIDTH;
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
        }
        if (indexPath.row==3) {
            //隐藏键盘
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"出生日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(BirthdateSelected:birth:) origin:BirthdateLab];
            datePicker.minuteInterval = 5;
            [datePicker showActionSheetPicker];
        }else if (indexPath.row==4){
            QchCityViewController *selectcity = [[QchCityViewController alloc]init];
            selectcity.citylist =_cityList;
            selectcity.cityDelegate = self;
            selectcity.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:selectcity animated:YES];
        }else if (indexPath.row==6){
            PositionViewController *position = [[PositionViewController alloc]init];
            position.positonDelegate = self;
            [self.navigationController pushViewController:position animated:YES];
        }else if (indexPath.row==7){
            CommitAlertView *showView=[[CommitAlertView alloc]initWithView:@"填写描述" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"  textViewPlaceholder:informationLab.text];
            showView.delegate = self;
            [self.view addSubview:showView];
            
        }
    }else if (indexPath.section==3){
        WorkExperienceVC *work = [[WorkExperienceVC alloc]init];
        work.hidesBottomBarWhenPushed = YES;
        [work returnArray:^(NSArray *HistorkWork) {
            _HistoryWorkArray = [HistorkWork mutableCopy];
            [self.PersonInformationtableview reloadData];
        }];
        [self.navigationController pushViewController:work animated:YES];
    }else if (indexPath.section==5){
        
        BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
        [self.navigationController pushViewController:best animated:YES];
        
        if (indexPath.row==0) {
            best.Byid = 1362;
            _type=4;
            best.selectStr = _IntentionName;
            [best returnArray:^(NSArray *SelectedArray) {
                IntentionArray = [SelectedArray mutableCopy];
                [self.PersonInformationtableview reloadData];
            }];
        }
        if (indexPath.row==1) {
            best.Byid = 81;
            _type=2;
            best.selectStr = _BestStr;
            [best returnArray:^(NSArray *SelectedArray) {
                BestArray = [SelectedArray mutableCopy];
                [self.PersonInformationtableview reloadData];
            }];

        }else if (indexPath.row==2){
            best.Byid = 80;
            _type=3;
            best.selectStr = _DomainStr;
            [best returnArray:^(NSArray *SelectedArray) {
                DomainArray = [SelectedArray mutableCopy];
                [self.PersonInformationtableview reloadData];
            }];
            
        }else if (indexPath.row==3){
            best.Byid = 1361;
            _type=5;
            best.selectStr = _NowNeedName;
            [best returnArray:^(NSArray *SelectedArray) {
                RequirementArray = [SelectedArray mutableCopy];
                [self.PersonInformationtableview reloadData];
            }];
        }
    }
}

-(void)updateTextViewData:(NSString*)text{
    if (text.length<10) {
        [SVProgressHUD showErrorWithStatus:@"个人描述限制最少10个字" maskType:SVProgressHUDMaskTypeBlack];
        informationLab.text=text;
    }else{
        informationLab.text=text;
    }
}


-(void)selectPosition:(NSDictionary*)dict{
    PositionLab.text=[dict objectForKey:@"t_Style_Name"];
    positionId=[dict objectForKey:@"Id"];
}

-(void)BirthdateSelected:(NSDate *)selectedTime birth:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date=[dateFormatter stringFromDate:selectedTime];
    [element setText:date];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        return YES;
    }else{
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            AddHistoryWork *work = [_HistoryWorkArray objectAtIndex:indexPath.row];
            [self delete:work.guid];
            [_HistoryWorkArray removeObjectAtIndex:indexPath.row];
            [self.PersonInformationtableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

}


- (void)delete:(NSString*)guId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:guId forKey:@"guid"];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
    [HttpPartnerAction CommitHistoryWork:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)selectCityData:(NSString *)city{
    CityLab.text = city;
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getHotCity{
    [HttpLoginAction getHotCity:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _cityList=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _cityList=[[NSMutableArray alloc]init];
        }
    }];
}


-(void)save:(UIButton *)sender{
    
    if ([self isBlankString:UserDefaultEntity.headPath]&[self isBlankString:IconStr]) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Namefield.text]){
        [SVProgressHUD showErrorWithStatus:@"请填写姓名" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Namefield.text.length>10){
        [SVProgressHUD showErrorWithStatus:@"姓名限制10字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:BirthdateLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请完善出生日期" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:CityLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请选择城市" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Companyfield.text]){
       [SVProgressHUD showErrorWithStatus:@"请完善公司信息" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Companyfield.text.length>20){
        
       [SVProgressHUD showErrorWithStatus:@"公司信息限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:PositionLab.text]) {
      [SVProgressHUD showErrorWithStatus:@"请选择您的职业" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:informationLab.text]){
      [SVProgressHUD showErrorWithStatus:@"请完善个人简介" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:IntentionID]){
       [SVProgressHUD showErrorWithStatus:@"请选择创业意向" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:RequirementID]){
      [SVProgressHUD showErrorWithStatus:@"请选择现阶段需求" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:DomainID]){
       [SVProgressHUD showErrorWithStatus:@"请选择关注领域" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:BestID]){
      [SVProgressHUD showErrorWithStatus:@"请选择擅长" maskType:SVProgressHUDMaskTypeBlack];
    }else if (_HistoryWorkArray.count ==0){
        
      [SVProgressHUD showErrorWithStatus:@"请完善工作经历" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:SexLab.text]){
      [SVProgressHUD showErrorWithStatus:@"请选择性别" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([informationLab.text length]<10){
      [SVProgressHUD showErrorWithStatus:@"个人简介至少填写10个字" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        [dict setObject:@"3" forKey:@"userStyle"];
        [dict setObject:Namefield.text forKey:@"realName"];
        [dict setObject:CityLab.text forKey:@"city"];
        [dict setObject:Companyfield.text forKey:@"commpany"];
        [dict setObject:positionId forKey:@"position"];
        [dict setObject:SexLab.text forKey:@"sex"];
        [dict setObject:BirthdateLab.text forKey:@"birth"];
        [dict setObject:informationLab.text forKey:@"remark"];
        [dict setObject:DomainID forKey:@"focusarea"];
        [dict setObject:BestID forKey:@"best"];
        [dict setObject:@"" forKey:@"investarea"];
        [dict setObject:@"" forKey:@"investphase"];
        [dict setObject:@"" forKey:@"investmoney"];
        [dict setObject:RequirementID forKey:@"nowneed"];
        [dict setObject:IntentionID forKey:@"intention"];
        [dict setObject:@"" forKey:@"base64Pic"];
        [dict setObject:@"" forKey:@"base64CardPic"];
        [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpPartnerAction CompleteUserVersion2:dict complete:^(id result, NSError *error) {
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                NSArray *array = [result objectForKey:@"result"];
                NSDictionary *dict=array[0];
                UserDefaultEntity.user_style = [dict objectForKey:@"t_User_Style"];
                UserDefaultEntity.realName = [[dict objectForKey:@"t_User_RealName"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.remark = [[dict objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.headPath = [dict objectForKey:@"t_User_Pic"];
                UserDefaultEntity.commpany = [[dict objectForKey:@"t_User_Commpany"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.positionName = [dict objectForKey:@"PositionName"];
                UserDefaultEntity.positionId = [dict objectForKey:@"t_User_Position"];
                UserDefaultEntity.user_city = [dict objectForKey:@"t_User_City"];
                UserDefaultEntity.sex = [dict objectForKey:@"t_User_Sex"];
                UserDefaultEntity.bgkPath=[dict objectForKey:@"t_BackPic"];
                UserDefaultEntity.birDate = [dict objectForKey:@"t_User_Birth"];
                UserDefaultEntity.NowNeed = [NSString stringWithFormat:@"%lu",[[dict objectForKey:@"NowNeed"]count]];
                [UserDefault saveUserDefault];
                
                [SVProgressHUD showSuccessWithStatus:@"成功" maskType:SVProgressHUDMaskTypeBlack];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
        
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
    
}

-(void)updateIconImage:(UIButton *)sender{
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(200*PMBWIDTH, 200*PMBWIDTH)];
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
    return UIImageJPEGRepresentation(newImage, 1.0);
}


-(void)updateBgkImage:(id)sender{
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            [self submit:image];
//            [headerimage setImage:image];
//            [headerimage setContentScaleFactor:[[UIScreen mainScreen] scale]];
//            headerimage.contentMode =  UIViewContentModeScaleAspectFill;
//            headerimage.clipsToBounds  = YES;

        }
    }];
}

-(void)submit:(UIImage*)image{
    
    NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(headerimage.size.width, headerimage.size.height)];
    
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
                //[headerimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"beijing_img"]];
                [headerimage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"beijing_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   // headerimage.image = [Utils GPUImageGaussianBlurImage:url];
                }];
            }
        }
    }];
}

@end
