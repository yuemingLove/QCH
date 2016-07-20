//
//  LiveOnlineListVC.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "LiveOnlineListVC.h"
#import "VideoCell.h"
#import "CourseDetailVC.h"

@interface LiveOnlineListVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *currentIndexPath;
}

@property(nonatomic,retain)VideoCell *currentCell;
@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic, strong) ZFPlayerView   *playerView;

@end

@implementation LiveOnlineListVC

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播列表";
    [self creatTableview];
    if (_listArray!=nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    
    [self.tableviewlist registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refeleshController];
}

- (void)creatTableview
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableviewlist = tableView;
    self.tableviewlist.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableviewlist.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:tableView];
    [self setExtraCellLineHidden:self.tableviewlist];
    
}


-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableviewlist.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableviewlist.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableviewlist.mj_footer resetNoMoreData];
    }
    [HttpCollegeAction GetLiveMedia:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"page"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _listArray = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            _listArray = [[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableviewlist.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableviewlist.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });

        }else{
            _listArray = [[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableviewlist.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            UILabel *tixinglab = [[UILabel alloc]initWithFrame:CGRectMake(0, empty.bottom+5*PMBWIDTH, ScreenWidth, 20*PMBWIDTH)];
            tixinglab.text = @"加载失败，触屏重新加载";
            tixinglab.textColor = [UIColor lightGrayColor];
            tixinglab.font = Font(15);
            tixinglab.textAlignment = NSTextAlignmentCenter;
            [emptyView addSubview:tixinglab];
            [emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)]];
            self.tableviewlist.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
        if ([_listArray count]>0) {
            self.tableviewlist.tableHeaderView = nil;
        }
        [self.tableviewlist.mj_header endRefreshing];
        [self.tableviewlist reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}
- (void)footerFreshing{
    
    if ([_listArray count]>0 && [_listArray count] % PAGESIZE == 0) {
        [HttpCollegeAction GetLiveMedia:[_listArray count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"page"] complete:^(id result, NSError *error) {
            NSDictionary *dict = result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                
                [_listArray addObjectsFromArray:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                _listArray = [[NSMutableArray alloc]init];
                
            }else{
                 [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
            }
            [self.tableviewlist reloadData];
            [self.tableviewlist.mj_footer endRefreshing];
            
        }];
    }else{
          [self.tableviewlist.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listArray count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 274;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCell *cell                 = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    NSDictionary *dict              = [_listArray objectAtIndex:indexPath.row];
    [cell updateFrame:dict];

    
    __block NSIndexPath *weakIndexPath = indexPath;
    __block VideoCell *weakCell        = cell;
    __weak typeof(self) weakSelf       = self;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        Reachability *wifi=[Reachability reachabilityForLocalWiFi];
        if ([wifi currentReachabilityStatus] == ReachableViaWiFi) {//wifi下自动创建
            weakSelf.playerView = [ZFPlayerView sharedPlayerView];
            // 设置播放前的站位图（需要在设置视频URL之前设置）
            weakSelf.playerView.placeholderImageName = @"loading_bgView1";
            
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[dict objectForKey:@"t_Live_Url"]]];
            // 设置player相关参数(需要设置imageView的tag值，此处设置的为101)
            [weakSelf.playerView setVideoURL:videoURL
                               withTableView:weakSelf.tableviewlist
                                 AtIndexPath:weakIndexPath
                            withImageViewTag:101];
            [weakSelf.playerView addPlayerToCellImageView:weakCell.backgroundIV];
            
            //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
            weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
            // 自动播放
            [weakSelf.playerView autoPlayTheVideo];
        }else if ([wifi currentReachabilityStatus] == ReachableViaWWAN){// 流量下给提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前网络非Wi-Fi，是否继续播放" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.playerView = [ZFPlayerView sharedPlayerView];
            // 设置播放前的站位图（需要在设置视频URL之前设置）
            weakSelf.playerView.placeholderImageName = @"loading_bgView1";
            
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[dict objectForKey:@"t_Live_Url"]]];
            // 设置player相关参数(需要设置imageView的tag值，此处设置的为101)
            [weakSelf.playerView setVideoURL:videoURL
                               withTableView:weakSelf.tableviewlist
                                 AtIndexPath:weakIndexPath
                            withImageViewTag:101];
            [weakSelf.playerView addPlayerToCellImageView:weakCell.backgroundIV];
            
            //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
            weakSelf.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
            // 自动播放
            [weakSelf.playerView autoPlayTheVideo];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"暂停播放" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancleAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    };
    
    return cell;
}

@end
