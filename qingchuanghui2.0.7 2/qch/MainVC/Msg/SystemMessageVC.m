//
//  SystemMessageVC.m
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SystemMessageVC.h"
#import "MessageCell.h"
#import "ActivityDetailVC.h"
#import "DynamicstateVC.h"
#import "CarePersonListVC.h"
#import "MyProjectVC.h"
#import "MyActivityVC.h"
@interface SystemMessageVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation SystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"系统消息"];
    
    if(_funlist !=nil){
        _funlist =[[NSMutableArray alloc]init];
    }
    [self createTableView];
    // 右边barButton
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yidu_msg"] style:UIBarButtonItemStylePlain target:self action:@selector(allChoseAlert)];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerfreshing)];
    [self.view addSubview:_tableView];
    
    [self.tableView.mj_header beginRefreshing];
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=view;
}

-(void)headerfreshing{
    [HttpMessageAction GetHistoryPush:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[MessageModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
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

        }
        if ([_funlist count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerfreshing];
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
    
    MessageModel *model=[_funlist objectAtIndex:indexPath.row];
    
    MessageCell *cell = (MessageCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[MessageCell class]]) {
                cell = (MessageCell *)oneObject;
            }
        }
    }
    cell.tag=indexPath.row;
    cell.timeLabel.text=model.t_Date;
    if ([model.t_Type isEqualToString:@"activity"]) {
        cell.typeLabel.text=@"来源: 活动评论";
        cell.iconImageView.image = [UIImage imageNamed:@"huodong_msg"];
    } else if ([model.t_Type isEqualToString:@"topic"]){
        cell.typeLabel.text=@"来源: 动态评论";
        cell.iconImageView.image = [UIImage imageNamed:@"pinlun_msg"];
    } else if ([model.t_Type isEqualToString:@"fans"]){
        cell.typeLabel.text = @"来源: 粉丝";
        cell.iconImageView.image = [UIImage imageNamed:@"xitong_msg"];
    }else if ([model.t_Type isEqualToString:@"message"]){
        cell.typeLabel.text = @"来源: 系统消息";
        cell.iconImageView.image = [UIImage imageNamed:@"xitong_msg"];
    }else if ([model.t_Type isEqualToString:@"project"]){
        cell.typeLabel.text = @"来源: 项目";
        cell.iconImageView.image = [UIImage imageNamed:@"xiangmu_msg"];
    }else if ([model.t_Type isEqualToString:@"activitylist"]){
        cell.typeLabel.text = @"来源: 活动申请";
        cell.iconImageView.image = [UIImage imageNamed:@"xitong_msg"];

    } else {
        cell.typeLabel.text = nil;
        cell.iconImageView.image = [UIImage imageNamed:@"xitong_msg"];
    }
    if ([model.t_IfRead isEqualToString:@"1"]) {//t_IfRead: 0未看过, 1已经看过
        cell.badgeLabel.hidden = YES;
    }
    cell.contentLabel.text=model.t_Alert;
    [cell setIntroductionText:model.t_Alert];
    
    cell.delegate=self;
    [cell setRightUtilityButtons: [self rightButtons]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = [_funlist objectAtIndex:indexPath.row];
    // 点击查看就更改状态为已读, type:1单条已读, 2全部已读
    [self singleChoseWithModel:model indexPath:indexPath];
    if ([model.t_Type isEqualToString:@"activity"]) {
        ActivityDetailVC *activity = [[ActivityDetailVC alloc]init];
        activity.hidesBottomBarWhenPushed = YES;
        activity.guid = model.t_Associate_Guid;
        [self.navigationController pushViewController:activity  animated:YES];
    }else if ([model.t_Type isEqualToString:@"topic"]){
        DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
        dynamic.hidesBottomBarWhenPushed = YES;
        dynamic.guid = model.t_Associate_Guid;
        [self.navigationController pushViewController:dynamic animated:YES];
    }else if ([model.t_Type isEqualToString:@"fans"]){
        CarePersonListVC *carePerson=[[CarePersonListVC alloc]init];
        carePerson.hidesBottomBarWhenPushed=YES;
        carePerson.type=10;
        [self.navigationController pushViewController:carePerson animated:YES];
    }else if ([model.t_Type isEqualToString:@"project"]){
        MyProjectVC *project = [[MyProjectVC alloc]init];
        project.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:project animated:YES];
    }else if ([model.t_Type isEqualToString:@"activitylist"]){
        MyActivityVC *activity = [[MyActivityVC alloc]init];
        activity.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activity animated:YES];
    }
}


- (NSArray *)rightButtons{
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MessageModel *model=[_funlist objectAtIndex:indexPath.row];

    [self deleteMessage:model.Guid];
    
    [_funlist removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}

-(void)deleteMessage:(NSString*)Guid{
    [HttpMessageAction DelHistoryPush:Guid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
        }
    }];    
}
#pragma mark - 单选和全选
- (void)allChoseAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"全部标记已读" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self allChose];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)allChose {
    // 点击查看就更改状态为已读, type:1单条已读, 2全部已读
    [HttpMessageAction EditReadPush:UserDefaultEntity.uuid type:@"2" Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error){
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            // 全部标为已读
            [self.tableView.mj_header beginRefreshing];
        }
    }];
}
- (void)singleChoseWithModel:(MessageModel *)model indexPath:(NSIndexPath*)indexPath  {
    [HttpMessageAction EditReadPush:model.Guid type:@"1" Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error){
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            MessageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.badgeLabel.hidden = YES;
        }
    }];
}

@end
