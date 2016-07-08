//
//  MessageViewController.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "MessageViewController.h"
#import "AddressBookViewController.h"
#import "MyChatViewController.h"
#import "MyChatListCell.h"
#import "AddFriendViewController.h"
#import "DiscussListViewController.h"
#import "HttpRCDAction.h"

@interface MessageViewController ()<UIAlertViewDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource>

@property (nonatomic,strong) RCConversationModel *tempModel;

@property (nonatomic,strong) NSString *senderId;

@property (nonatomic,assign) NSInteger selectrow;

- (void) updateBadgeValueForTabBarItem;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self loadDataType];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor themeGrayColor];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    /**
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleBordered target:self action:@selector(pushChat:)];
    **/
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadDataType];
}
-(void)loadDataType{
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),@(ConversationType_GROUP)]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //自定义rightBarButtonItem
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [rightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn setTintColor:[UIColor whiteColor]];
    self.tabBarController.navigationItem.rightBarButtonItem = rightButton;
    [self notifyUpdateUnreadMessageCount];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveNeedRefreshNotification:)
                                                name:@"kRCNeedReloadDiscussionListNotification"
                                              object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)showMenu:(UIButton *)sender{
    NSArray *menuItems =
    @[[KxMenuItem menuItem:@"发起聊天"
                     image:[UIImage imageNamed:@"chat_icon"]
                    target:self
                    action:@selector(pushChat:)],
      
      [KxMenuItem menuItem:@"添加好友"
                     image:[UIImage imageNamed:@"addfriend_icon"]
                    target:self
                    action:@selector(pushAddFriend:)],
      
      [KxMenuItem menuItem:@"通讯录"
                     image:[UIImage imageNamed:@"contact_icon"]
                    target:self
                    action:@selector(AddressBook:)],
      ];
    
    CGRect targetFrame = self.tabBarController.navigationItem.rightBarButtonItem.customView.frame;
    targetFrame.origin.y = targetFrame.origin.y + 15;
    [JpbbMenu showMenuInView:self.tabBarController.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}

- (void)updateBadgeValueForTabBarItem{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
        if (count>0) {
            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else {
            __weakSelf.tabBarItem.badgeValue = nil;
        }
        
    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        //同意好友请求
        RCTextMessage *message=[RCTextMessage new];
        message.content=@"同意好友请求";
        message.extra=nil;
        [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_PRIVATE targetId:self.senderId content:message pushContent:@"同意你为好友" success:^(long messageId) {
            [Utils showToastWithText:@"同意好友请求成功"];
            
            //可以从数据库删除数据
            RCConversationModel *model = self.conversationListDataSource[_selectrow];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
            [self.conversationListDataSource removeObjectAtIndex:_selectrow];
            [self.conversationListTableView reloadData];
            
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
            NSLog(@"回复参数：%ld===错误编码：%ld",messageId,nErrorCode);
        }];

    } else {
        [self setfriendWay:@"2" message:@"拒绝添加"];
    }
}

//发起会话
-(void)pushChat:(id)sender{
    
    NSArray *userArray=@[@"1a7b8a40-47b8-4b2c-8f98-045ccbd9873e",@"d1937210-9b5a-4bf0-b988-de73ae8468c3",@"aad46aa0-154c-4be1-80cc-92e9671b8c00",@"0af0094b-64f0-4921-836c-869b85b9e001"];
    
    [HttpRCDAction createDiscussion:@"青创汇" userIdList:userArray complete:^(id result, RCErrorCode *error) {
        if (error==nil) {
            [Utils showToastWithText:@"讨论组创建成功！"];
        }
    }];
    
    /**
    MyChatViewController *mychat=[[MyChatViewController alloc]init];
    mychat.conversationType=ConversationType_PRIVATE;
    mychat.targetId = @"9536cd5f-89b2-458a-8651-9fd688e3eecc"; // 接收者的 targetId，这里为举例。
    NSString *name=@"小明";
    mychat.title = name; // 接受者的 username，这里为举例。
    mychat.title = [NSString stringWithFormat:@"与%@的会话",name];
    mychat.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:mychat animated:YES];
     **/
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

    [HttpLoginAction GetUserPic:userId Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *array=(NSArray*)[dict objectForKey:@"result"];
            if ([array count]>0) {
                NSDictionary *item=array[0];
                
                RCUserInfo *user = [[RCUserInfo alloc]init];
                user.userId = [item objectForKey:@"t_User_LoginId"];
                user.name = [item objectForKey:@"t_User_RealName"];
                user.portraitUri =   [NSString stringWithFormat:@"%@%@",SERIVE_USER,[item objectForKey:@"t_User_Pic"]];
                return completion(user);
            }
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
        }else{
            [Utils showToastWithText:@"数据加载失败，请重新加载"];
        }
    }];
}

-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion{


}

-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{

}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{

}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{

    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
        MyChatViewController *_conversationVC = [[MyChatViewController alloc] init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        //_conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        MyChatViewController *_conversationVC = [[MyChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        //_conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        _conversationVC.hidesBottomBarWhenPushed=YES;
        if (model.conversationType == ConversationType_SYSTEM) {
            _conversationVC.title = @"系统消息";
        }
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        MessageViewController *temp = [[MessageViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        temp.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //自定义会话类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        if ([model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]) {
            RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
            NSString *message=[NSString stringWithFormat:@"%@",_contactNotificationMsg.message];
            self.senderId=_contactNotificationMsg.sourceUserId;
            self.selectrow=indexPath.row;
            if ([_contactNotificationMsg.operation isEqualToString:@"0"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"同意" otherButtonTitles:@"拒绝", nil];
                [alert show];
            }
        }
    }

}

//@"1a7b8a40-47b8-4b2c-8f98-045ccbd9873e"
-(void)setfriendWay:(NSString *)index message:(NSString *)message{
    
    [HttpLoginAction publishMessage:UserDefaultEntity.userId toUserGuid:self.senderId operation:index message:message Token:@"" complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            //            NSArray *array=[dict objectForKey:@"result"];
            [Utils showToastWithText:[NSString stringWithFormat:@"%@成功",message]];
        }
    }];
}


//添加好友
-(void)pushAddFriend:(id)sender{
    

    AddFriendViewController *addFriendVC=[[AddFriendViewController alloc]init];
    addFriendVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addFriendVC animated:YES];

    /**
    MyChatViewController *myChat=[[MyChatViewController alloc]init];
    
    myChat.conversationType=ConversationType_CHATROOM;
    
    //设置会话的目标会话ID
    myChat.targetId = @"chatRoomIdGetFromAppServer";
    //设置聊天会话界面要显示的标题
    myChat.title = @"青创汇聊天室";
    //设置加入聊天室时需要获取的历史消息数量，最大值为50
    myChat.defaultHistoryMessageCountOfChatRoom = 50;
    myChat.hidesBottomBarWhenPushed=YES;
    //显示聊天会话界面
    [self.navigationController pushViewController:myChat animated:YES];**/
}

//通讯录
-(void)AddressBook:(id)sender{
    AddressBookViewController *addressBook=[[AddressBookViewController alloc]init];
    addressBook.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addressBook animated:YES];
}

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]]){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    
    return dataSource;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0f;
}

//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    __block NSString *message  = nil;
    __block NSString *datetime=nil;
    
    RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;

    if (_contactNotificationMsg.sourceUserId == nil) {
        MyChatListCell *cell = [[MyChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.lblDetail.text = @"好友请求";
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
        return cell;
    }
    
    message=_contactNotificationMsg.message;
    NSString *extra=_contactNotificationMsg.extra;
    
    if (![self isBlankString:extra]) {
        NSData *data=[extra dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        userName=[dict objectForKey:@"nickname"];
        portraitUri=[dict objectForKey:@"pic"];
        datetime=[dict objectForKey:@"2016-01-14 15:37:48"];
    }

    MyChatListCell *cell = [[MyChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblName.text=userName;
    cell.lblDetail.text=[NSString stringWithFormat:@"%@%@",userName,message];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    
    cell.labelTime.text = datetime;
    return cell;
}

#pragma mark - private
- (NSString *)ConvertMessageTime:(long long)secs {
    NSString *timeText = nil;
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter stringFromDate:now];
    NSDate *yesterday = [[NSDate alloc] initWithTimeIntervalSinceNow:-(24 * 60 * 60)];
    NSString *strYesterday = [formatter stringFromDate:yesterday];
    
    NSString *_yesterday = nil;
    if ([strMsgDay isEqualToString:strToday]) {
        [formatter setDateFormat:@"HH':'mm"];
    } else if ([strMsgDay isEqualToString:strYesterday]) {
        _yesterday = NSLocalizedStringFromTable(@"Yesterday", @"RongCloudKit", nil);
        [formatter setDateFormat:@"HH:mm"];
    }
    
    if (nil != _yesterday) {
        timeText = _yesterday; //[_yesterday stringByAppendingFormat:@" %@", timeText];
    } else {
        timeText = [formatter stringFromDate:messageDate];
    }
    
    return timeText;
}


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        
        if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
            return;
        }

        NSString *extra=_contactNotificationMsg.extra;
        
        RCConversationModel *customModel = [RCConversationModel new];
        if (![self isBlankString:extra]) {
            NSData *data=[extra dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //该接口需要替换为从消息体获取好友请求的用户信息
            RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
            rcduserinfo_.name = [dict objectForKey:@"nickname"];
            rcduserinfo_.userId = _contactNotificationMsg.sourceUserId;
            rcduserinfo_.portraitUri = [dict objectForKey:@"pic"];
            
            customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            customModel.extend = rcduserinfo_;
            customModel.senderUserId = message.senderUserId;
            customModel.lastestMessage = _contactNotificationMsg;
            
            NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                          @"portraitUri":rcduserinfo_.portraitUri,
                                          @"message":_contactNotificationMsg.message
                                          };
            [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            
            [self notifyUpdateUnreadMessageCount];
        });

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
        });
    }
}

-(void)didTapCellPortrait:(RCConversationModel *)model{
    
}


- (void)notifyUpdateUnreadMessageCount{
    [self updateBadgeValueForTabBarItem];
}

- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 && [self.displayConversationTypeArray[0] integerValue]== ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
    });
}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
