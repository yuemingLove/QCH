//
//  TutorDetailVC.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TutorDetailVC.h"
#import "CourseListCell.h"
#import "TutorDetailCell.h"
#import "ScrollViewCell.h"
#import "RecommendCell.h"
#import "CourseViewVC.h"
#import "UINavigationBar+Background.h"

#import "ShowView.h"

@interface TutorDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,XHImageViewerDelegate>{

}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;


@property (nonatomic,strong) NSDictionary *paramsDict;

/**
 *背景图片BgImage
 */
@property(strong,nonatomic)UIImageView* BgImage;
@property (nonatomic,strong) NSMutableArray *imageViews;


/**
 *背景图片bgView
 */
@property (nonatomic,weak) UIView* bgView;

@property (nonatomic,strong) UIImageView *faceImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation TutorDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem=shareView;
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
    [self createTableView];
    [self createBgImageView];
    
}
- (void)backAction {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar cnReset];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    
    if (self.tableView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[UIColor clearColor]];
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.delegate = nil;
    if (self.tableView.contentOffset.y < -150) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar cnReset];
    }
}

-(void)createBgImageView{
    
    /**
     *创建用户空间背景图片
     */
    self.BgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT)];
    
    self.BgImage.image=[UIImage imageNamed:@"tutorBgk"];
    [self.tableView addSubview:self.BgImage];
    
    /**
     *创建用户空间背景图片的容器View
     */
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.frame=CGRectMake(0, -BGK_HEIGHT, SCREEN_WIDTH, BGK_HEIGHT);
    self.bgView=bgView;
    [self.tableView addSubview:bgView];
    
    _faceImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-70)/2, 64, 70, 70)];
    _faceImageView.layer.masksToBounds=YES;
    _faceImageView.layer.cornerRadius=_faceImageView.bounds.size.height/2;
    [self.bgView addSubview:_faceImageView];
    
    [_faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapbigImage2:)]];
    _faceImageView.userInteractionEnabled = YES;
    
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, _faceImageView.bottom+10, SCREEN_WIDTH-100, 24*SCREEN_WSCALE)];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=Font(14);
    [self.bgView addSubview:_nameLabel];
    
    _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _detailLabel.textAlignment=NSTextAlignmentCenter;
    _detailLabel.textColor=[UIColor whiteColor];
    _detailLabel.font=Font(14);
    [self.bgView addSubview:_detailLabel];
    
}

-(void)createTableView{
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor themeGrayColor]];
    //tableView.contentSize = CGSizeMake(SCREEN_WIDTH, 300);
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.contentInset=UIEdgeInsetsMake(BGK_HEIGHT, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView=tableView;
    [self.view addSubview:tableView];
    
    [self setExtraCellLineHidden:self.tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)getData{
    
    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpCollegeAction GetLecturerView:_Guid userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            
            _paramsDict=[dict objectForKey:@"result"][0];
            
            NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_paramsDict objectForKey:@"T_Lecturer_Pic"]];
            [_faceImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            
            _imageViews=[NSMutableArray new];
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(_faceImageView.frame.origin.x+_faceImageView.width/2, _faceImageView.frame.origin.y+_faceImageView.width/2, 0, 0)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
            [_imageViews addObject:imageView];
            
            _nameLabel.text=[_paramsDict objectForKey:@"T_Lecturer_Name"];
            
            NSString *position=[_paramsDict objectForKey:@"T_Lecturer_Position"];
            position=[position stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            _detailLabel.text=position;
            
            [_tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败，请重新请求" maskType:SVProgressHUDMaskTypeBlack];

        }
    }];
    
    [HttpCollegeAction GetRecommendLecturer:3 userGuid:UserDefaultEntity.uuid lecturerGuid:_Guid Token:[MyAes aesSecretWith:@"top"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }
        [_tableView reloadData];
    }];
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array=(NSArray*)[_paramsDict objectForKey:@"Pic"];
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([array count]==0) {
                return 0;
            }else{
            return 2;
            }
            break;
        case 2:
            return [_funlist count]+1;
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            return 30;
        }else{
            return 180*SCREEN_WSCALE;
        }
    } else if ( indexPath.section==2) {
        if (indexPath.row==0) {
            return 30;
        }
    }
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        TutorDetailCell *cell = (TutorDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"TutorDetailCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TutorDetailCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[TutorDetailCell class]]) {
                    cell = (TutorDetailCell *)oneObject;
                }
            }
        }
        cell.tag = indexPath.row;
        
        cell.bestLabel.text=[NSString stringWithFormat:@"教授方向:%@   课程:%ld",[[_paramsDict objectForKey:@"T_Lecturer_GoodArea"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"],[_funlist count]];
        NSString *content=[_paramsDict objectForKey:@"T_Lecturer_Intor"];
        content=[content stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
        
        cell.contentLabel.text=content;
        
        [cell setIntroductionText:content];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section==1){

        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.backgroundColor=[UIColor themeGrayColor];
            cell.textLabel.font=Font(15);
            cell.textLabel.text=@"导师展示";
            return cell;
        } else {
            ScrollViewCell *cell = (ScrollViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ScrollViewCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ScrollViewCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[ScrollViewCell class]]) {
                        cell = (ScrollViewCell *)oneObject;
                    }
                }
            }
            cell.tag = indexPath.row;
            
            NSArray *array=(NSArray*)[_paramsDict objectForKey:@"Pic"];
            
            cell.adsArray=array;
            [cell.adsView setTotalPagesCount:^NSInteger{
                return [array count];
            }];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
    }else if (indexPath.section==2){
    
        if (indexPath.row==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.backgroundColor=[UIColor themeGrayColor];
            cell.textLabel.font=Font(15);
            cell.textLabel.text=@"相关课程";
            return cell;
        } else {
        
            NSDictionary *dict=[_funlist objectAtIndex:indexPath.row-1];
            
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
            cell.Remark.text=[[dict objectForKey:@"t_Course_Instruction"]stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            cell.selectionStyle = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            return cell;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        if (indexPath.row>0) {
            NSDictionary *dict=[_funlist objectAtIndex:indexPath.row-1];
            CourseViewVC *sourseView=[[CourseViewVC alloc]init];
            sourseView.guid=[dict objectForKey:@"Guid"];
            [self.navigationController pushViewController:sourseView animated:YES];
        }
    }
}

#pragma mark - UIScrollViewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    Liu_DBG(@"%lf", yOffset);
    CGFloat xOffset = (yOffset + BGK_HEIGHT)/2;
    if (yOffset < -BGK_HEIGHT) {
        CGRect rect = self.BgImage.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        self.BgImage.frame = rect;
    }
    CGFloat alpha = MIN(1, (yOffset+BGK_HEIGHT)/BGK_HEIGHT);
    if (scrollView.contentOffset.y > -150) {
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar cnSetBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)share:(UIButton *)sender{
    
//    //启动键盘
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    //启用/禁用键盘
//    manager.enable = NO;
//    //启用/禁用键盘触摸外面
//    manager.shouldResignOnTouchOutside = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    manager.enableAutoToolbar = NO;
//    
//    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_paramsDict objectForKey:@"T_Lecturer_Pic"]];
//    
//    UIImageView *img = [[UIImageView alloc] init];
//    
//    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
//    
//    NSString *path=[NSString stringWithFormat:@"%@ShareTutor.html?guid=%@&UserGuid=%@",SHARE_HTML,_Guid,UserDefaultEntity.uuid];
//    //1、创建分享参数
//    
//    NSArray *imageArray = @[img.image];
//    
//    if (imageArray) {
//        NSString *remark = [[_paramsDict objectForKey:@"T_Lecturer_Intor"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
//        if (remark.length>140) {
//            remark = [NSString stringWithFormat:@"%@",[remark substringToIndex:140]];
//        }
//        NSString *title = [[NSString stringWithFormat:@"%@",[_paramsDict objectForKey:@"T_Lecturer_Name"]] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
//        if (title.length>50) {
//            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
//        }
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:remark
//                                         images:imageArray
//                                            url:[NSURL URLWithString:path]
//                                          title:title
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//        [ShareSDK showShareActionSheet:nil
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       //启动键盘
//                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//                       //启用/禁用键盘
//                       manager.enable = YES;
//                       //启用/禁用键盘触摸外面
//                       manager.shouldResignOnTouchOutside = YES;
//                       manager.shouldToolbarUsesTextFieldTintColor = YES;
//                       manager.enableAutoToolbar = NO;
//                       switch (state) {
//                           case SSDKResponseStateSuccess:{
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:{
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];
//    }
//    
}

- (void)tapbigImage2:(UITapGestureRecognizer *)tap{
    //  获取点击图片在父视图的位置
    UIImageView *imageView = (UIImageView*)tap.view;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    ShowView *showView = [[[NSBundle mainBundle] loadNibNamed:@"ShowView" owner:nil options:nil] firstObject];
    showView.frame = self.view.bounds;
    showView.alpha = 1;
    [window addSubview:showView];
    CGRect frame = [imageView convertRect:imageView.bounds toView:window];
    UIImageView *showImage = [[UIImageView alloc] initWithFrame:frame];
    showImage.layer.cornerRadius = showImage.height / 2;
    showImage.layer.masksToBounds = YES;
    showImage.image = imageView.image;
    [showView addSubview:showImage];
    UIImageView *showImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    showImage2.center = window.center;
    __weak typeof(showImage) photoView = showImage;
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        photoView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
        photoView.center = window.center;
        
    } completion:^(BOOL finished) {
        showImage2.image = photoView.image;
        [showView addSubview:showImage2];
    }];
    
    __weak typeof(showView) show = showView;
    [showView setBlock:^{
        [showImage2 removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            photoView.frame = frame;
            show.alpha = 0;
        }completion:^(BOOL finished) {
            [show removeFromSuperview];
        }];
    }];
}


@end
