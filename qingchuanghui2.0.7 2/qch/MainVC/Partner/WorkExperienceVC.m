//
//  WorkExperienceVC.m
//  qch
//
//  Created by 青创汇 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "WorkExperienceVC.h"

@interface WorkExperienceVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *DataArray;
    UILabel *startDateLab;
    UILabel *endDateLab;
    UITextField *Companyfield;
    UITextField *Positionfield;
    NSDate *Sdate;
    NSDate *Edate;
}
@property (nonatomic,strong)UITableView *WorkExperienceTableview;
@end

@implementation WorkExperienceVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作经历";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(Save:)];
    [self.navigationItem setRightBarButtonItem:item];
    DataArray = @[@"起始时间",@"结束时间",@"公司名称",@"职务"];
    [self creatHeaderImg];
    
}
- (void)creatHeaderImg{
    self.WorkExperienceTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.WorkExperienceTableview.delegate = self;
    self.WorkExperienceTableview.dataSource = self;
    [self.WorkExperienceTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.WorkExperienceTableview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [DataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = Font(14);
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(8*PMBWIDTH, 39*PMBWIDTH, ScreenWidth-8*PMBWIDTH, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [cell addSubview:line];
    if (indexPath.row ==0) {
        startDateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
        startDateLab.font = Font(14);
        startDateLab.textAlignment = NSTextAlignmentRight;
        [cell addSubview:startDateLab];
    }else if (indexPath.row == 1){
        endDateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
        endDateLab.font = Font(14);
        endDateLab.textAlignment = NSTextAlignmentRight;
        endDateLab.text = @"至今";
        [cell addSubview:endDateLab];
    }else if (indexPath.row==2){
        Companyfield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
        Companyfield.font = Font(14);
        Companyfield.textAlignment = NSTextAlignmentRight;
        [cell addSubview:Companyfield];
    }else if (indexPath.row==3){
        Positionfield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
        Positionfield.font = Font(14);
        Positionfield.textAlignment = NSTextAlignmentRight;
        [cell addSubview:Positionfield];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*PMBWIDTH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        //隐藏键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"开始时间" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(startimeWasSelected:element:) origin:startDateLab];
        datePicker.minuteInterval = 5;
        [datePicker setMaximumDate:[NSDate new]];
        [datePicker showActionSheetPicker];
    }else if (indexPath.row ==1){
        //隐藏键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"结束时间" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(endtimeWasSelected:element:) origin:endDateLab];
        datePicker.minuteInterval = 5;
        [datePicker setMaximumDate:[NSDate new]];
        [datePicker showActionSheetPicker];
        
    }
    
}
-(void)startimeWasSelected:(NSDate *)selectedTime element:(id)element {
    Sdate = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *date=[dateFormatter stringFromDate:selectedTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *t = [cal components:unitFlags fromDate:Sdate toDate:Edate options:0];
    long sec1 =[t year]*365*24*3600 +[t month]*30*24*3600 +[t day]*3600*24+ [t hour]*3600+[t minute]*60+[t second];
    if (sec1<0) {
        [SVProgressHUD showErrorWithStatus:@"开始时间不能晚于结束时间" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [element setText:date];
    }


}
-(void)endtimeWasSelected:(NSDate *)selectedTime element:(id)element {
    Edate = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *date=[dateFormatter stringFromDate:selectedTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *t = [cal components:unitFlags fromDate:Sdate toDate:Edate options:0];
        long sec1 =[t year]*365*24*3600 +[t month]*30*24*3600 +[t day]*3600*24+ [t hour]*3600+[t minute]*60+[t second];
        if (sec1<0) {
            [SVProgressHUD showErrorWithStatus:@"开始时间不能晚于结束时间" maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [element setText:date];
        }
}
- (void)Save:(UIButton*)sender
{
    [Companyfield resignFirstResponder];
    [Positionfield resignFirstResponder];

    if ([self isBlankString:startDateLab.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择开始时间" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Companyfield.text]){
        [SVProgressHUD showErrorWithStatus:@"请填写公司名称" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Positionfield.text]){
        [SVProgressHUD showErrorWithStatus:@"请填写职位名称" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Companyfield.text.length>20){
        [SVProgressHUD showErrorWithStatus:@"公司名称限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Positionfield.text.length>10){
        [SVProgressHUD showErrorWithStatus:@"职位名称限制10个字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showWithStatus:@"提交中……" maskType:SVProgressHUDMaskTypeBlack];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if ([endDateLab.text isEqualToString:@"至今"]) {
            [dict setObject:@"" forKey:@"edate"];
        }else{
            [dict setObject:endDateLab.text forKey:@"edate"];
        }
        [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        [dict setObject:startDateLab.text forKey:@"sdate"];
        [dict setObject:Companyfield.text forKey:@"commpany"];
        [dict setObject:Positionfield.text forKey:@"position"];
        [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpPartnerAction AddHistoryWork:dict complete:^(id result, NSError *error) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
                RootAddHistoryWok *root = [[RootAddHistoryWok alloc]initWithDictionary:result];
                if (self.returnArrayblock !=nil) {
                    self.returnArrayblock(root.result);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }
}
- (void)returnArray:(ReturnArrayBlock)block{
    self.returnArrayblock = block;
}
@end
