//
//  SendActivityVC.m
//  qch
//
//  Created by 苏宾 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SendActivityVC.h"

@interface SendActivityVC ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,QchCityViewControllerDelegate>{
    
    UIView *headView;
    UIImageView *headImageView;
    UIView *mainView;
    UIScrollView *scrollView;
    
    UITextField *activityTfd;
    UITextView *contentView;
    UILabel *planceLabel;
    
    UITextField *senderTfd;
    
    UILabel *startDate;
    UILabel *endDate;
    UILabel *cityStr;
    
    NSString *photoStr;
    
    UITextField *activityNum;
    UITextField *activityPrice;
    UITextField *consultTel;
    UITextField *activityAddress;
    
    
    UIBarButtonItem *cancalBtn;
    
    //开始 结束时间
    NSDate *Sdate;
    NSDate *Edate;
}

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) NSMutableArray *citylist;

@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation SendActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"创建活动"];
    
    if (_citylist!=nil) {
        _citylist=[[NSMutableArray alloc]init];
    }
    [self createFrame];
    
    cancalBtn=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(commitMsgBtn:)];
    cancalBtn.enabled=NO;
    self.navigationItem.rightBarButtonItem=cancalBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHotCity];
}

-(void)createFrame{
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:headView];
    
    UIButton *photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame=CGRectMake((SCREEN_WIDTH-100*SCREEN_WSCALE)/2, 20*SCREEN_WSCALE, 100*SCREEN_WSCALE, 100*SCREEN_WSCALE);
    [photoBtn setImage:[UIImage imageNamed:@"photoImage"] forState:UIControlStateNormal];
    photoBtn.layer.masksToBounds=YES;
    photoBtn.layer.cornerRadius=photoBtn.height/2;
    [photoBtn addTarget:self action:@selector(updatePhotoImage:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:photoBtn];
    
    UILabel *photoLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCREEN_WSCALE)/2, photoBtn.bottom+5*SCREEN_WSCALE, 200*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
    photoLabel.text=@"添加封面图片";
    photoLabel.textAlignment=NSTextAlignmentCenter;
    photoLabel.font=Font(14);
    photoLabel.textColor=[UIColor lightGrayColor];
    [headView addSubview:photoLabel];
    
    [self createMainView];
}

-(void)createMainView{
    
    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom, SCREEN_WIDTH, 590*SCREEN_WSCALE)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:mainView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line];
    
    UILabel *activityName=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line.bottom+10*SCREEN_WSCALE, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"活动名称:"];
    [mainView addSubview:activityName];
    
    activityTfd=[self createTextFieldFrame:CGRectMake(activityName.right, activityName.top, SCREEN_WIDTH-90*SCREEN_WSCALE, activityName.height) font:Font(14) placeholder:@"请输入活动名称"];
    [mainView addSubview:activityTfd];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, activityName.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line1 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line1];
    
    contentView=[[UITextView alloc]initWithFrame:CGRectMake(5*SCREEN_WSCALE, line1.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 150*SCREEN_WSCALE) textContainer:NSTextAlignmentLeft];
    contentView.font=Font(14);
    contentView.textColor=[UIColor blackColor];
    contentView.delegate=self;
    [mainView addSubview:contentView];
    
    planceLabel=[self createLabelFrame:CGRectMake(5*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH, 16) color:[UIColor lightGrayColor] font:Font(13) text:@"填写活动描述，让更多参与到活动中……"];
    [contentView addSubview:planceLabel];
    
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100*SCREEN_WSCALE, contentView.bottom+2*SCREEN_WSCALE, 85*SCREEN_WSCALE, 17*SCREEN_WSCALE)];
    _numberLabel.text=@"0/2500";
    _numberLabel.textColor=[UIColor lightGrayColor];
    _numberLabel.font=Font(14);
    _numberLabel.textAlignment=NSTextAlignmentRight;
    [mainView addSubview:_numberLabel];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, _numberLabel.bottom+2*SCREEN_WSCALE, SCREEN_WIDTH, 10*SCREEN_WSCALE)];
    [line2 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line2];
    
    UILabel *senderLabel=[self createLabelFrame:CGRectMake(activityName.left, line2.bottom+10*SCREEN_WSCALE, activityName.width, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@" 主 办 方:"];
    [mainView addSubview:senderLabel];
    
    senderTfd=[self createTextFieldFrame:CGRectMake(senderLabel.right+5*SCREEN_WSCALE, senderLabel.top, activityTfd.width, senderLabel.height) font:Font(14) placeholder:@"请输入主办方"];
    [mainView addSubview:senderTfd];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, senderLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH, 10*SCREEN_WSCALE)];
    [line3 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line3];
    
    UILabel *startDateLabel=[self createLabelFrame:CGRectMake(activityName.left, line3.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"开始时间:"];
    [mainView addSubview:startDateLabel];
    
    startDate=[[UILabel alloc]initWithFrame:CGRectMake(startDateLabel.right+10*SCREEN_WSCALE, startDateLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, startDateLabel.height)];
    startDate.textColor=[UIColor grayColor];
    startDate.font=Font(14);
    [mainView addSubview:startDate];
    
    UIButton *startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame=startDate.frame;
    [startBtn addTarget:self action:@selector(startDateTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:startBtn];
    
    UIImageView *nextImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, startDate.top, 15*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
    nextImgeView.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeView];
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, startDateLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WSCALE)];
    [line4 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line4];
    
    UILabel *endDateLabel=[self createLabelFrame:CGRectMake(activityName.left, line4.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"结束时间:"];
    [mainView addSubview:endDateLabel];
    
    endDate=[[UILabel alloc]initWithFrame:CGRectMake(endDateLabel.right+10*SCREEN_WSCALE, endDateLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, startDateLabel.height)];
    endDate.textColor=[UIColor grayColor];
    endDate.font=Font(14);
    [mainView addSubview:endDate];
    
    UIButton *endBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame=endDate.frame;
    [endBtn addTarget:self action:@selector(endDateTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:endBtn];
    
    UIImageView *nextImgeViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, endDate.top, 15*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeViewTwo.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeViewTwo];
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(0, endDateLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH, 10*SCREEN_WSCALE)];
    [line5 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line5];
    
    UILabel *presonNumLabel=[self createLabelFrame:CGRectMake(activityName.left, line5.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"参与人数:"];
    [mainView addSubview:presonNumLabel];
    
    activityNum=[self createTextFieldFrame:CGRectMake(presonNumLabel.right+5*SCREEN_WSCALE, presonNumLabel.top, activityTfd.width, presonNumLabel.height) font:Font(14) placeholder:@"请输入活动报名人数上限"];
    activityNum.keyboardType=UIKeyboardTypeNumberPad;
    activityNum.delegate = self;
    [mainView addSubview:activityNum];
    
    UIView *line6=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, presonNumLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WSCALE)];
    [line6 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line6];
    
    UILabel *activityPriceLabel=[self createLabelFrame:CGRectMake(activityName.left, line6.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"活动费用:"];
    [mainView addSubview:activityPriceLabel];
    
    activityPrice=[self createTextFieldFrame:CGRectMake(activityPriceLabel.right+5*SCREEN_WSCALE, activityPriceLabel.top, activityNum.width, activityPriceLabel.height) font:Font(14) placeholder:@"请输入所需费用，如无费用请填0"];
    activityPrice.keyboardType=UIKeyboardTypeDecimalPad;
    activityPrice.delegate = self;
    [mainView addSubview:activityPrice];
    
    UIView *line7=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, activityPriceLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WSCALE)];
    [line7 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line7];
    
    UILabel *consultLabel=[self createLabelFrame:CGRectMake(activityName.left, line7.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"咨询电话:"];
    [mainView addSubview:consultLabel];
    
    consultTel=[self createTextFieldFrame:CGRectMake(consultLabel.right+5*SCREEN_WSCALE, consultLabel.top, activityPrice.width, consultLabel.height) font:Font(14) placeholder:@"请输入电话号码"];
    consultTel.delegate = self;
    consultTel.keyboardType=UIKeyboardTypePhonePad;
    [mainView addSubview:consultTel];
    
    UIView *line8=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, consultLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WSCALE)];
    [line8 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line8];
    
    UILabel *cityLabel=[self createLabelFrame:CGRectMake(activityName.left, line8.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"所在城市:"];
    [mainView addSubview:cityLabel];
    
    cityStr=[[UILabel alloc]initWithFrame:CGRectMake(cityLabel.right+10*SCREEN_WSCALE, cityLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, cityLabel.height)];
    cityStr.textColor=[UIColor grayColor];
    cityStr.font=Font(14);
    [mainView addSubview:cityStr];
    
    UIButton *cityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame=cityStr.frame;
    [cityBtn addTarget:self action:@selector(selectCityTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cityBtn];
    
    UIImageView *nextImgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, cityLabel.top, 15*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
    nextImgeView3.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeView3];
    
    UIView *line9=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, cityLabel.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*SCREEN_WSCALE)];
    [line9 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line9];
    
    UILabel *activityAddressLabel=[self createLabelFrame:CGRectMake(activityName.left, line9.bottom+10*SCREEN_WSCALE, activityName.width, activityName.height) color:[UIColor blackColor] font:Font(14) text:@"活动地址:"];
    [mainView addSubview:activityAddressLabel];
    
    activityAddress=[self createTextFieldFrame:CGRectMake(activityAddressLabel.right+5*SCREEN_WSCALE, activityAddressLabel.top,  activityPrice.width, activityAddressLabel.height) font:Font(14) placeholder:@"请输入活动地点"];
    [mainView addSubview:activityAddress];
    
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 830*SCREEN_WSCALE)];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            
            _isHaveDian = NO;
        }
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length]==0){
                    if(single == '.'){
                        //                    [self alertView:@"亲，第一个数字不能为小数点"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    //                if (single == '0') {
                    //
                    //                    //                    [self alertView:@"亲，第一个数字不能为0"];
                    //
                    //                    [activityPrice.text stringByReplacingCharactersInRange:range withString:@""];
                    //
                    //                    return NO;
                    //
                    //                }
                    
                }
                if (single=='.')
                {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        //                    [self alertView:@"亲，您已经输入过小数点了"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                else
                {
                    if (_isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        NSInteger tt = range.location-ran.location;
                        if (tt <= 2){
                            return YES;
                        }else{
                            //                        [self alertView:@"亲，您最多输入两位小数"];
                            return NO;
                        }
                    }
                    else{
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                //            [self alertView:@"亲，您输入的格式不正确"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }

}



-(void)getHotCity{
    [HttpLoginAction getHotCity:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _citylist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _citylist=[[NSMutableArray alloc]init];
        }
    }];
}

-(void)selectCityData:(NSString *)city{
    cityStr.text=city;
}

-(void)commitMsgBtn:(UIButton*)sender{
    
    
    if ([self isBlankString:photoStr]) {
      [SVProgressHUD showErrorWithStatus:@"请上传活动封面图片" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:activityTfd.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写活动名称" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (activityTfd.text.length>20) {

      [SVProgressHUD showErrorWithStatus:@"活动名称限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if([self isBlankString:contentView.text]){
        
        [SVProgressHUD showErrorWithStatus:@"活动描述不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if([self isBlankString:senderTfd.text]){
        
        [SVProgressHUD showErrorWithStatus:@"主办方不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if([self isBlankString:startDate.text]){
        
        [SVProgressHUD showErrorWithStatus:@"开始时间不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:endDate.text]) {

        [SVProgressHUD showErrorWithStatus:@"结束时间不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:activityNum.text]) {
      [SVProgressHUD showErrorWithStatus:@"参与人数不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:activityPrice.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"活动费用不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:consultTel.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"咨询电话不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (consultTel.text.length>15) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写正确的电话号码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:cityStr.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择城市" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:activityAddress.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"活动地址不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSString *feeType=nil;
    double activitydouble = [[NSString stringWithFormat:@"%.2f",[activityPrice.text doubleValue]]doubleValue];
    if (activitydouble==0) {
        feeType=@"免费";
    }else{
        feeType=@"付费";
    }
    [SVProgressHUD showWithStatus:@"发布活动" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:activityTfd.text forKey:@"title"];
    [dict setObject:startDate.text forKey:@"sdate"];
    [dict setObject:endDate.text forKey:@"edate"];
    [dict setObject:cityStr.text forKey:@"cityName"];
    [dict setObject:activityAddress.text forKey:@"street"];
    [dict setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"longitude"];
    [dict setObject:[NSString stringWithFormat:@"%@",@""] forKey:@"latitude"];
    [dict setObject:contentView.text forKey:@"instruction"];
    [dict setObject:activityNum.text forKey:@"limitPerson"];
    [dict setObject:feeType forKey:@"feeType"];
    [dict setObject:[NSString stringWithFormat:@"%lf",activitydouble] forKey:@"fee"];
    [dict setObject:consultTel.text forKey:@"tel"];
    [dict setObject:photoStr forKey:@"coverpic"];
    [dict setObject:senderTfd.text forKey:@"holder"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpActivityAction AddActivity:dict complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refeleshView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请检查信息重新提交" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)startDateTapped:(UIButton *)sender{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"开始时间" datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(startimeWasSelected:element:) origin:startDate];
    datePicker.minuteInterval = 5;
    [datePicker setMinimumDate:[NSDate new]];
    [datePicker showActionSheetPicker];
}

-(void)startimeWasSelected:(NSDate *)selectedTime element:(id)element {
    Sdate = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

-(void)endDateTapped:(UIButton *)sender{
    //隐藏键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"结束时间" datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] target:self action:@selector(endtimeWasSelected:element:) origin:endDate];
    datePicker.minuteInterval = 5;
    [datePicker setMinimumDate:[NSDate new]];
    [datePicker showActionSheetPicker];
}

-(void)endtimeWasSelected:(NSDate *)selectedTime element:(id)element {
    Edate = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

-(void)selectCityTapped:(UIButton*)sender{
    
    QchCityViewController *qchCity=[[QchCityViewController alloc]init];
    qchCity.cityDelegate=self;
    qchCity.citylist=_citylist;
    qchCity.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:qchCity animated:YES];
}

-(void)updatePhotoImage:(UIButton*)sender{
    
    [activityAddress resignFirstResponder];
    [activityNum resignFirstResponder];
    [activityPrice resignFirstResponder];
    [activityTfd resignFirstResponder];
    [consultTel resignFirstResponder];
    [contentView resignFirstResponder];
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(300, 150)];
            
            NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
            //    NSLog(@"图片路径：%@",imageStr);
            photoStr=imageStr;
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
            
            [headImageView setImage:image];
            [headView addSubview:headImageView];
            //        headView.userInteractionEnabled = NO;
            
            [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            headImageView.contentMode =  UIViewContentModeScaleAspectFill;
            headImageView.clipsToBounds  = YES;
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

- (NSString*)encodeURL:(NSString *)string{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] >= 2500) {
        textView.text = [textView.text substringToIndex:2500];
        return;
    }//250-
    self.numberLabel.text = [NSString stringWithFormat:@"%d/2500",(int)([textView.text length])];
    if ([textView.text length]>0) {
        planceLabel.hidden=YES;
    }else{
        planceLabel.hidden=NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        cancalBtn.enabled=YES;
    } else {
        cancalBtn.enabled=NO;
    }
}

@end
