//
//  DynamicstateVC.m
//  qch
//
//  Created by 青创汇 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DynamicstateVC.h"
#import "DynamicTWCell2.h"
#import "CarePersonListVC.h"
#import "RootDynamicTalkClass.h"
#import "DynamicTalkModel.h"
#import "TalkViewCell.h"
#import "ThemeCell.h"
#import "SupportCell.h"
#import "MakersVC.h"
#import "QchpartnerVC.h"
#import "ParntDetailVC.h"
#import "DynamicTWCell4.h"
#import "DynamicTWCell6.h"
#import "DynamicTWCell8.h"

@interface DynamicstateVC ()<UITableViewDataSource,UITableViewDelegate,DynamicTWCell2Deleagte,XHImageViewerDelegate,UITextFieldDelegate,UIActionSheetDelegate,TalkViewCellDelegate,SupportCellDelegate,CommitAlertViewDelegate,DynamicTWCell4Deleagte,DynamicTWCell6Deleagte,DynamicTWCell8Deleagte>{
    
    NSMutableArray *SourceArray;

    NSString *touserguid;
    UIButton *sendButton;
    NSMutableArray *DataArray;
    UIView *talkView;
    DynamicModel *Dyanmicresult;
    
}

@property (nonatomic,strong)UITableView *Dynamictableview;

@property (nonatomic,strong) NSDictionary *dict;


@end

@implementation DynamicstateVC


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //禁用
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancle:) name:@"quxiao" object:nil];
    self.title = @"动态详情";
    touserguid = @"";
    [self getdata];
    [self gettalk];
    [self creattableview];
    if (!SourceArray) {
        SourceArray = [[NSMutableArray alloc]init];
    }
    if (!DataArray) {
        DataArray = [[NSMutableArray alloc]init];
    }
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"举报" style:UIBarButtonItemStyleBordered target:self action:@selector(Report)];
    [self.navigationItem setRightBarButtonItem:rightitem];
    if (_type==1) {
        CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
        commit.delegate = self;
        commit.placeholder.hidden=YES;
        [self.view addSubview:commit];
    }
    
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
    
}
- (void)backAction {
    if (_sureFlag) {
        if (_flag) {
            if (self.refleshBlock) {
                self.refleshBlock();
            }
        } else {
            if (self.reflesh1Block) {
                self.reflesh1Block();
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creattableview{
    
    self.Dynamictableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.Dynamictableview.delegate = self;
    self.Dynamictableview.dataSource = self;
    [self.Dynamictableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.Dynamictableview];
    
}


//获取评论
- (void)gettalk{
    
    NSMutableDictionary *talkdic = [[NSMutableDictionary alloc]init];
    [talkdic setObject:_guid forKey:@"associateGuid"];
    [talkdic setObject:@"1" forKey:@"page"];
    [talkdic setObject:@"50" forKey:@"pagesize"];
    [talkdic setObject:[MyAes aesSecretWith:@"associateGuid"] forKey:@"Token"];
    [HttpDynamicAction dynamictalk:talkdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            RootDynamicTalkClass *rdtc = [[RootDynamicTalkClass alloc]initWithDictionary:result];
            SourceArray = [rdtc.result mutableCopy];
        }else{
            SourceArray = [[NSMutableArray alloc]init];
        }
        [self.Dynamictableview reloadData];
    }];
}

//举报

- (void)Report{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"请慎重举报" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        [dic setObject:_guid forKey:@"topicGuid"];
        [dic setObject:@"" forKey:@"remark"];
        [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpDynamicAction dynamicreport:dic complete:^(id result, NSError *error) {
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
               
                [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}

- (void)getdata{

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:_guid forKey:@"guid"];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
    [HttpDynamicAction dynamicstate:dic complete:^(id result, NSError *error) {
        
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            self.dict = [result objectForKey:@"result"][0];
            
            Dyanmicresult=[[DynamicModel alloc]init];
            Dyanmicresult.Guid=[self.dict objectForKey:@"Guid"];
            Dyanmicresult.Pic=[self.dict objectForKey:@"Pic"];
            Dyanmicresult.PraiseCount=[self.dict objectForKey:@"PraiseCount"];
            Dyanmicresult.PraiseUsers=[self.dict objectForKey:@"PraiseUsers"];
            Dyanmicresult.t_Topic_Latitude=[self.dict objectForKey:@"t_Topic_Latitude"];
            Dyanmicresult.t_Topic_Top=[self.dict objectForKey:@"t_Topic_Top"];
            Dyanmicresult.t_Date=[self.dict objectForKey:@"t_Date"];
            Dyanmicresult.t_User_RealName=[self.dict objectForKey:@"t_User_RealName"];
            Dyanmicresult.t_Topic_Longitude=[self.dict objectForKey:@"t_Topic_Longitude"];
            Dyanmicresult.t_Topic_Address=[self.dict objectForKey:@"t_Topic_Address"];
            Dyanmicresult.t_User_LoginId=[self.dict objectForKey:@"t_User_LoginId"];
            NSString *text=[[self.dict objectForKey:@"t_Topic_Contents"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            Dyanmicresult.t_Topic_Contents=text;
            Dyanmicresult.t_User_Pic=[self.dict objectForKey:@"t_User_Pic"];
            Dyanmicresult.t_User_Guid=[self.dict objectForKey:@"t_User_Guid"];
            Dyanmicresult.t_Topic_City=[self.dict objectForKey:@"t_Topic_City"];
            Dyanmicresult.ifPraise=[self.dict objectForKey:@"ifPraise"];
            Dyanmicresult.t_User_Position = [self.dict objectForKey:@"t_User_Position"];
            Dyanmicresult.t_User_Commpany = [self.dict objectForKey:@"t_User_Commpany"];
            Dyanmicresult.PositionName = [self.dict objectForKey:@"PositionName"];
            Dyanmicresult.t_User_Style = [self.dict objectForKey:@"t_User_Style"];
            Dyanmicresult.t_UserStyleAudit = [self.dict objectForKey:@"t_UserStyleAudit"];
            Dyanmicresult.Best = [self.dict objectForKey:@"Best"];
            Dyanmicresult.NowNeed = [self.dict objectForKey:@"NowNeed"];
            Dyanmicresult.Intention = [self.dict objectForKey:@"Intention"];
            Dyanmicresult.talkcount = [self.dict objectForKey:@"talkcount"];
            [self.Dynamictableview reloadData];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.Dynamictableview.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.Dynamictableview.tableHeaderView = emptyView;
            self.Dynamictableview.userInteractionEnabled = NO;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3){
        return SourceArray.count;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([Dyanmicresult.t_User_Style isEqualToString:@"2"]) {
            if ([Dyanmicresult.Best count]==0 &&[Dyanmicresult.Intention count]==0) {
                DynamicTWCell8 *cell = (DynamicTWCell8*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell8"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell8" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell8 class]]) {
                            cell = (DynamicTWCell8 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                cell.tag = indexPath.section;
                [cell updateData:Dyanmicresult];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if ([Dyanmicresult.Best count]==0 || [Dyanmicresult.Intention count]==0){
                DynamicTWCell6 *cell = (DynamicTWCell6*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell6"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell6" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell6 class]]) {
                            cell = (DynamicTWCell6 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                cell.tag = indexPath.section;
                [cell updateData:Dyanmicresult];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                DynamicTWCell2 *cell = (DynamicTWCell2*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell2"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell2" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell2 class]]) {
                            cell = (DynamicTWCell2 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                [cell updateData:Dyanmicresult];
                cell.tag = indexPath.row;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if ([Dyanmicresult.t_User_Style isEqualToString:@"3"]){
            if ([Dyanmicresult.Best count]==0 &&[Dyanmicresult.Intention count]==0) {
                DynamicTWCell8 *cell = (DynamicTWCell8*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell8"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell8" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell8 class]]) {
                            cell = (DynamicTWCell8 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                cell.tag = indexPath.section;
                [cell updateData:Dyanmicresult];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if ([Dyanmicresult.Best count]==0 || [Dyanmicresult.Intention count]==0){
                DynamicTWCell6 *cell = (DynamicTWCell6*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell6"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell6" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell6 class]]) {
                            cell = (DynamicTWCell6 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                cell.tag = indexPath.section;
                [cell updateData:Dyanmicresult];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                DynamicTWCell2 *cell = (DynamicTWCell2*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell2"];
                if (cell == nil) {
                    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell2" owner:self options:nil];
                    for (id oneObject in nibs) {
                        if ([oneObject isKindOfClass:[DynamicTWCell2 class]]) {
                            cell = (DynamicTWCell2 *)oneObject;
                            cell.dyDelegate = self;
                        }
                    }
                }
                [cell updateData:Dyanmicresult];
                cell.tag = indexPath.row;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else{
            DynamicTWCell4 *cell = (DynamicTWCell4*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell4"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell4" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell4 class]]) {
                        cell = (DynamicTWCell4 *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            [cell updateData:Dyanmicresult];
            cell.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        }else if (indexPath.section == 1){
        
        SupportCell *cell = (SupportCell*)[tableView dequeueReusableCellWithIdentifier:@"SupportCell"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"SupportCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[SupportCell class]]) {
                    cell = (SupportCell *)oneObject;
                }
            }
        }
        cell.supportDelegate=self;
        NSArray *PraiseUsersArray= [self.dict objectForKey:@"PraiseUsers"];
        cell.tag = indexPath.row;
        cell.headlist=[PraiseUsersArray mutableCopy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
            
    }else if (indexPath.section == 3){
        DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row];
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
        
        cell.deleteBtn.tag = indexPath.row;
        
        [cell updateData:model];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.talkdelegate = self;
        return cell;
        
    }else if (indexPath.section == 2){
        ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
        cell = [[ThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"themeCell"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2){
        return 25*SCREEN_WSCALE;
    }
    
    UITableViewCell *cell=[self tableView:self.Dynamictableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        DynamicTalkModel *model = [SourceArray objectAtIndex:indexPath.row];
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
}

//评论
-(void)updateTextViewData:(NSString *)text{

    if ([self isBlankString:text]) {
        
        [SVProgressHUD showErrorWithStatus:@"评论内容不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    _sureFlag = YES;
    NSMutableDictionary *commit = [[NSMutableDictionary alloc]init];
    [commit setObject:UserDefaultEntity.uuid forKey:@"fromUserGuid"];
    [commit setObject:text forKey:@"fromContent"];
    [commit setObject:_guid forKey:@"associateGuid"];
    [commit setObject:[MyAes aesSecretWith:@"fromUserGuid"] forKey:@"Token"];
    [commit setObject:@"topic" forKey:@"type"];
    if ([self isBlankString:touserguid]) {
        [commit setObject:@"" forKey:@"toUserGuid"];
    }else{
        [commit setObject:touserguid forKey:@"toUserGuid"];
    }
    [HttpDynamicAction commonAddTalk:commit complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]){
            touserguid=@"";
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [SourceArray removeAllObjects];
            [self gettalk];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)cancle:(NSNotification *)text{
    
    touserguid=@"";
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quxiao" object:nil];
}

//点赞
- (void)careClicked:(DynamicTWCell2 *)cell index:(NSInteger)index{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:_guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if ([Dyanmicresult.ifPraise isEqualToString:@"0"]) {
                Dyanmicresult.ifPraise = @"1";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
                [self getdata];
            }else{
                Dyanmicresult.ifPraise = @"0";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
                [self getdata];
            }
            CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
            keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
            keyAnimation.calculationMode=kCAAnimationLinear;
            [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
        }
    }];
}

- (void)careClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:_guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if ([Dyanmicresult.ifPraise isEqualToString:@"0"]) {
                Dyanmicresult.ifPraise = @"1";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
                [self getdata];
            }else{
                Dyanmicresult.ifPraise = @"0";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
                [self getdata];
            }
            CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
            keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
            keyAnimation.calculationMode=kCAAnimationLinear;
            [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
        }
    }];
}

- (void)careClicked6:(DynamicTWCell6 *)cell index:(NSInteger)index
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:_guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if ([Dyanmicresult.ifPraise isEqualToString:@"0"]) {
                Dyanmicresult.ifPraise = @"1";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
                [self getdata];
            }else{
                Dyanmicresult.ifPraise = @"0";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
                [self getdata];
            }
            CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
            keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
            keyAnimation.calculationMode=kCAAnimationLinear;
            [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
        }
    }];

}
- (void)careClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:_guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if ([Dyanmicresult.ifPraise isEqualToString:@"0"]) {
                Dyanmicresult.ifPraise = @"1";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
                [self getdata];
            }else{
                Dyanmicresult.ifPraise = @"0";
                [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
                [self getdata];
            }
            CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
            keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
            keyAnimation.calculationMode=kCAAnimationLinear;
            [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
        }
    }];

}

- (void)talkClicked:(DynamicTWCell2 *)cell index:(NSInteger)index{
    
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}

- (void)talkClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index
{
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}

- (void)talkClicked6:(DynamicTWCell6 *)cell index:(NSInteger)index
{
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}

- (void)talkClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index
{
    CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"动态评论" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"发送"];
    commit.delegate = self;
    commit.placeholder.hidden=YES;
    [self.view addSubview:commit];
}

//删除评论
- (void)deletetalkClick:(TalkViewCell *)cell index:(NSInteger)index{
    
    DynamicTalkModel *model = [SourceArray objectAtIndex:index];
    NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
    [deletedic setObject:model.guid forKey:@"talkGuid"];
    [deletedic setObject:[MyAes aesSecretWith:@"talkGuid"] forKey:@"Token"];
    [HttpDynamicAction talkdelete:deletedic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
          
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            
            [self gettalk];
        }
    }];
}



//浏览图片
- (void) tapImageWithObject:(DynamicTWCell2 *)cell tap:(UITapGestureRecognizer *)tap{
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject4:(DynamicTWCell4 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject6:(DynamicTWCell6 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject8:(DynamicTWCell8 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}


-(void)tapImg:(DynamicTWCell2 *)cell tap:(UITapGestureRecognizer *)tap{

    
    if ([Dyanmicresult.t_User_Style isEqualToString:@"2"]) {
        if ([Dyanmicresult.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = Dyanmicresult.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([Dyanmicresult.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = Dyanmicresult.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = Dyanmicresult.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
    }else if ([Dyanmicresult.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = Dyanmicresult.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = Dyanmicresult.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }
}

- (void)tapImg4:(DynamicTWCell4 *)cell tap:(UITapGestureRecognizer *)tap
{
    if ([Dyanmicresult.t_User_Style isEqualToString:@"2"]) {
        if ([Dyanmicresult.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = Dyanmicresult.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([Dyanmicresult.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = Dyanmicresult.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = Dyanmicresult.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
    }else if ([Dyanmicresult.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = Dyanmicresult.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = Dyanmicresult.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }

}

- (void)tapImg6:(DynamicTWCell6 *)cell tap:(UITapGestureRecognizer *)tap
{
    if ([Dyanmicresult.t_User_Style isEqualToString:@"2"]) {
        if ([Dyanmicresult.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = Dyanmicresult.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([Dyanmicresult.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = Dyanmicresult.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = Dyanmicresult.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
    }else if ([Dyanmicresult.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = Dyanmicresult.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = Dyanmicresult.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }

}

- (void)tapImg8:(DynamicTWCell8 *)cell tap:(UITapGestureRecognizer *)tap
{
    if ([Dyanmicresult.t_User_Style isEqualToString:@"2"]) {
        if ([Dyanmicresult.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = Dyanmicresult.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([Dyanmicresult.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = Dyanmicresult.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = Dyanmicresult.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
    }else if ([Dyanmicresult.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = Dyanmicresult.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = Dyanmicresult.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }

}

- (void)shareClicked6:(DynamicTWCell6 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Dyanmicresult.Pic count]>0) {
        
        NSDictionary *dict=Dyanmicresult.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
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
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
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
    }else{
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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

- (void)shareClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Dyanmicresult.Pic count]>0) {
        
        
        NSDictionary *dict=Dyanmicresult.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
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
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
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
    }else{
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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

- (void)shareClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Dyanmicresult.Pic count]>0) {
        
        
        NSDictionary *dict=Dyanmicresult.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
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
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
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
    }else{
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];
        
        NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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

- (void)shareClicked:(DynamicTWCell2 *)cell index:(NSInteger)index{
    
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([Dyanmicresult.Pic count]>0) {
        
    
    NSDictionary *dict=Dyanmicresult.Pic[0];
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {

 
        NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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
    }else{
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",Dyanmicresult.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,_guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
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
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
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

-(void)supportSelectMoreBtn:(SupportCell *)cell index:(NSInteger)index{
    NSInteger ind=(SCREEN_WIDTH-48)/48;
    NSInteger count;
    if ([[self.dict objectForKey:@"PraiseUsers"] count]>ind) {
        count=ind;
    }else{
        count=[[self.dict objectForKey:@"PraiseUsers"] count];
    }
    
    if (index==count) {
        
        CarePersonListVC *care = [[CarePersonListVC alloc]init];
        care.type=2;
        care.model = (NSMutableArray*)[self.dict objectForKey:@"PraiseUsers"];
        care.title = [NSString stringWithFormat:@"%@人觉得很赞",[self.dict objectForKey:@"PraiseCount"]];
        [self.navigationController pushViewController:care animated:YES];
    }else{
        NSDictionary *dict = [[self.dict objectForKey:@"PraiseUsers"] objectAtIndex:index];
        if ([[dict objectForKey:@"PraiseUserStyle"] isEqualToString:@"2"]) {
            if ([[dict objectForKey:@"PraiseUserGuid"]isEqualToString:UserDefaultEntity.uuid]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = [dict objectForKey:@"PraiseUserGuid"];
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else{
                if ([[dict objectForKey:@"t_UserStyleAudit"] isEqualToString:@"1"]) {
                    ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                    parnter.Guid = [dict objectForKey:@"PraiseUserGuid"];
                    parnter.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:parnter animated:YES];
                }else {
                    MakersVC *maker = [[MakersVC alloc]init];
                    maker.Guid = [dict objectForKey:@"PraiseUserGuid"];
                    maker.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:maker animated:YES];
                }
            }
        }else if ([[dict objectForKey:@"PraiseUserStyle"] isEqualToString:@"3"]){
            QchpartnerVC *partner = [[QchpartnerVC alloc]init];
            partner.Guid = [dict objectForKey:@"PraiseUserGuid"];
            partner.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:partner animated:YES];
        }else {
            MakersVC *maker = [[MakersVC alloc]init];
            maker.Guid = [dict objectForKey:@"PraiseUserGuid"];
            maker.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:maker animated:YES];
        }
    }
}

@end
