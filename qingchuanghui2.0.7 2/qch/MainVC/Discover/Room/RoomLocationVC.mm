//
//  RoomLocationVC.m
//  qch
//
//  Created by 苏宾 on 16/2/29.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RoomLocationVC.h"

@interface RoomLocationVC ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>{
    
    //初始化电子围栏坐标点
    CLLocationCoordinate2D coord;
    BMKPointAnnotation* pointAnnotation;
}

@property (nonatomic, strong) BMKMapView *mapView;
@property (strong, nonatomic) BMKGeoCodeSearch *geododesearch;


@end

@implementation RoomLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.theme];
    
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
        coord.latitude  =self.lat;
        coord.longitude = self.lng;
        
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
    
    _mapView =[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64)];
    _mapView.zoomLevel = 17;
    [_mapView setCenterCoordinate:coord];
    [self.view addSubview:_mapView];
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coord;
    [_geododesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    _mapView.delegate = self;
    _geododesearch.delegate = self;
    
    coord = CLLocationCoordinate2DMake(self.lat, self.lng);
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
    
    NSArray *array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    array = [NSArray arrayWithArray:_mapView.overlays];
    if (error == 0) {
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc] init];
        item.coordinate = result.location;
        item.title = [NSString stringWithFormat:@"%@",result.address];
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        [self addPointAnnotation:coord];
    }
}

-(void)addPointAnnotation:(CLLocationCoordinate2D)coordor{
    
    pointAnnotation=[[BMKPointAnnotation alloc] init];
    pointAnnotation.coordinate=coordor;
    
    [_mapView addAnnotation:pointAnnotation];
    
}

@end
