//
//  SendProjectFourVC.m
//  qch
//
//  Created by W.兵 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SendProjectFourVC.h"
#import "TeacherCell.h"
#import "AddGroupPresonCell.h"
#import "SelectPresonVC.h"
#import "ProjectViewController.h"
#import "QCHMainController.h"
#import "QCHNavigationController.h"
// 引入FMDB头文件进行项目数据持久化
#import "FMDBHelper.h"
#import "ProjectFunModel.h"

@interface SendProjectFourVC ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>{
    NSString *waitStr;
    NSString *Teamguid;
    NSString *buttonStr;
}

@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *partnerlist;

@end

@implementation SendProjectFourVC

- (NSMutableArray *)funlist {
    if (_funlist == nil) {
        self.funlist = [NSMutableArray array];
    }
    return _funlist;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 查询数据库中数据并展示
    [self selectFromDataBase];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_buttonStr"]) {
        buttonStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"pro_buttonStr"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_waitStr"]) {
        waitStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"pro_waitStr"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"创建项目"];
    
    if (_partnerlist!=nil) {
        _partnerlist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(saveProject:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
    
    [self createTableView];
    [self getHeHuoRenList];
}

#pragma 合伙人需求
-(void)getHeHuoRenList{//85
    
    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:85 complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _partnerlist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _partnerlist=[[NSMutableArray alloc]init];
        }
        [self createColludeView];
    }];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
}

-(void)createColludeView{
    
    CGFloat width=(SCREEN_WIDTH-80*SCREEN_WSCALE)/3;
    
    NSInteger count=[_partnerlist count];
    
    CGFloat height=50+10*SCREEN_WSCALE+(count/3 +1)*40*SCREEN_WSCALE;
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    self.tableView.tableFooterView=footView;
    
    
    UILabel *colludeLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, 20*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"合伙人需求(多选)"];
    [footView addSubview:colludeLabel];
    

    for (int i=0; i<count; i++) {
        
        NSDictionary *dict=[_partnerlist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), colludeLabel.bottom+10*SCREEN_WSCALE+(i/3)*40*SCREEN_WSCALE, width, 30*SCREEN_WSCALE);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
    }
    // 配置button是否选中状态
    NSArray *arrayBut = [buttonStr componentsSeparatedByString:@";"];
    for (int i = 0; i < footView.subviews.count; i++) {
        if ([[footView.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)[footView.subviews objectAtIndex:i];
            for (NSString *str in arrayBut) {
                if ([str isEqualToString:button.currentTitle]) {
                    [button setSelected:YES];
                    button.backgroundColor=[UIColor btnBgkGaryColor];
                    button.layer.borderWidth=0;
                }
            }
        }
    }
}

-(void)selectType:(UIButton*)sender{
    UIButton *button=(UIButton*)sender;
    NSString *currentTitle = button.currentTitle;
    NSDictionary *dict=[_partnerlist objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderWidth=1;
        
        NSArray *array=[waitStr componentsSeparatedByString:@";"];
        NSString *wstr=nil;
        for (NSString *string in array) {
            if (![string isEqualToString:str]) {
                if ([self isBlankString:wstr]) {
                    wstr=string;
                } else {
                    wstr=[wstr stringByAppendingFormat:@";%@",string];
                }
            }
        }
        waitStr=wstr;
        
        NSArray *arrayBut = [buttonStr componentsSeparatedByString:@";"];
        NSString *strBut=nil;
        for (NSString *string in arrayBut) {
            if (![string isEqualToString:currentTitle]) {
                if ([self isBlankString:strBut]) {
                   strBut = string;
                } else {
                    strBut =[strBut stringByAppendingFormat:@";%@",string];
                }
            }
        }
        buttonStr = strBut;

    }else{
        [button setSelected:YES];
        button.backgroundColor=[UIColor btnBgkGaryColor];
        button.layer.borderWidth=0;
        if ([self isBlankString:waitStr]) {
            waitStr=str;
        } else {
            waitStr=[waitStr stringByAppendingFormat:@";%@",str];
        }
        
        if ([self isBlankString:buttonStr]) {
            buttonStr=currentTitle;
        } else {
            buttonStr=[buttonStr stringByAppendingFormat:@";%@",currentTitle];
        }
    }
}


-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    tableView.tableFooterView=view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count]+3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 30*SCREEN_WSCALE;
    } else {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*PMBWIDTH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10*PMBWIDTH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text=@"核心团队";
        cell.textLabel.font=Font(15);
        cell.textLabel.textColor=[UIColor blackColor];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.row==[_funlist count]+2){
        
        AddGroupPresonCell *cell = (AddGroupPresonCell*)[tableView dequeueReusableCellWithIdentifier:@"AddGroupPresonCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AddGroupPresonCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[AddGroupPresonCell class]]) {
                    cell = (AddGroupPresonCell *)oneObject;
                }
            }
        }
        cell.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
    
    }else if (indexPath.row==1){
        
        TeacherCell *cell = (TeacherCell*)[tableView dequeueReusableCellWithIdentifier:@"TeacherCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeacherCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[TeacherCell class]]) {
                    cell = (TeacherCell *)oneObject;
                }
            }
        }
        NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
        [cell.IconImg sd_setImageWithURL:[NSURL URLWithString:path]];
        cell.Name.text = UserDefaultEntity.realName;
        cell.Remark.text = UserDefaultEntity.remark;
        cell.position.hidden=NO;
        cell.position.text = UserDefaultEntity.positionName;
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
        
    }else{
        
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row-2];
        
        TeacherCell *cell = (TeacherCell*)[tableView dequeueReusableCellWithIdentifier:@"TeacherCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeacherCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[TeacherCell class]]) {
                    cell = (TeacherCell *)oneObject;
                }
            }
        }
        [cell.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]]] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        cell.Name.text = [dict objectForKey:@"t_User_RealName"];
        cell.Remark.text = [[dict objectForKey:@"t_User_Remark"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        cell.position.hidden=NO;
        cell.position.text=[dict objectForKey:@"t_Position"];
        
        cell.tag=indexPath.row;
        cell.delegate=self;
        [cell setRightUtilityButtons: [self rightButtons]];
        
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        return cell;
        
    }
    return [[UITableViewCell alloc]init];
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
    
    [_funlist removeObjectAtIndex:indexPath.row-2];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==[_funlist count]+2) {
        SelectPresonVC *selectPreson=[[SelectPresonVC alloc]init];
        selectPreson.selectArray=_funlist;
        [self.navigationController pushViewController:selectPreson animated:YES];
        [selectPreson returnArray:^(NSMutableArray *Array) {
            //_funlist=[[NSMutableArray alloc]initWithArray:Array];
            // 重新封装数据源中的数据
            NSMutableSet *temSet = [NSMutableSet set];
            for (int i = 0; i < Array.count; i++) {
                NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
                // 便利数据源删除里面是自己的那条数据
                if (![[Array[i] objectForKey:@"t_User_RealName"]isEqualToString:UserDefaultEntity.realName]) {
                    [temDic setObject:[Array[i] objectForKey:@"t_User_RealName"] forKey:@"t_User_RealName"];
                    [temDic setObject:[Array[i] objectForKey:@"t_User_Pic"] forKey:@"t_User_Pic"];
                    [temDic setObject:[Array[i] objectForKey:@"t_User_Remark"] forKey:@"t_User_Remark"];
                    [temDic setObject:[Array[i] objectForKey:@"Guid"] forKey:@"Guid"];
                    [temSet addObject:temDic];
                }
            }
            // 清除数据源中重复数据
            [self.funlist removeAllObjects];
            [temSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.funlist addObject:obj];
            }];
            // 持久化到数据库
            [self insertIntoDataBase];
            [self.tableView reloadData];
        }];
    }
}

-(void)saveProject:(id)sender{
    NSString *guidstr;
    if ([_funlist count]==0) {
        Teamguid = UserDefaultEntity.uuid;
    }else{
    for (int i=0; i<[_funlist count]; i++) {
        NSDictionary *dict = [_funlist objectAtIndex:i];
        NSString *team = [dict objectForKey:@"Guid"];
        if ([self isBlankString:Teamguid]) {
            guidstr = team;
            Teamguid = [NSString stringWithFormat:@"%@,%@",UserDefaultEntity.uuid,guidstr];
        }else{
            guidstr = [guidstr stringByAppendingString:[NSString stringWithFormat:@",%@",team]];
            Teamguid = [NSString stringWithFormat:@"%@,%@",UserDefaultEntity.uuid,guidstr];
        }
    }
    }
    
    if ([self isBlankString:waitStr]) {
      [SVProgressHUD showErrorWithStatus:@"请选择合伙人需求" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [_Addprojectdic setObject:Teamguid forKey:@"Teamguid"];
    [_Addprojectdic setObject:waitStr forKey:@"parterWant"];
    [_Addprojectdic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [_Addprojectdic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [SVProgressHUD showWithStatus:@"提交中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpProjectAction AddProject2:_Addprojectdic complete:^(id result, NSError *error) {
        NSDictionary *dict = result;
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            for (QchBaseViewController *baseVC in self.navigationController.viewControllers) {
                if ([baseVC isKindOfClass:[ProjectViewController class]]) {
                    [self.navigationController popToViewController:baseVC animated:YES];
                }
            }
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
    
    // 清除数据库
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]) {
        [[FMDBHelper shareFMDBHelper] eraseTable:@"Project"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_id"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]) {
        [[FMDBHelper shareFMDBHelper] eraseTable:@"ProjectImage"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"proImage_id"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proFun_id"]) {
        [[FMDBHelper shareFMDBHelper] eraseTable:@"ProjectFun"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"proFun_id"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_buttonStr"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_buttonStr"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_waitStr"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_waitStr"];
    }

}
#pragma mark - dataBase
// 插入到数据库
- (void)insertIntoDataBase {
    // 先清除表内容
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proFun_id"]) {
        [[FMDBHelper shareFMDBHelper] eraseTable:@"ProjectFun"];
    }
    for (int i = 0; i < _funlist.count; i++) {
        NSDictionary *temDic = _funlist[i];
        ProjectFunModel *model = [[ProjectFunModel alloc] init];
        model.pro_name = [temDic objectForKey:@"t_User_RealName"];
        model.pro_remark = [temDic objectForKey:@"t_User_Remark"];
        model.pro_icon = [temDic objectForKey:@"t_User_Pic"];
        model.pro_guid = [temDic objectForKey:@"Guid"];
        model.pro_id = i;
        // 不存在创建数据库
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"proFun_id"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"proFun_id"];
            [[FMDBHelper shareFMDBHelper] insertProjectFunWithProject:model];
        } else {
            [[FMDBHelper shareFMDBHelper] insertProjectFunWithProject:model];
        }
    }
}
// 从数据库中查询
- (void)selectFromDataBase {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proFun_id"]) {
        NSArray *resultArr = [[FMDBHelper shareFMDBHelper] searchProjectFun];
        [self.funlist removeAllObjects];
        for (ProjectFunModel *model in resultArr) {
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setObject:model.pro_name forKey:@"t_User_RealName"];
            [temDic setObject:model.pro_icon forKey:@"t_User_Pic"];
            [temDic setObject:model.pro_remark forKey:@"t_User_Remark"];
            [temDic setObject:model.pro_guid forKey:@"Guid"];
            [self.funlist addObject:temDic];
        }
        [self.tableView reloadData];
    }
}
#pragma mark - backAction
- (void)backAction {
    // 持久化到数据库
    [self insertIntoDataBase];
    if (buttonStr) {
        [[NSUserDefaults standardUserDefaults] setObject:buttonStr forKey:@"pro_buttonStr"];
    }
    if (waitStr) {
        [[NSUserDefaults standardUserDefaults] setObject:waitStr forKey:@"pro_waitStr"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
