//
//  MyChatViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyChatViewController.h"
#import "RCDPrivateSettingViewController.h"
#import "RCDRoomSettingViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MyChatViewController ()<UIActionSheetDelegate, UIAlertViewDelegate, RCMessageCellDelegate>

@end

@implementation MyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    
    self.enableSaveNewPhotoToLocalSystem = YES;
    
    if (self.conversationType != ConversationType_CHATROOM) {
        if (self.conversationType == ConversationType_DISCUSSION) {
            [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
                if (discussion != nil && discussion.memberIdList.count>0) {
                    if ([discussion.memberIdList containsObject:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        
                        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
                        self.navigationItem.rightBarButtonItem=right;
                        
                        
                    }else{
                        self.navigationItem.rightBarButtonItem = nil;
                    }
                }
            } error:^(RCErrorCode status) {
                
            }];
        }else{
            UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
            self.navigationItem.rightBarButtonItem=right;
        }
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (_type==1) {
//        [self sendSystemMessage];
    }
    
    [self registerClass:[RCUnknownMessageCell class] forCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier];
    
    /******************实时地理位置共享**************/
    
//    [self notifyUpdateUnreadMessageCount];
    
    //如果是单聊，不显示发送方昵称
    if (self.conversationType == ConversationType_PRIVATE) {
        self.displayUserNameInCell = NO;
    }
    
    //打开单聊强制从demo server 获取用户信息更新本地数据库
    if (self.conversationType == ConversationType_PRIVATE) {
        [self getUserInfoWithUserId:self.targetId completion:^(RCUserInfo *userInfo) {
            if (_type==1) {
                self.navigationItem.title = @"青创小助手";
            } else {
                self.navigationItem.title = userInfo.name;
            }
            [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:userInfo.userId];
        }];
    }
}

//配置用户头像
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

    [HttpLoginAction GetUserPic:userId Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
        
            NSDictionary *item=[dict objectForKey:@"result"][0];
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = [item objectForKey:@"t_User_LoginId"];
            user.name = [item objectForKey:@"t_User_RealName"];
            user.portraitUri =   [NSString stringWithFormat:@"%@%@",SERIVE_USER,[item objectForKey:@"t_User_Pic"]];
            return completion(user);

            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)sendSystemMessage{

    RCTextMessage *message=[RCTextMessage new];
    message.content=@"尊敬的客户，您好！请问有什么可以帮助您的吗？";
    message.extra=nil;

    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:UserDefaultEntity.userId content:message pushContent:nil success:^(long messageId) {
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"回复参数：%ld===错误编码：%ld",messageId,nErrorCode);
    }];
}

- (void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popupChatViewController {
    [super leftBarButtonItemPressed:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonClicked {
    if (self.conversationType == ConversationType_PRIVATE) {
        
        RCDPrivateSettingViewController *settingVC =
        [[RCDPrivateSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;

        __weak MyChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
        
    } else if (self.conversationType == ConversationType_DISCUSSION) {
        
        RCDDiscussGroupSettingViewController *settingVC =
        [[RCDDiscussGroupSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        settingVC.conversationTitle = self.title;
        //设置讨论组标题时，改变当前聊天界面的标题
        settingVC.setDiscussTitleCompletion = ^(NSString *discussTitle) {
            self.title = discussTitle;
        };
        //清除聊天记录之后reload data
        __weak MyChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    //聊天室设置
    else if (self.conversationType == ConversationType_CHATROOM) {
        RCDRoomSettingViewController *settingVC =
        [[RCDRoomSettingViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
        //客服设置
    else if (self.conversationType == ConversationType_CUSTOMERSERVICE) {
        RCDSettingBaseViewController *settingVC = [[RCDSettingBaseViewController alloc] init];
        settingVC.conversationType = self.conversationType;
        settingVC.targetId = self.targetId;
        //清除聊天记录之后reload data
        __weak MyChatViewController *weakSelf = self;
        settingVC.clearHistoryCompletion = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf.conversationDataRepository removeAllObjects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.conversationMessageCollectionView reloadData];
                });
            }
        };
        [self.navigationController pushViewController:settingVC animated:YES];
    }
        else if (ConversationType_APPSERVICE == self.conversationType ||
              ConversationType_PUBLICSERVICE == self.conversationType) {
        RCPublicServiceProfile *serviceProfile = [[RCIMClient sharedRCIMClient]
                                                  getPublicServiceProfile:(RCPublicServiceType)self.conversationType
                                                  publicServiceId:self.targetId];
        
        RCPublicServiceProfileViewController *infoVC =
        [[RCPublicServiceProfileViewController alloc] init];
        infoVC.serviceProfile = serviceProfile;
        infoVC.fromConversation = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}


/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"(%d)", count];
        } else if (count >= 1000) {
            backString = @"(...)";
        } else {
            backString = @"";
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 23);
        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_back"]];
        backImg.frame = CGRectMake(-10, 0, 22, 22);
        [backBtn addSubview:backImg];
        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 85, 22)];
        backText.text = backString;
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:[UIColor redColor]];
        [backBtn addSubview:backText];
        [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
    });
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

#pragma mark - RealTimeLocationStatusViewDelegate
- (void)onJoin {
    [self showRealTimeLocationViewController];
}

#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    if (!self.displayUserNameInCell) {
        if (model.messageDirection == MessageDirection_RECEIVE) {
            model.isDisplayNickname = NO;
        }
    }
//    RCMessageContent *messageContent = model.content;
//    RCMessageBaseCell *cell = nil;

    return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
}

#pragma mark override
- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    if (self.conversationType == ConversationType_GROUP || self.conversationType == ConversationType_DISCUSSION) {
   
    }
    
}


#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCRealTimeLocationStartMessage class]]) {
        if (model.isDisplayMessageTime) {
            return CGSizeMake(collectionView.frame.size.width, 66);
        }
        return CGSizeMake(collectionView.frame.size.width, 66);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

/**
 *  重写方法实现未注册的消息的显示
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    NSLog(@"message objectName = %@", model.objectName);
    RCMessageCell *cell = [collectionView
                           dequeueReusableCellWithReuseIdentifier:RCUnknownMessageTypeIdentifier
                           forIndexPath:indexPath];
    [cell setDataModel:model];
    return cell;
}

/**
 *  重写方法实现未注册的消息的显示的高度
 *  如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
 *  需要设置RCIM showUnkownMessage属性
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize) rcUnkownConversationCollectionView:(UICollectionView *)collectionView
                                       layout:(UICollectionViewLayout *)collectionViewLayout
                       sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    NSLog(@"message objectName = %@", model.objectName);
    return CGSizeMake(collectionView.frame.size.width, 66);
}

#pragma mark override
- (void)resendMessage:(RCMessageContent *)messageContent{
    if ([messageContent isKindOfClass:[RCRealTimeLocationStartMessage class]]) {
        [self showRealTimeLocationViewController];
    } else {
        [super resendMessage:messageContent];
    }
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [super pluginBoardView:self.pluginBoardView clickedItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
        }
            break;
        case 1:
        {
            [self showRealTimeLocationViewController];
        }
            break;
    }
}

#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf updateRealTimeLocationStatus];
    });
}

- (void)onParticipantsJoin:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你加入了地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@加入地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>加入地理位置共享", userId]];
            }
        }];
    }
}

- (void)onParticipantsQuit:(NSString *)userId {
    __weak typeof(&*self) weakSelf = self;
    if ([userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [self notifyParticipantChange:@"你退出地理位置共享"];
    } else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
            if (userInfo.name.length) {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"%@退出地理位置共享", userInfo.name]];
            } else {
                [weakSelf notifyParticipantChange:[NSString stringWithFormat:@"user<%@>退出地理位置共享", userId]];
            }
        }];
    }
}

- (void)onRealTimeLocationStartFailed:(long)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < self.conversationDataRepository.count; i++) {
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:i];
            if (model.messageId == messageId) {
                model.sentStatus = SentStatus_FAILED;
            }
        }
        NSArray *visibleItem = [self.conversationMessageCollectionView indexPathsForVisibleItems];
        for (int i = 0; i < visibleItem.count; i++) {
            NSIndexPath *indexPath = visibleItem[i];
            RCMessageModel *model =
            [self.conversationDataRepository objectAtIndex:indexPath.row];
            if (model.messageId == messageId) {
                [self.conversationMessageCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
    });
}

- (void)notifyParticipantChange:(NSString *)text {
    __weak typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf performSelector:@selector(updateRealTimeLocationStatus) withObject:nil afterDelay:0.5];
    });
}


- (void)onFailUpdateLocation:(NSString *)description {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self popupChatViewController];
    }
}

- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message
{
    return message;
}

/*******************实时地理位置共享***************/
- (void)showRealTimeLocationViewController{
   /** RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc animated:YES completion:^{
        
    }];**/
}
- (void)updateRealTimeLocationStatus {
    /**
    if (self.realTimeLocation) {
        [self.realTimeLocationStatusView updateRealTimeLocationStatus];
        __weak typeof(&*self) weakSelf = self;
        NSArray *participants = nil;
        switch ([self.realTimeLocation getStatus]) {
            case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
                [self.realTimeLocationStatusView updateText:@"你正在共享位置"];
                break;
            case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
                participants = [self.realTimeLocation getParticipants];
                if (participants.count == 1) {
                    NSString *userId = participants[0];
                    [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"user<%@>正在共享位置", userId]];
                    [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                        if (userInfo.name.length) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%@正在共享位置", userInfo.name]];
                            });
                        }
                    }];
                } else {
                    if(participants.count<1)
                        [self.realTimeLocationStatusView removeFromSuperview];
                    else
                        [self.realTimeLocationStatusView updateText:[NSString stringWithFormat:@"%d人正在共享地理位置", (int)participants.count]];
                }
                break;
            default:
                break;
        }
    }**/
}

@end
