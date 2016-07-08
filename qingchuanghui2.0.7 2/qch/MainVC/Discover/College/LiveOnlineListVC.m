//
//  LiveOnlineListVC.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "LiveOnlineListVC.h"
#import "VideoCell.h"
#import "WMPlayer.h"
#import "CourseDetailVC.h"

@interface LiveOnlineListVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *currentIndexPath;
    WMPlayer *wmPlayer;
}

@property(nonatomic,retain)VideoCell *currentCell;
@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong)NSMutableArray *listArray;

@end

@implementation LiveOnlineListVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

-(void)videoDidFinished:(NSNotification *)notice{
    [self setFullScreen:NO];
    VideoCell *currentCell = (VideoCell *)[self.tableviewlist cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self releaseWMPlayer];
    [wmPlayer removeFromSuperview];
    
}

-(void)closeTheVideo:(NSNotification *)obj{
    
    VideoCell *currentCell = (VideoCell *)[self.tableviewlist cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row inSection:0]];
    [currentCell.playBtn.superview bringSubviewToFront:currentCell.playBtn];
    [self releaseWMPlayer];
    [self setFullScreen:NO];
    
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                    [self toCell];
                
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)toCell{
    
    VideoCell *currentCell = [self currentCell];
    
    [wmPlayer removeFromSuperview];
    NSLog(@"row = %ld",(long)currentIndexPath.row);
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = currentCell.backgroundIV.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [currentCell.backgroundIV addSubview:wmPlayer];
        [currentCell.backgroundIV bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
            
        }];
        
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
       [self setFullScreen:NO];
        
    }];
    
}


-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [self setFullScreen:YES];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    

}

- (void)setFullScreen:(BOOL)fullScreen
{
    [UIApplication sharedApplication].statusBarHidden = fullScreen;
    [self.navigationController setNavigationBarHidden:fullScreen];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播列表";
    [self creatTableview];
    if (_listArray!=nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    
    [self.tableviewlist registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:@"VideoCell"];
    
    //关闭通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeTheVideo:)
                                                 name:@"closeTheVideo"
                                               object:nil
     ];

    
}

-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
            [self toCell];
    }
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
    
    static NSString *identifier = @"VideoCell";
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    [cell.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    cell.playBtn.tag = indexPath.row;
    
    if (wmPlayer&&wmPlayer.superview) {
        if (indexPath==currentIndexPath) {
            [cell.playBtn.superview sendSubviewToBack:cell.playBtn];
        }else{
            [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
        }
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
        if (![indexpaths containsObject:currentIndexPath]) {//复用
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]) {
                wmPlayer.hidden = NO;
                
            }else{
                wmPlayer.hidden = YES;
                [cell.playBtn.superview bringSubviewToFront:cell.playBtn];
            }
        }else{
            if ([cell.backgroundIV.subviews containsObject:wmPlayer]) {
                [cell.backgroundIV addSubview:wmPlayer];
                
                [wmPlayer.player play];
                wmPlayer.playOrPauseBtn.selected = NO;
                wmPlayer.hidden = NO;
            }
            
        }
    }
    [cell updateFrame:dict];
    return cell;


    

}

-(void)startPlayVideo:(UIButton *)sender{
    
    currentIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"currentIndexPath.row = %ld",currentIndexPath.row);
    
    self.currentCell = (VideoCell *)sender.superview.superview;
    NSDictionary *dict = [_listArray objectAtIndex:sender.tag];
    if (wmPlayer) {
        [wmPlayer removeFromSuperview];
        [wmPlayer setVideoURLStr:[NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[dict objectForKey:@"t_Live_Url"]]];
        [wmPlayer.player play];
        
    }else{
        wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.backgroundIV.bounds videoURLStr:[NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[dict objectForKey:@"t_Live_Url"]]];
        [wmPlayer.player play];
        
    }
    [self.currentCell.backgroundIV addSubview:wmPlayer];
    [self.currentCell.backgroundIV bringSubviewToFront:wmPlayer];
    [self.currentCell.playBtn.superview sendSubviewToBack:self.currentCell.playBtn];
    [self.tableviewlist reloadData];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    currentIndexPath = nil;
}

-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self releaseWMPlayer];
}

@end
