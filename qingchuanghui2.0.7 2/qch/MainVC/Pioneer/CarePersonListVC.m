//
//  CarePersonListViewController.m
//  qch
//
//  Created by 青创汇 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CarePersonListVC.h"
#import "ParntDetailVC.h"
#import "QchpartnerVC.h"
#import "MakersVC.h"

@interface CarePersonListVC ()<UITableViewDataSource,UITableViewDelegate,CarePersonCellDeleagte>{
    NSInteger ifPraise;
}

@property (nonatomic,strong)UITableView *carelisttableview;

@end

@implementation CarePersonListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creattableview];
    // Do any additional setup after loading the view.
    
    if (_if_push) {
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItem:)];
        self.navigationItem.leftBarButtonItem=leftItem;
    }
}

-(void)backItem:(id)sender{
    [ self.navigationController popToRootViewControllerAnimated: YES ];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (_type==10) {
        
        if (_model !=nil) {
            _model=[[NSMutableArray alloc]init];
        }
        
        [HttpCenterAction GetUserFuns:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict = result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                _model = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                _model = [[NSMutableArray alloc]init];
            }else{
                _model = [[NSMutableArray alloc]init];
            }
            [self.carelisttableview reloadData];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)creattableview{
    
    self.carelisttableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.carelisttableview.delegate = self;
    self.carelisttableview.dataSource = self;
    [self.view addSubview:self.carelisttableview];
    [self setExtraCellLineHidden:self.carelisttableview];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_model objectAtIndex:indexPath.row];
    
    CarePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carepersoncell"];
    if (cell == nil) {
        cell = [[CarePersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carepersoncell"];
    }
    
    
    ifPraise = [[dict objectForKey:@"ifFoucs"]integerValue];
    if (ifPraise==0) {
        [cell.CareBtn setImage:[UIImage imageNamed:@"dongtai_gz_btn"] forState:UIControlStateNormal];
    }else{
        [cell.CareBtn setImage:[UIImage imageNamed:@"quxiao_btn"] forState:UIControlStateNormal];
    }
    
    if (_type==1) {
        if ([self isBlankString:[dict objectForKey:@"ApplyUserRealName"]]) {
            cell.NameLab.text = @"游客";
        }else{
            cell.NameLab.text = [dict objectForKey:@"ApplyUserRealName"];
        }
        NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"ApplyUserPic"]];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        if ([[dict objectForKey:@"ApplyUserStyle"]isEqualToString:@"0"]) {
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"ApplyUserStyle"]isEqualToString:@"1"]){
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"ApplyUserStyle"]isEqualToString:@"2"]){
            if ([[dict objectForKey:@"ApplyUserAudit"]isEqualToString:@"0"]) {
                cell.IdentityLab.text =@"投资人审核中";
            }else if ([[dict objectForKey:@"ApplyUserAudit"]isEqualToString:@"2"]){
                cell.IdentityLab.text= @"投资人审核失败";
            }else if ([[dict objectForKey:@"ApplyUserAudit"]isEqualToString:@"1"]){
                cell.IdentityLab.text = @"投资人";
            }

        }else if ([[dict objectForKey:@"ApplyUserStyle"]isEqualToString:@"3"]){
            cell.IdentityLab.text = @"合伙人";
        }
    }else if (_type==3 || _type==4 || _type==10){
        
        cell.NameLab.text = [dict objectForKey:@"t_User_RealName"];
        NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        if ([[dict objectForKey:@"t_User_Style"]isEqualToString:@"0"]) {
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"t_User_Style"]isEqualToString:@"1"]){
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"t_User_Style"]isEqualToString:@"2"]){
            if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"0"]) {
                cell.IdentityLab.text =@"投资人审核中";
            }else if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"2"]){
                cell.IdentityLab.text= @"投资人审核失败";
            }else if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"1"]){
                cell.IdentityLab.text = @"投资人";
            }
        }else if ([[dict objectForKey:@"t_User_Style"]isEqualToString:@"3"]){
            cell.IdentityLab.text = @"合伙人";
        }

        
    } else {
        cell.NameLab.text = [dict objectForKey:@"PraiseUserRealName"];
        NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"PraiseUserPic"]];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        if ([[dict objectForKey:@"PraiseUserStyle"]isEqualToString:@"0"]) {
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"PraiseUserStyle"]isEqualToString:@"1"]){
            cell.IdentityLab.text = @"创客";
        }else if ([[dict objectForKey:@"PraiseUserStyle"]isEqualToString:@"2"]){
            if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"0"]) {
                cell.IdentityLab.text =@"投资人审核中";
            }else if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"2"]){
                cell.IdentityLab.text= @"投资人审核失败";
            }else if ([[dict objectForKey:@"t_UserStyleAudit"]isEqualToString:@"1"]){
                cell.IdentityLab.text = @"投资人";
            }
        }else if ([[dict objectForKey:@"PraiseUserStyle"]isEqualToString:@"3"]){
            cell.IdentityLab.text = @"合伙人";
        }
    }
    cell.tag=indexPath.row;
    cell.CareDelegate=self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*PMBHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_model count];
}

- (void)careClicked:(CarePersonCell *)cell index:(NSInteger)index{
    
    NSDictionary *dict = [_model objectAtIndex:cell.tag];
    [HttpPartnerAction AddOrCancelFoucs:UserDefaultEntity.uuid foucsUserGuid:[dict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            if (ifPraise==0) {
                ifPraise=1;
                [cell.CareBtn setImage:[UIImage imageNamed:@"quxiao_btn"] forState:UIControlStateNormal];
                [Utils showToastWithText:@"关注成功"];
                [_carelisttableview reloadInputViews];
            }else{
                ifPraise=0;
                [cell.CareBtn setImage:[UIImage imageNamed:@"dongtai_gz_btn"] forState:UIControlStateNormal];
                [Utils showToastWithText:@"取消关注"];
                
                [_carelisttableview reloadInputViews];
            }
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [Utils showToastWithText:[dict objectForKey:@"result"]];
        }
    }];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_model objectAtIndex:indexPath.row];
    
    NSInteger user_style;
    NSString *Guid;
    NSString *ApplyUserAudit;
    if (_type==2) {
        user_style=[(NSNumber*)[dict objectForKey:@"PraiseUserStyle"]integerValue];
        Guid=[dict objectForKey:@"PraiseUserGuid"];
        ApplyUserAudit = [dict objectForKey:@"t_UserStyleAudit"];
    }else if (_type==1){
        user_style=[(NSNumber*)[dict objectForKey:@"ApplyUserStyle"]integerValue];
        Guid=[dict objectForKey:@"ApplyUserGuid"];
        ApplyUserAudit = [dict objectForKey:@"ApplyUserAudit"];
    }else if (_type==3 || _type==4 || _type==10){
        user_style=[(NSNumber*)[dict objectForKey:@"t_User_Style"]integerValue];
        Guid=[dict objectForKey:@"Guid"];
        ApplyUserAudit = [dict objectForKey:@"t_UserStyleAudit"];
    }
    
    if (user_style==2) {
        if ([Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
        }else{
            if ([ApplyUserAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            } else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if (user_style==3){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }
}


@end
