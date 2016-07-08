//
//  MyMessageVC.m
//  qch
//
//  Created by 苏宾 on 16/2/29.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyMessageVC.h"
#import "MessageViewController.h"
#import "SystemMessageVC.h"
#import "AppDelegate.h"
#import "QCHMainController.h"
#import "MsgCell.h"
@interface MyMessageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, strong) NSDictionary *titles;
@property (nonatomic, assign) NSInteger JPUSHUnreadMsgCount;// 系统消息条数

@end

@implementation MyMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息"];

    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    self.modules = @[@[@"jPush_msg"],@[@"system_msg",@"qch_msg"]];
    
    self.titles = @{@"qch_msg":@"聊天消息",
                    @"system_msg":@"系统消息",
                    @"jPush_msg":@"青创小助手"};
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgCell" bundle:nil] forCellReuseIdentifier:@"DefaultCell"];
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView*)tableView{

    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    _tableView.tableFooterView=view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modules.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_modules objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:module];
    cell.titleLabel.font = [UIFont systemFontOfSize:17];
    cell.titleLabel.text = [self.titles objectForKey:module];
    // 角标
     if ([cell.titleLabel.text isEqualToString:@"青创小助手"]) {
        cell.badgeLabel.hidden = YES;
        cell.badgeLabel.text = @"8";
    } else if ([cell.titleLabel.text isEqualToString:@"系统消息"]) {
        if (self.JPUSHUnreadMsgCount == 0) {
            cell.badgeLabel.text = nil;
            cell.badgeLabel.hidden = YES;
        } else if (self.JPUSHUnreadMsgCount < 100) {
            cell.badgeLabel.hidden = NO;
            cell.badgeLabel.text = [NSString stringWithFormat:@"%ld", self.JPUSHUnreadMsgCount];
        } else {
            cell.badgeLabel.hidden = NO;
            cell.badgeLabel.text = @"99+";
        }
    } else if ([cell.titleLabel.text isEqualToString:@"聊天消息"]) {
        if ([self returnRCIMClientUnreadMsgCount] == 0) {
            cell.badgeLabel.text = nil;
            cell.badgeLabel.hidden = YES;
        } else if ([self returnRCIMClientUnreadMsgCount] < 100) {
            cell.badgeLabel.hidden = NO;
            cell.badgeLabel.text = [NSString stringWithFormat:@"%ld", [self returnRCIMClientUnreadMsgCount]];
        } else {
            cell.badgeLabel.hidden = NO;
            cell.badgeLabel.text = @"99+";
        }
    } else {}
    // label自适应宽度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize labelsize = [cell.badgeLabel.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], } context:nil].size;
        if ([cell.badgeLabel.text isEqualToString:@"1"]) {
            [cell.badgeLabel setFrame:CGRectMake(34 * PMBWIDTH, 2, labelsize.width + 10.4, labelsize.height)];
        } else if (!cell.badgeLabel.text) {
            [cell.badgeLabel setFrame:CGRectZero];
        } else {
            [cell.badgeLabel setFrame:CGRectMake(34 * PMBWIDTH, 2, labelsize.width + 8.1, labelsize.height)];
        }
        Liu_DBG(@"%lf-----%lf", labelsize.width, labelsize.height);
        cell.badgeLabel.layer.cornerRadius = labelsize.height / 2;
        cell.badgeLabel.layer.masksToBounds = YES;
    });
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([module isEqualToString:@"qch_msg"]) {
        MessageViewController *messageVC=[[MessageViewController alloc]init];
        messageVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if ([module isEqualToString:@"system_msg"]){
        SystemMessageVC *messageVC=[[SystemMessageVC alloc]init];
        messageVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if ([module isEqualToString:@"jPush_msg"]){
        MyChatViewController *myChat=[[MyChatViewController alloc]init];
        myChat.conversationType=ConversationType_PRIVATE;
        myChat.targetId=@"30bad6c8-88ab-4d82-967c-1764a91acc9e";
        myChat.title = @"青创小助手";
        myChat.type=1;
        myChat.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myChat animated:YES];
    }
}
#pragma mark - 消息推送
- (NSInteger)returnRCIMClientUnreadMsgCount {
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    return unreadMsgCount;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self returnJPUSHUnreadMsgCount];
//------------
    // 实时更新角标
    [((QCHMainController *)self.navigationController.parentViewController) setBadgeBlock:^{
        [self returnJPUSHUnreadMsgCount];
    }];

}
- (void)returnJPUSHUnreadMsgCount {
    // 数据请求
    [HttpMessageAction GetMessageCount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error){
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            Liu_DBG(@"%@", dict[@"result"]);
            NSInteger badge = [dict[@"result"] integerValue];
            self.JPUSHUnreadMsgCount = badge;
            [self.tableView reloadData];

            // 更改item的角标值
            badge = badge + [self returnRCIMClientUnreadMsgCount];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badge];
            if (badge > 0 && badge <= 99) {
                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badge];
            } else if (badge > 99) {
                self.navigationController.tabBarItem.badgeValue = @"99+";
            } else {
                self.navigationController.tabBarItem.badgeValue = nil;
            }
            // 更改icon角标
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }
    }];
}
@end
