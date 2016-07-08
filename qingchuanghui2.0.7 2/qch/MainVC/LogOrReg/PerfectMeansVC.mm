//
//  PerfectMeansVC.m
//  qch
//
//  Created by 苏宾 on 16/1/15.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PerfectMeansVC.h"
#import "QCHPositionViewController.h"

@interface PerfectMeansVC ()<UIGestureRecognizerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,QchSelectCityVCDelegate,QCHPositionDelegate,UITextFieldDelegate>{
    
    UIImageView *bkgImageView;
    UIButton *backBtn;
    
    UIButton *ckBtn;
    UIButton *tzrBtn;
    
    UIImageView *imageBtn;
    UIImageView *iconImageView;
    UITextField *nameTextfield;
    UITextField *companyTextfield;
    UILabel *positionLab;
    UILabel *addressLab;
    UIButton *completeBtn;
    
    NSString *headImage;
    
    NSString *positionId;
}

@property (strong, nonatomic) BMKLocationService *locationService;
@property (strong, nonatomic) BMKGeoCodeSearch *locationSearch;
@property (nonatomic,assign) float lng;
@property (nonatomic,assign) float lat;

@property (nonatomic,strong) NSMutableArray *cityList;

@end

@implementation PerfectMeansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_cityList!=nil) {
        _cityList=[[NSMutableArray alloc]init];
    }
    [self createBackgroundImage];
    [self createBackBtn];
    
    [self createSecordView];
    [self startLocation];
    
    if (_type==1) {
        if (![self isBlankString:UserDefaultEntity.headPath]) {
            
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath]];
            [imageBtn sd_setImageWithURL:url];
            nameTextfield.text=UserDefaultEntity.realName;
        }
    } else {
        if (![self isBlankString:UserDefaultEntity.splashPath]) {
            
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:UserDefaultEntity.splashPath] placeholderImage:[UIImage imageNamed:@"loading_1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self submit:imageBtn.image];
        }];
        }
    }
    [self getHotCity];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [nameTextfield resignFirstResponder];
    [companyTextfield resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(void)createBackgroundImage{
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    UIImage *image = [UIImage imageNamed:@"denglu_bj2_img"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    bkgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, SCREEN_HEIGHT)];
    [bkgImageView setImage:blurredImage];
    [self.view addSubview:bkgImageView];
    
}

-(void)createBackBtn{
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15*SCREEN_WSCALE, 22*SCREEN_WSCALE, 24*SCREEN_WSCALE, 24*SCREEN_WSCALE);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(39*SCREEN_WSCALE, backBtn.top, SCREEN_WIDTH-39*2*SCREEN_WSCALE, backBtn.height)];

    titleLabel.text=@"完善资料";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=Font(18);
    [self.view addSubview:titleLabel];
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//第二个页面
-(void)createSecordView{
    

    imageBtn = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70*SCREEN_WSCALE)/2, 80*SCREEN_WSCALE, 70*PMBWIDTH, 70*SCREEN_WSCALE)];

    [imageBtn setBackgroundColor:[UIColor themewhiteColor]];
    imageBtn.layer.masksToBounds=YES;
    imageBtn.layer.cornerRadius=imageBtn.height/2;

    imageBtn.userInteractionEnabled = YES;
    [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)]];
    [self.view addSubview:imageBtn];
    
    UILabel *wordLab = [[UILabel alloc]initWithFrame:CGRectMake(0, imageBtn.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 14*SCREEN_WSCALE)];
    wordLab.text = @"你正在改变世界，让世界认识真实的你";
    wordLab.textColor = [UIColor whiteColor];
    wordLab.textAlignment = NSTextAlignmentCenter;
    wordLab.font = Font(14);
    [self.view addSubview:wordLab];
    
    UIView *accountView=[self createBgkView:CGRectMake(30*PMBWIDTH, wordLab.bottom+20*SCREEN_WSCALE, SCREEN_WIDTH-60*PMBWIDTH, 40*SCREEN_WSCALE)];
    [self.view addSubview:accountView];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20*PMBWIDTH, 13*SCREEN_WSCALE, 30*PMBWIDTH, 15*SCREEN_WSCALE)];
    lab1.text = @"姓名";
    lab1.font = Font(15);
    lab1.textColor = [UIColor whiteColor];
    [accountView addSubview:lab1];
    
    
    nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(lab1.right+10*PMBWIDTH, lab1.top-5*SCREEN_WSCALE, accountView.width-lab1.width-70*PMBWIDTH, 26*SCREEN_WSCALE)];
    nameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写您的真实姓名" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    nameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextfield.font = Font(15);
    nameTextfield.textColor = [UIColor whiteColor];
    nameTextfield.textAlignment = NSTextAlignmentCenter;
    [accountView addSubview:nameTextfield];
    
    UIView *addressView=[self createBgkView:CGRectMake(accountView.left, accountView.bottom+10*SCREEN_WSCALE, accountView.width, accountView.height)];
    [self.view addSubview:addressView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selct_address:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate = self;
    addressView.userInteractionEnabled = YES;
    [addressView addGestureRecognizer:singleFingerOne];
    
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.left,13*SCREEN_WSCALE, lab1.width, lab1.height)];
    lab3.text = @"地区";
    lab3.textColor = [UIColor whiteColor];
    lab3.font = Font(15);
    [addressView addSubview:lab3];
    
    
    addressLab = [[UILabel alloc]initWithFrame:CGRectMake(nameTextfield.left, nameTextfield.top, nameTextfield.width, nameTextfield.height)];
    addressLab.textColor = [UIColor whiteColor];
    addressLab.font = Font(15);
    addressLab.textAlignment = NSTextAlignmentCenter;
    [addressView addSubview:addressLab];
    
    UIImageView *nextImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(addressLab.right+15*PMBWIDTH, addressLab.top+3*SCREEN_WSCALE, 10*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeView.image = [UIImage imageNamed:@"next"];
    [addressView addSubview:nextImgeView];
    

    UIView *companyView=[self createBgkView:CGRectMake(addressView.left, addressView.bottom+10*SCREEN_WSCALE, addressView.width, addressView.height)];
    [self.view addSubview:companyView];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.left, 13*SCREEN_WSCALE, lab1.width, lab1.height)];
    lab2.text = @"公司";
    lab2.textColor = [UIColor whiteColor];
    lab2.font = Font(15);
    [companyView addSubview:lab2];
    
    
    companyTextfield = [[UITextField alloc]initWithFrame:CGRectMake(nameTextfield.left, nameTextfield.top, nameTextfield.width, nameTextfield.height)];
    companyTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写公司或项目简称" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    companyTextfield.clearButtonMode =UITextFieldViewModeWhileEditing;
    companyTextfield.font = Font(15);
    companyTextfield.textColor = [UIColor whiteColor];
    companyTextfield.textAlignment = NSTextAlignmentCenter;
    [companyView addSubview:companyTextfield];
    
    UIView *positionView=[self createBgkView:CGRectMake(companyView.left, companyView.bottom+10*SCREEN_WSCALE, companyView.width, companyView.height)];
    [self.view addSubview:positionView];
    
    
    UITapGestureRecognizer *singleFingerTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select_postion:)];
    singleFingerTwo.numberOfTouchesRequired = 1;
    singleFingerTwo.numberOfTapsRequired = 1;
    singleFingerTwo.delegate = self;
    positionView.userInteractionEnabled = YES;
    [positionView addGestureRecognizer:singleFingerTwo];
    
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.left,13*SCREEN_WSCALE, lab1.width, lab1.height)];
    lab4.text = @"职位";
    lab4.textColor = [UIColor whiteColor];
    lab4.font = Font(15);
    [positionView addSubview:lab4];
    
    
    positionLab = [[UILabel alloc]initWithFrame:CGRectMake(companyTextfield.left, companyTextfield.top, companyTextfield.width, companyTextfield.height)];
    positionLab.textColor = [UIColor whiteColor];
    positionLab.font = Font(15);
    positionLab.textAlignment = NSTextAlignmentCenter;
    [positionView addSubview:positionLab];
    
    UIImageView *nextImgeViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(positionLab.right+15*PMBWIDTH, positionLab.top+3*SCREEN_WSCALE, 10*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeViewTwo.image = [UIImage imageNamed:@"next"];
    [positionView addSubview:nextImgeViewTwo];
    
    
    completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(positionView.left, positionView.bottom+30*SCREEN_WSCALE, positionView.width, positionView.height);
    completeBtn.layer.masksToBounds = YES;
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completeBtn.layer.cornerRadius = completeBtn.height/2;
    completeBtn.layer.borderWidth =1.0f;
    completeBtn.layer.borderColor =[[UIColor whiteColor]colorWithAlphaComponent:0.5].CGColor;
    completeBtn.backgroundColor = [UIColor clearColor];
    [completeBtn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
    
}

-(void)complete:(UIButton *)sender{
    
    if ([self isBlankString:UserDefaultEntity.headPath]) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:nameTextfield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }else if (nameTextfield.text.length>10){
        [SVProgressHUD showErrorWithStatus:@"姓名限制10个字以内" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:addressLab.text]) {
        [SVProgressHUD showErrorWithStatus:@"请选择地区" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:companyTextfield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写公司或项目简称" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (companyTextfield.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"公司或项目简称限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:positionId]) {
        [SVProgressHUD showErrorWithStatus:@"请选择职务" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"提交中……" maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *dict=[NSMutableDictionary new];

    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"userStyle"];
    [dict setObject:nameTextfield.text forKey:@"realName"];
    [dict setObject:addressLab.text forKey:@"city"];
    [dict setObject:companyTextfield.text forKey:@"commpany"];
    [dict setObject:positionId forKey:@"position"];
    [dict setObject:@"" forKey:@"sex"];
    [dict setObject:@"" forKey:@"birth"];
    [dict setObject:@"" forKey:@"focusarea"];
    [dict setObject:@"" forKey:@"remark"];
    [dict setObject:@"" forKey:@"best"];
    [dict setObject:@"" forKey:@"investarea"];
    [dict setObject:@"" forKey:@"investphase"];
    [dict setObject:@"" forKey:@"investmoney"];
    [dict setObject:@"" forKey:@"base64Pic"];
    [dict setObject:@"" forKey:@"base64CardPic"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpLoginAction complateUser:dict complete:^(id result, NSError *error) {
        if (error==nil) {
            UserDefaultEntity.uuid=[result objectForKey:@"Guid"];
            UserDefaultEntity.account=[result objectForKey:@"t_User_LoginId"];
            UserDefaultEntity.telePhone=[result objectForKey:@"t_User_Mobile"];
            UserDefaultEntity.user_city=[result objectForKey:@"t_User_City"];
            UserDefaultEntity.commpany=[[result objectForKey:@"t_User_Commpany"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.is_perfect=[(NSNumber*)[result objectForKey:@"t_User_Complete"]integerValue];
            UserDefaultEntity.t_User_Complete = [result objectForKey:@"t_User_Complete"];
            UserDefaultEntity.uid=[result objectForKey:@"t_User_LoginId"];
            UserDefaultEntity.positionId=[result objectForKey:@"t_User_Position"];
            UserDefaultEntity.remark = [[result objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.birDate = [result objectForKey:@"t_User_Birth"];
            UserDefaultEntity.user_style=[result objectForKey:@"t_User_Style"];
            UserDefaultEntity.positionName=[result objectForKey:@"PositionName"];
            UserDefaultEntity.user_city=[result objectForKey:@"t_User_City"];
            UserDefaultEntity.sex = [result objectForKey:@"t_User_Sex"];
            UserDefaultEntity.headPath=[result objectForKey:@"t_User_Pic"];
            UserDefaultEntity.bgkPath=[result objectForKey:@"t_BackPic"];
            UserDefaultEntity.realName=[[result objectForKey:@"t_User_RealName"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.t_User_BusinessCard = [result objectForKey:@"t_User_BusinessCard"];
            UserDefaultEntity.t_User_InvestMoney = [result objectForKey:@"t_User_InvestMoney"];
            UserDefaultEntity.NowNeed = [NSString stringWithFormat:@"%lu",[[result objectForKey:@"NowNeed"]count]];
            NSArray *Ryarray=(NSArray*)[result objectForKey:@"t_RongCloud_Token"];
            
            if ([Ryarray count]>0) {
                NSDictionary *rongDict=Ryarray[0];
                UserDefaultEntity.userId=[rongDict objectForKey:@"userId"];
                UserDefaultEntity.token=[rongDict objectForKey:@"token"];
                [UserDefault saveUserDefault];
                
                [self linketoRongyun:UserDefaultEntity.token];
            }else{
                [self getRYToken:[result objectForKey:@"Guid"]];
            }
            [UserDefault saveUserDefault];
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:SVProgressHUDMaskTypeBlack];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [self GetVoucherByKey]; 
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QCHMainController *main = [[QCHMainController alloc] init];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                [self.navigationController pushViewController:main animated:YES];
            });
        }
    }];
}

-(void)GetVoucherByKey{
    [HttpCenterAction GetVoucherByKey:UserDefaultEntity.uuid key:@"yonghuzhuce" Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic =[dict objectForKey:@"result"][0];
            NSString*T_Voucher_Price = [[dic objectForKey:@"T_Voucher_Price"]stringByReplacingOccurrencesOfString:@".00" withString:@""];
            UserDefaultEntity.Coupon = T_Voucher_Price;
            [UserDefault saveUserDefault];
        }
    }];
}

-(void)changeHeadImage:(UIButton *)sender{
    [nameTextfield resignFirstResponder];
    [companyTextfield resignFirstResponder];

    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            [self submit:image];
        }
    }];
}



-(void)submit:(UIImage*)image{
    

    NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    
    NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:imageStr forKey:@"base64Pic"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpLoginAction updateImage:dic complete:^(id result, NSError *error) {
        
        if (error==nil) {
            NSString *imageurl=[result objectForKey:@"t_User_Pic"];
            if (![self isBlankString:imageurl]) {
                headImage=imageurl;
                UserDefaultEntity.headPath=imageurl;
                UserDefaultEntity.splashPath = nil;
                [UserDefault saveUserDefault];
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,imageurl]];
                
                [imageBtn sd_setImageWithURL:url];
            }
        }

    }];
}

-(void)selct_address:(UIButton*)sender{
    QchSelectCityVC *selectCity=[[QchSelectCityVC alloc]init];
    selectCity.cityDelegate=self;
    selectCity.type=1;
    selectCity.citylist=_cityList;
    [self.navigationController pushViewController:selectCity animated:YES];
}

-(void)select_postion:(UIButton *)sender{

    QCHPositionViewController *position = [[QCHPositionViewController alloc]init];
    position.positonDelegate=self;
    [self.navigationController pushViewController:position animated:YES];
}


-(UIView *)createBgkView:(CGRect)frame{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.height/2;
    return view;
}

-(UIButton *)createBtnFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag{
    
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setTag:tag];
    button.layer.masksToBounds=YES;
    button.layer.cornerRadius=button.height/2;
    [button.layer setBorderWidth:1.5]; //边框宽度
    CGColorRef colorref = [UIColor whiteColor].CGColor;
    [button.layer setBorderColor:colorref];//边框颜色
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

-(void)selectPosition:(NSDictionary*)dict{
    positionLab.text=[dict objectForKey:@"t_Style_Name"];
    positionId=[dict objectForKey:@"Id"];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
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

#pragma 百度地图定位信息
-(void)startLocation{
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    self.locationSearch = [[BMKGeoCodeSearch alloc] init];
    self.locationSearch.delegate = self;
    [self.locationService startUserLocationService];
}

//定位成功
-(void) didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    if (userLocation) {
        self.lng = userLocation.location.coordinate.longitude;
        self.lat = userLocation.location.coordinate.latitude;
        
        NSLog(@"%f,%f",self.lng,self.lat);
        
        UserDefaultEntity.longitude=userLocation.location.coordinate.longitude;
        UserDefaultEntity.latitude=userLocation.location.coordinate.latitude;
        [UserDefault saveUserDefault];
        
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        BMKReverseGeoCodeOption *options = [[BMKReverseGeoCodeOption alloc] init];
        options.reverseGeoPoint = pt;
        
        [self.locationSearch reverseGeoCode:options];
    }
}

//地址解析
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        [self.locationService stopUserLocationService];
        self.locationService.delegate = nil;
        self.locationSearch.delegate = nil;
        
        //当前定位地址
        UserDefaultEntity.address=result.address;
        UserDefaultEntity.province=result.addressDetail.province;
        UserDefaultEntity.city=[result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        UserDefaultEntity.district=result.addressDetail.district;
        [UserDefault saveUserDefault];
        //[str1 rangeOfString:str].location != NSNotFound
        if([result.addressDetail.province rangeOfString:@"市"].location != NSNotFound){
            [[NSUserDefaults standardUserDefaults] setObject:[result.addressDetail.province stringByReplacingOccurrencesOfString:@"市" withString:@""] forKey:@"CityName"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""] forKey:@"CityName"];
        }
        
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"location error %@",error);
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {//系统定位打开,但是不允许此程序访问位置.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"授权访问"
                                                        message:@"是否设置允许青创汇访问位置?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"设置", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSURL *url = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {//iOS7
            url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        } else {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)selectCityData:(NSString *)city{
    addressLab.text=city;
}

@end
