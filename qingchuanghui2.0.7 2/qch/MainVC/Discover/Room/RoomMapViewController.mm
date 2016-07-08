//
//  RoomMapViewController.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RoomMapViewController.h"
#import "RoomDetailVC.h"

@interface RoomMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>{
    
    UIImageView *imageView;
    UILabel *roomName;
    UILabel *oneLabel;
    UILabel *detailLabel;

    //初始化电子围栏坐标点
    CLLocationCoordinate2D coord;
    
    CLLocationCoordinate2D coorder;
    
    BMKPointAnnotation *pointAnnotation;
}

@property (nonatomic, strong) BMKMapView *mapView;
@property (strong, nonatomic) BMKGeoCodeSearch *geododesearch;

@property (nonatomic,strong) NSDictionary *selectDict;

@end

@implementation RoomMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"空间位置"];
    
    [self networkRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshLocationData];
}

-(void)networkRequest{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == NotReachable) {
        [Utils showAlertView:@"温馨提示" :@"您的网络目前不可用，请联网后重试..." :@"知道了"];
    }else{
        coord.latitude  =UserDefaultEntity.latitude;
        coord.longitude = UserDefaultEntity.longitude;
        
        [_mapView setCenterCoordinate:coord];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil;
    _geododesearch.delegate = nil;
}

- (void)refreshLocationData{
    
    _geododesearch = [[BMKGeoCodeSearch alloc] init];
    
    _mapView =[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64-100)];
    _mapView.zoomLevel = 12;
    [_mapView setCenterCoordinate:coord];
    [self.view addSubview:_mapView];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coord;
    [_geododesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    _mapView.delegate = self;
    _geododesearch.delegate = self;
    
    coord = CLLocationCoordinate2DMake(UserDefaultEntity.latitude, UserDefaultEntity.longitude);
    
    [self createFooterView];
    
    if ([_positionlist count]>0) {
        NSDictionary *dict=[_positionlist objectAtIndex:0];
        _selectDict=dict;
        [self updateFrame:dict];
    }

}

-(void)createFooterView{
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _mapView.bottom, SCREEN_WIDTH, 100)];
    footerView.backgroundColor=[UIColor themeGrayColor];
    [self.view addSubview:footerView];
 
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageView.layer.masksToBounds=YES;
    imageView.layer.cornerRadius=imageView.height/2;
    [footerView addSubview:imageView];
    
    UIButton *jumpBtn=[[UIButton alloc]initWithFrame:imageView.frame];
    [jumpBtn addTarget:self action:@selector(jumpDetal:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:jumpBtn];
    
    roomName=[self createLabelFrame:CGRectMake(imageView.right+10, imageView.top, 160, 20) color:[UIColor blackColor] font:Font(14) text:@"空间名称"];
    [footerView addSubview:roomName];
    
    UIButton *daohangBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    daohangBtn.frame=CGRectMake(SCREEN_WIDTH-70, roomName.top, 60, 30);
    [daohangBtn setTitle:@"导航" forState:UIControlStateNormal];
    [daohangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    daohangBtn.layer.cornerRadius=4;
    daohangBtn.titleLabel.font=Font(14);
    daohangBtn.backgroundColor=[UIColor blueColor];
    [daohangBtn addTarget:self action:@selector(daohang:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:daohangBtn];
    
    oneLabel=[self createLabelFrame:CGRectMake(roomName.left, roomName.bottom+10, SCREEN_WIDTH-110, 20) color:[UIColor themeBlueTwoColor] font:Font(12) text:@"一句话描述"];
    [footerView addSubview:oneLabel];
    
    detailLabel=[self createLabelFrame:CGRectMake(roomName.left, oneLabel.bottom+10, SCREEN_WIDTH-110, 20) color:[UIColor lightGrayColor] font:Font(12) text:@"Ta的服务"];
    [footerView addSubview:detailLabel];
    
    
}

-(void)jumpDetal:(UIButton*)sender{
    RoomDetailVC *roomDetail=[[RoomDetailVC alloc]init];
    roomDetail.Guid=[_selectDict objectForKey:@"Guid"];
    [self.navigationController pushViewController:roomDetail animated:YES];
}

-(void)daohang:(UIButton*)sneder{
    
    double latitude=[(NSNumber*)[_selectDict objectForKey:@"t_Place_Latitude"]floatValue];
    double longitude=[(NSNumber*)[_selectDict objectForKey:@"t_Place_Longitude"]floatValue];
    
    [self jumpToBaiduMapAppForMark:latitude longitude:longitude title:nil content:nil];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = NO;
            // 设置可拖拽
            annotationView.draggable = NO;
        }
        return annotationView;
    }
    
    NSString *AnnotationViewID        = @"annotationViewID";
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorPurple;
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    
    annotationView.image          = [UIImage imageNamed:@"gps_icon_n.png"];
    annotationView.centerOffset   = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation     = annotation;
    annotationView.canShowCallout = TRUE;
    
    return annotationView;
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
//    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
    
//    array = [NSArray arrayWithArray:_mapView.overlays];
    if (error == 0) {
        
        for (NSDictionary *dict in _positionlist) {

            double latitude=[(NSNumber*)[dict objectForKey:@"t_Place_Latitude"]floatValue];
            double longitude=[(NSNumber*)[dict objectForKey:@"t_Place_Longitude"]floatValue];
            NSString *address=[dict objectForKey:@"t_Place_Street"];
            
            
            pointAnnotation=[[BMKPointAnnotation alloc] init];
            pointAnnotation.coordinate=CLLocationCoordinate2DMake(latitude, longitude);
            pointAnnotation.title=address;
            
            [_mapView addAnnotation:pointAnnotation];
            
        }
    }
}

// 当双击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
    BMKPointAnnotation *annotation=view.annotation;
    
    [self jumpToBaiduMapAppForMark:annotation.coordinate.latitude longitude:annotation.coordinate.longitude title:nil content:nil];
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    BMKPointAnnotation *annotation=view.annotation;
    
    float latitude=annotation.coordinate.latitude;
    float longitude=annotation.coordinate.longitude;
    for (NSDictionary *dict in _positionlist) {
        
        double latitude2=[(NSNumber*)[dict objectForKey:@"t_Place_Latitude"]floatValue];
        double longitude2=[(NSNumber*)[dict objectForKey:@"t_Place_Longitude"]floatValue];
        
        if (latitude==latitude2 && longitude==longitude2 ) {
            
            _selectDict=dict;
            
            [self updateFrame:dict];
        }
    }
}

-(void)updateFrame:(NSDictionary*)dict{
    NSDictionary *item=[dict objectForKey:@"Pic"][0];
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[item objectForKey:@"t_Pic_Url"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    
    NSMutableArray *ProvideArray=(NSMutableArray*)[dict objectForKey:@"ProvideService"];
    NSString *provide=nil;
    for (NSDictionary *provideDict in ProvideArray) {
        if ([self isBlankString:provide]) {
            provide=[provideDict objectForKey:@"ServiceName"];
        }else{
            provide=[provide stringByAppendingFormat:@"/%@",[provideDict objectForKey:@"ServiceName"]];
        }
    }

    roomName.text=[dict objectForKey:@"t_Place_Name"];
    oneLabel.text=[dict objectForKey:@"t_Place_OneWord"];
    if (![self isBlankString:provide]) {
        detailLabel.text=[NSString stringWithFormat:@"Ta的项目:%@",provide];
    }else{
        detailLabel.text=@"";
    }
    
    coord.latitude  =[(NSNumber*)[dict objectForKey:@"t_Place_Latitude"]floatValue];
    coord.longitude = [(NSNumber*)[dict objectForKey:@"t_Place_Longitude"]floatValue];
    
    [_mapView setCenterCoordinate:coord];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:@"itms://itunes.apple.com/gb/app/bai-du-tu-zhuan-ye-shou-ji/id452186370?mt=8"]];
}

- (BOOL)jumpToBaiduMapAppForMark:(double)latitude longitude:(double)longitude title:(NSString*) title content:(NSString*)content{

    
    NSString *stringURL = [NSString stringWithFormat: @"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving&src=qq",UserDefaultEntity.latitude,UserDefaultEntity.longitude,latitude,longitude];
    
    NSString *urlString = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *mapUrl = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:mapUrl]) {
        [[UIApplication sharedApplication] openURL:mapUrl];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请安装百度地图!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    return YES;
}


@end
