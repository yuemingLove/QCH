//
//  HomeViewController.m
//  qch
//
//  Created by 苏宾 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HomeViewController.h"
#import "DynamicViewController.h"
#import "ADDdynamicVC.h"
#import "CareViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,QchCityViewControllerDelegate>{
    
    UISegmentedControl *segment;
    UIScrollView *_scrollView;
    UIButton *selectCity;
    UIButton *leftbtn;
    
    NSString *paCity;
    NSString *dyCity;
    
    NSInteger i;
    NSInteger status;
    

}

@property (nonatomic,strong) UIBarButtonItem *leftBtn;
@property (nonatomic,strong) UIBarButtonItem *rightBar;
@property (nonatomic,strong) UIButton *rightBtn;


@property (nonatomic,strong) DynamicViewController *myDynamic;
@property (nonatomic, strong) CareViewController *careVC;

@property (strong, nonatomic) BMKLocationService *locationService;
@property (strong, nonatomic) BMKGeoCodeSearch *locationSearch;
@property (nonatomic,assign) float lng;
@property (nonatomic,assign) float lat;

@property (nonatomic,strong) NSMutableArray *cityList;


@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    i=0;
    
    if (_cityList !=nil) {
        _cityList=[[NSMutableArray alloc]init];
    }
    
    //融云登录
    if(![self isBlankString:UserDefaultEntity.token]){
        [self linketoRongyun:UserDefaultEntity.token];
    }
    
    dyCity=@"全国";
    paCity=@"全国";
    
    [self setSegmentedControl];
    [self build];
    
    [self createNavBtn:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startLocation];//启动定位
    [self ifAuditStatus];
    [self getHotCity];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (segment.selectedSegmentIndex ==1) {
        NSString *reflesh=[[NSUserDefaults standardUserDefaults] objectForKey:@"reflesh"];
        if (![self isBlankString:reflesh]) {
                if([paCity isEqualToString:@"全国"]){
                paCity = [NSString stringWithFormat:@""];
            }
            _careVC.cityStr=paCity;
            [_careVC.tableView.mj_header beginRefreshing];
        }
    }else{
        NSString *reflesh=[[NSUserDefaults standardUserDefaults] objectForKey:@"dyRefleshing"];
        if (![self isBlankString:reflesh]) {
            [self refleshView];
        }
    }
}

-(void)refleshView{
    _myDynamic.dyCity=@"";
    [_myDynamic.tableView.mj_header beginRefreshing];
}


-(void)ifAuditStatus{
    [HttpLoginAction OnOffTravel:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            status=[(NSNumber*)[dict objectForKey:@"result"]integerValue];
            if (status==1) {
                [self checkVersion:APP_VERSION];
            }
        }
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (segment.selectedSegmentIndex==1) {
        NSString *reflesh=[[NSUserDefaults standardUserDefaults] objectForKey:@"reflesh"];
        if (![self isBlankString:reflesh]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"reflesh"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dyRefleshing"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)checkVersion:(NSString *)appurl{
    
    [HttpBaseAction getRequest:appurl complete:^(id result, NSError *error) {
        if (error == nil && result) {
            NSArray *infoArray = [result objectForKey:@"results"];
            if (infoArray.count>0) {
                NSDictionary *releaseInfo =[infoArray objectAtIndex:0];
                NSString *appStoreVersion = [releaseInfo objectForKey:@"version"];
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                if (![appStoreVersion isEqualToString:currentVersion]){
                    
                    _trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                    NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@%@%@", @"新版本特性:",msg, @"\n是否升级？"]  delegate:self cancelButtonTitle:@"马上升级" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }else{
            NSLog(@"%@",@"获取参数失败！");
        }
    }];
}

-(void)build{
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64-49);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2,SCREEN_HEIGHT-64-49);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate=self;
    
    _scrollView.showsVerticalScrollIndicator = FALSE;
    _scrollView.showsHorizontalScrollIndicator = FALSE;

    [self.view addSubview:_scrollView];
    
    _myDynamic=[[DynamicViewController alloc]init];
    _myDynamic.dyCity=@"";
    _myDynamic.view.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-64-44);
    
    [self addChildViewController:_myDynamic];
    [_scrollView addSubview:_myDynamic.view];
    
    _careVC=[[CareViewController alloc]init];
    CGRect aframe = CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT-64-44);
    
    _careVC.view.frame =aframe;
    _careVC.cityStr=@"";
    [self addChildViewController:_careVC];
    [_scrollView addSubview:_careVC.view];
    
    [_myDynamic.tableView.mj_header beginRefreshing];
}

-(void)createNavBtn:(NSInteger)index{
    
    if (index==0) {
        
        leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-1)/6, 35)];
        [leftbtn setTitle:dyCity forState:UIControlStateNormal];
        [leftbtn setImage:[UIImage imageNamed:@"select_set"] forState:UIControlStateNormal];
        leftbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, leftbtn.titleLabel.width+35, 0, -leftbtn.titleLabel.width-35);
        leftbtn.titleLabel.font = Font(15);
        [leftbtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        [leftbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
        
        _rightBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new_fabu"] style:UIBarButtonItemStyleDone target:self action:@selector(sendDy:)];
        self.navigationItem.rightBarButtonItem=_rightBar;
        
    } else {
        
        selectCity = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-1)/6, 35)];
        [selectCity setTitle:paCity forState:UIControlStateNormal];
        if ([paCity isEqualToString:@""]) {
            [selectCity setTitle:@"全国" forState:UIControlStateNormal];
        }
        [selectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectCity setImage:[UIImage imageNamed:@"select_set"] forState:UIControlStateNormal];
        selectCity.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        
        selectCity.imageEdgeInsets = UIEdgeInsetsMake(0, selectCity.titleLabel.width+35, 0, -selectCity.titleLabel.width-35);
        selectCity.titleLabel.font = Font(15);
        [selectCity addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:selectCity];
        
        _rightBar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new_fabu"] style:UIBarButtonItemStyleDone target:self action:@selector(sendDy:)];
        self.navigationItem.rightBarButtonItem=_rightBar;
    }
}

-(void)selectCity:(id)sender{
    
    QchCityViewController *qchCity=[[QchCityViewController alloc]init];
    qchCity.cityDelegate=self;
    qchCity.citylist=_cityList;
    qchCity.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:qchCity animated:YES];
}

-(void)selectCityData:(NSString *)city{
    if (segment.selectedSegmentIndex==0 ) {
        dyCity=city;
        _myDynamic.dyCity=[NSString stringWithFormat:@"%@", city];
        if ([city isEqualToString:@""]) {
            [leftbtn setTitle:@"全国" forState:UIControlStateNormal];
            dyCity=@"全国";
            _myDynamic.dyCity=@"全国";
        }
        // 调整cityButton随内容自适应宽度
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [dyCity boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        leftbtn.titleEdgeInsets = UIEdgeInsetsZero;
        leftbtn.imageEdgeInsets = UIEdgeInsetsZero;
        leftbtn.frame = CGRectMake(0, 0, 35 + length, 35);
        [leftbtn setTitle:dyCity forState:UIControlStateNormal];
        leftbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, length, 0, -length);
        
        [_myDynamic.tableView.mj_header beginRefreshing];
    } else {
        paCity=city;
        _careVC.cityStr=[NSString stringWithFormat:@"%@",city];
        if ([city isEqualToString:@""]) {
            paCity=@"全国";
            _careVC.cityStr=@"全国";
        }
        // 调整cityButton随内容自适应宽度
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat length = [paCity boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        selectCity.titleEdgeInsets = UIEdgeInsetsZero;
        selectCity.imageEdgeInsets = UIEdgeInsetsZero;
        selectCity.frame = CGRectMake(0, 0, 35 + length, 35);
        [selectCity setTitle:paCity forState:UIControlStateNormal];
        selectCity.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        selectCity.imageEdgeInsets = UIEdgeInsetsMake(0, length, 0, -length);
        [_careVC.tableView.mj_header beginRefreshing];
    }
    
}

-(void)sendDy:(id)sender{
    ADDdynamicVC *adddy = [[ADDdynamicVC alloc]init];
    adddy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:adddy animated:YES];
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




-(void)setSegmentedControl{
    
    if (!segment) {
        
        segment = [[UISegmentedControl alloc]initWithItems:nil];
        segment.frame=CGRectMake(0, 7, 150, 30);
        segment.backgroundColor=[UIColor clearColor];
        segment.tintColor=[UIColor clearColor];
        
        //修改字体的默认颜色与选中颜色
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:TSEColor(110, 151, 245),UITextAttributeTextColor,Font(17),UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:TSEColor(158, 158, 158),UITextAttributeTextColor,Font(17),UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
        [segment setTitleTextAttributes:dic2 forState:UIControlStateNormal];
    
        [segment insertSegmentWithTitle:
         @"动态" atIndex: 0 animated: YES ];
        [segment insertSegmentWithTitle:
         @"关注" atIndex: 1 animated: YES ];
        
        segment.selectedSegmentIndex = 0;//设置默认选择项索引
        //设置跳转的方法
        [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segment;
    }
    
}
-(void)change:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
            
        case 0:{
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * Seg.selectedSegmentIndex, 0) animated:YES];
            [self createNavBtn:0];
            break;
        }
        case 1:{
            [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * Seg.selectedSegmentIndex, 0) animated:YES];
            [self createNavBtn:1];
            i++;
            if (i==1) {
                [_careVC.tableView.mj_header beginRefreshing];
            }
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        if (scrollView.contentOffset.x == 0) {
            segment.selectedSegmentIndex = 0;
            [self createNavBtn:0];
            
        }else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
            segment.selectedSegmentIndex = 1;
            [self createNavBtn:1];
            
            i++;
            if (i==1) {
                [_careVC.tableView.mj_header beginRefreshing];
            }
        }
    }
}

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
        
        Liu_DBG(@"%f,%f",self.lng,self.lat);
        
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
        UserDefaultEntity.poilist = result.poiList;
        UserDefaultEntity.city=[result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        UserDefaultEntity.district=result.addressDetail.district;
        [UserDefault saveUserDefault];
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
        alert.tag =101;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==101) {
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
        
    } else {
        if (buttonIndex ==0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_trackViewURL]];
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isNoFirstRun"];
        }
    }
}

@end
