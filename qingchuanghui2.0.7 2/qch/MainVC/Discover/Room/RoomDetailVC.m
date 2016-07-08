//
//  RoomDetailVC.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RoomDetailVC.h"
#import "AppointRoomVC.h"
#import "PresentCell.h"
#import "ProjectDetailCell.h"
#import "ServiceCell.h"
#import "HatchCell.h"
#import "ProjectDetailVC.h"
#import "PlaceProjectVC.h"
#import "RoomLocationVC.h"
#import "SelectProjectVC.h"
#import "AddProjectVC.h"

@interface RoomDetailVC ()<UITableViewDataSource,UITableViewDelegate,HatchCellDelegate,SelectProjectVCDelegate>{
    NSInteger type;
    
    TextEntity *detailEntity;
    TextEntity *rzEntity;
    TextEntity *entity;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSDictionary *roomDict;

@property (nonatomic,strong) NSMutableArray *roomLizilist;

@property (nonatomic,strong) NSMutableArray *projectlist;

@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View
@property (strong, nonatomic) NSArray *adsArray;

@end

@implementation RoomDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"空间详情"];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    if (_roomLizilist!=nil) {
        _roomLizilist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem=shareView;
    
    [self createTableView];
    
    [self updateFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateFrame{
    
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpRoomAction GetPlaceView:_Guid userGuid:UserDefaultEntity.uuid lat:[NSString stringWithFormat:@"%f",UserDefaultEntity.latitude] lng:[NSString stringWithFormat:@"%f",UserDefaultEntity.longitude] Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSDictionary *param=[dict objectForKey:@"result"][0];
            _roomDict=param;
            
            detailEntity=[TextEntity new];
            detailEntity.isShowMoreText=NO;
            detailEntity.textId=1;
            detailEntity.textName=@"详细介绍";
            detailEntity.textContent=[[param objectForKey:@"t_Place_Instruction"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            
            rzEntity=[TextEntity new];
            rzEntity.isShowMoreText=NO;
            rzEntity.textId=2;
            rzEntity.textName=@"入住条件";
            rzEntity.textContent=[[param objectForKey:@"t_Place_CheckIn"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            
            entity=[TextEntity new];
            entity.isShowMoreText=NO;
            entity.textId=3;
            entity.textName=@"政策扶持";
            entity.textContent=[[param objectForKey:@"t_Place_Policy"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
        
            NSMutableArray *array=(NSMutableArray *)[param objectForKey:@"Pic"];
            NSMutableArray *picArray=[[NSMutableArray alloc]init];
            for (NSDictionary *pic in array) {
                NSString *picStr=[pic objectForKey:@"t_Pic_Url"];
                [picArray addObject:picStr];
            }
            
            self.adsArray=[picArray copy];
            [_adsView setTotalPagesCount:^NSInteger{
                return [picArray count];
            }];
            
        }
        [self.tableView reloadData];

    }];
    
    [HttpRoomAction GetPlaceProject:_Guid top:0 Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _roomLizilist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _roomLizilist=[[NSMutableArray alloc]init];
        }else{
            _roomLizilist=[[NSMutableArray alloc]init];
            
        }
        [_tableView reloadData];

    }];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    
    {
        __weak RoomDetailVC *weakSelf=self;
        self.adsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160.0*SCREEN_WSCALE ) animationDuration:3];
        
        [_adsView setFetchContentViewAtIndex:^UIView *(NSInteger pageIndex){
            if (pageIndex < [weakSelf.adsArray count]) {
                

                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  160.0 * PMBWIDTH)];
                NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,weakSelf.adsArray[pageIndex]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
                
                [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                return imageView;
                
            }
            return [[UIView alloc] initWithFrame:CGRectZero];
        }];
        
        [_adsView setTapActionBlock:^(NSInteger pageIndex){
            if (pageIndex <[weakSelf.adsArray count]) {
                
            }
        }];
        [headerView addSubview:_adsView];
    }
    self.tableView.tableHeaderView = headerView;
    
    [self createFooterView];
}

-(void)createFooterView{

    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, 49)];
    footView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footView];
    
    CGFloat width=(SCREEN_WIDTH-2)/3;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(width, 8, 1, 33)];
    line.backgroundColor=[UIColor whiteColor];
    [footView addSubview:line];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(width*2+1, 8, 1, 33)];
    line2.backgroundColor=[UIColor whiteColor];
    [footView addSubview:line2];
    
    UIButton *talkBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, width, 30)];
    [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [talkBtn setTitle:@"路演" forState:UIControlStateNormal];
    
    [talkBtn addTarget:self action:@selector(loadShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:talkBtn];
    
    UIButton *joinRoomBtn=[[UIButton alloc]initWithFrame:CGRectMake(width+1, talkBtn.top, width, 30)];
    [joinRoomBtn setTitle:@"入驻" forState:UIControlStateNormal];
    [joinRoomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinRoomBtn addTarget:self action:@selector(joinRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:joinRoomBtn];
    
    UIButton *yuyueRoomBtn=[[UIButton alloc]initWithFrame:CGRectMake((width+1)*2, talkBtn.top, width, 30)];
    [yuyueRoomBtn setTitle:@"预约场地" forState:UIControlStateNormal];
    [yuyueRoomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yuyueRoomBtn addTarget:self action:@selector(yuyueRoom:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:yuyueRoomBtn];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2){
        NSString *text = [_roomDict objectForKey:@"t_Place_Instruction"];
        if ([self isBlankString:text]) {
             return 0;
        } else {
            return 1;
        }
    }else if (section==3){
        NSString *text = [_roomDict objectForKey:@"t_Place_CheckIn"];
        if ([self isBlankString:text]) {
            return 0;
        } else {
            return 1;
        }
    }else if (section==4){
        NSString *Policy = [_roomDict objectForKey:@"t_Place_Policy"];
        if ([self isBlankString:Policy]) {
            return 0;
        } else {
            return 1;
        }
    }else if(section==6){
        if ([_roomLizilist count]>0) {
            return 1;
        } else {
            return 0;
        }
        
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }else if(section==1 || section==4 || section==5){
        return 1*PMBWIDTH;
    } else if (section==3) {
        return 3*PMBWIDTH;
    }
    return 5*PMBWIDTH;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1){
        return 50;
    }else if (indexPath.section==6){
        CGFloat width=(SCREEN_WIDTH-100)/4;
        if ([_roomLizilist count]==0) {
            return 0;
        }else if ([_roomLizilist count]>4) {
            return 34*SCREEN_WSCALE+(width+33*SCREEN_WSCALE)*2;
        } else {
            return 67*SCREEN_WSCALE+width;
        }
    }else if(indexPath.section==2){
        //根据isShowMoreText属性判断cell的高度
        if (detailEntity.isShowMoreText){
            return [TextShowCell cellMoreHeight:detailEntity];
        }else{
            return [TextShowCell cellDefaultHeight:detailEntity];
        }
    }else if (indexPath.section==3){
        //根据isShowMoreText属性判断cell的高度
        if (rzEntity.isShowMoreText){
            return [TextShowCell cellMoreHeight:rzEntity];
        }else{
            return [TextShowCell cellDefaultHeight:rzEntity];
        }
    }else if (indexPath.section==4){
        //根据isShowMoreText属性判断cell的高度
        if (entity.isShowMoreText){
            return [TextShowCell cellMoreHeight:entity];
        }else{
            return [TextShowCell cellDefaultHeight:entity];
        }
    }else{
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        PresentCell *cell = (PresentCell *)[tableView dequeueReusableCellWithIdentifier:@"PresentCell"];
        if (cell==nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PresentCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[PresentCell class]]) {
                    cell = (PresentCell *)oneObject;
                }
            }
        }
        
        NSMutableArray *tipArray=(NSMutableArray*)[_roomDict objectForKey:@"Tips"];
        NSString *tip=nil;
        for (NSDictionary *tipDict in tipArray) {
            if ([self isBlankString:tip]) {
                tip=[tipDict objectForKey:@"TipName"];
            }else{
                tip=[tip stringByAppendingFormat:@"/%@",[tipDict objectForKey:@"TipName"]];
            }
        }
        
        cell.RoomName.text=[_roomDict objectForKey:@"t_Place_Name"];
        cell.RoomRmark.text=[_roomDict objectForKey:@"t_Place_OneWord"];
        cell.RoomTrans.text=tip;
        [cell setIntroductionText:[_roomDict objectForKey:@"t_Place_OneWord"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.imageView.image = [UIImage imageNamed:@"dibiao_img"];
        cell.textLabel.text = [_roomDict objectForKey:@"t_Place_Street"];
        cell.textLabel.font=Font(14);
        cell.textLabel.textColor = [UIColor themeBlueTwoColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section==2){
        
        static NSString *identifier = @"cell";
        TextShowCell *cell = (TextShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[TextShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //这里的判断是为了防止数组越界
        cell.entity = detailEntity;
        //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
        cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
            NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;

    }else if (indexPath.section==3){
        static NSString *identifier = @"cell";
        TextShowCell *cell = (TextShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[TextShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //这里的判断是为了防止数组越界
        cell.entity = rzEntity;
        //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
        cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
            NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;

    }else if (indexPath.section==4){
        static NSString *identifier = @"cell";
        TextShowCell *cell = (TextShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[TextShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //这里的判断是为了防止数组越界
        cell.entity = entity;
        //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
        cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
            NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;

    }else if (indexPath.section==5){
        
        ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
        if (cell==nil) {
            cell = [[ServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceCell"];
        }
        cell.titleLab.text = @"提供服务";
        NSMutableArray *array=(NSMutableArray*)[_roomDict objectForKey:@"ProvideService"];
        [cell updateData:array];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section==6){
        HatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HatchCell"];
        if (cell==nil) {
            cell = [[HatchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HatchCell"];
        }
        cell.type=2;
        cell.hatchDelegate=self;
        [cell updateData:_roomLizilist];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)moreProject:(HatchCell*)cell index:(NSInteger)index{
    
    PlaceProjectVC *placeProject=[[PlaceProjectVC alloc]init];
    placeProject.guid=_Guid;
    placeProject.type=index;
    [self.navigationController pushViewController:placeProject animated:YES];
}

-(void)selectProject:(HatchCell*)cell index:(NSInteger)index{

    NSDictionary *dict=[_roomLizilist objectAtIndex:index];
    ProjectDetailVC *projectDetail=[[ProjectDetailVC alloc]init];
    projectDetail.guId=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:projectDetail animated:YES];
}

-(void)loadShow:(id)sender{
    
    type=1;

    [HttpCenterAction GetMyProject:UserDefaultEntity.uuid ifAudit:1 page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _projectlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
            if ([_projectlist count]>0) {
                
                SelectProjectVC *selectProject=[[SelectProjectVC alloc]init];
                selectProject.spDelegate=self;
                selectProject.funlist=_projectlist;
                [self.navigationController pushViewController:selectProject animated:NO];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];
            }
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _projectlist=[[NSMutableArray alloc]init];
            
            [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];

        }else{
            _projectlist=[[NSMutableArray alloc]init];
            
        }
    }];

}

-(void)joinRoomBtn:(id)sender{
    type=0;

    [HttpCenterAction GetMyProject:UserDefaultEntity.uuid ifAudit:-1 page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _projectlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
            if ([_projectlist count]>0) {
                
                SelectProjectVC *selectProject=[[SelectProjectVC alloc]init];
                selectProject.spDelegate=self;
                selectProject.funlist=_projectlist;
                [self.navigationController pushViewController:selectProject animated:NO];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];
            }
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _projectlist=[[NSMutableArray alloc]init];
            
                [SVProgressHUD showErrorWithStatus:@"请先添加项目，等审核通过以后才能提交项目" maskType:SVProgressHUDMaskTypeBlack];

        }else{
            _projectlist=[[NSMutableArray alloc]init];
            
        }
    }];
}


-(void)selectProject:(NSString *)projectGuid{
    
    [HttpRoomAction AddSendProject:UserDefaultEntity.uuid projectGuid:projectGuid placeGuid:[_roomDict objectForKey:@"Guid"] type:type Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


-(void)yuyueRoom:(id)sender{
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
    [HttpRoomAction GetPlaceStyle:_Guid Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD dismiss];
            AppointRoomVC *appointRoom=[[AppointRoomVC alloc]init];
            appointRoom.Placelist= [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
            [self.navigationController pushViewController:appointRoom animated:YES];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"不好意思，暂时没有可以预约的空间" maskType:SVProgressHUDMaskTypeBlack];
        }else{
           
        }
    }];
}

- (void)shareAction:(id)sender{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    NSMutableArray *array=(NSMutableArray *)[_roomDict objectForKey:@"Pic"];
    NSString *picStr=[[array objectAtIndex:0] objectForKey:@"t_Pic_Url"];
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,picStr];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@SharePlace.html?Guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
        NSString *title = [NSString stringWithFormat:@"青创汇平台入驻创客空间推荐 %@",[_roomDict objectForKey:@"t_Place_Name"]];
        NSString *oneword = [[_roomDict objectForKey:@"t_Place_Instruction"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
        NSString *description = [NSString stringWithFormat:@"%@,坐落于%@,%@",[_roomDict objectForKey:@"t_Place_Name"],[_roomDict objectForKey:@"t_Place_CityName"],oneword];
        if (description.length>140) {
            description = [NSString stringWithFormat:@"%@",[description substringToIndex:140]];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

        [shareParams SSDKSetupShareParamsByText:description
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@",title]
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
                           case SSDKResponseStateSuccess:{
                               [self ShareIntegral:@"8"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        RoomLocationVC *roomLocation=[[RoomLocationVC alloc]init];
        roomLocation.lat=[(NSNumber*)[_roomDict objectForKey:@"t_Place_Latitude"]floatValue];
        roomLocation.lng=[(NSNumber*)[_roomDict objectForKey:@"t_Place_Longitude"]floatValue];
        roomLocation.theme=[_roomDict objectForKey:@"t_Place_Name"];
        [self.navigationController pushViewController:roomLocation animated:YES];
    }
}

@end
