//
//  CommentListVC.m
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CommentListVC.h"
#import "TalkViewCell.h"

@interface CommentListVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TalkViewCellDelegate,CommitAlertViewDelegate>{
    
    UIButton *sendButton;
    NSString *touserguid;
    NSString *fromGuid;
}


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *funlist;

@property (nonatomic,strong) UIView *headView;

@end

@implementation CommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"评论列表"];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    touserguid = @"";
    [self createTableView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefelshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefelshing)];
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];

    [self.tableView.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



-(void)headerRefelshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpDynamicAction GetTalk:self.Guid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:dict];
            _funlist=[NSMutableArray arrayWithArray:rdtc.result];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });
        }else{
            _funlist=[[NSMutableArray alloc]init];
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
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
            self.tableView.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }

        if ([_funlist count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];

    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerRefelshing];
}
-(void)footerRefelshing{

    if ([_funlist count] > 0 && [_funlist count] % 10 == 0) {
        
        [HttpDynamicAction GetTalk:self.Guid page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:dict];
                [_funlist addObjectsFromArray:rdtc.result];
                
                 [self.tableView reloadData];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
            }
            
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicTalkModel *model = [_funlist objectAtIndex:indexPath.row];
    
    TalkViewCell *cell = (TalkViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TalkViewCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"TalkViewCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[TalkViewCell class]]) {
                cell = (TalkViewCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    cell.deleteBtn.tag=indexPath.row;
    cell.talkdelegate=self;
    
    cell.line.hidden=YES;
    cell.line2.hidden=YES;
    [cell updateData:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicTalkModel *model = [_funlist objectAtIndex:indexPath.row];
    touserguid = model.tTalkFromUserGuid;
    if ([touserguid isEqualToString:UserDefaultEntity.uuid]) {
        
        [SVProgressHUD showErrorWithStatus:@"自己不能回复自己" maskType:SVProgressHUDMaskTypeBlack];
        touserguid = @"";
    }else{
        CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
        commit.delegate = self;
        commit.placeholder.text=[NSString stringWithFormat:@"回复%@：",model.tUserRealName];
        [self.view addSubview:commit];
    }
}
//评论
-(void)updateTextViewData:(NSString *)text{
    
    if ([self isBlankString:text]) {
        
        [SVProgressHUD showErrorWithStatus:@"评论内容不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSMutableDictionary *commit = [[NSMutableDictionary alloc]init];
    [commit setObject:UserDefaultEntity.uuid forKey:@"fromUserGuid"];
    [commit setObject:text forKey:@"fromContent"];
    [commit setObject:self.Guid forKey:@"associateGuid"];
    [commit setObject:[MyAes aesSecretWith:@"fromUserGuid"] forKey:@"Token"];
    [commit setObject:@"topic" forKey:@"type"];
    if ([self isBlankString:touserguid]) {
        [commit setObject:@"" forKey:@"toUserGuid"];
    }else{
        [commit setObject:touserguid forKey:@"toUserGuid"];
    }
    [HttpDynamicAction commonAddTalk:commit complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]){
            
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [_funlist removeAllObjects];
            [self headerRefelshing];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)cancle:(NSNotification *)text{
    
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quxiao" object:nil];
    touserguid=@"";
}


- (void)deletetalkClick:(TalkViewCell *)cell index:(NSInteger)index{
    
    DynamicTalkModel *model = [_funlist objectAtIndex:index];
    NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
    [deletedic setObject:model.guid forKey:@"talkGuid"];
    [deletedic setObject:[MyAes aesSecretWith:@"talkGuid"] forKey:@"Token"];
    [HttpDynamicAction talkdelete:deletedic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];

            [self.tableView.mj_header beginRefreshing];
        }
    }];
}


@end
