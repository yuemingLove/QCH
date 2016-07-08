//
//  PartnerVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartnerVC.h"
#import "ProjectCell.h"
#import "QchpartnerVC.h"
@interface PartnerVC ()<UITableViewDataSource,UITableViewDelegate,ProjectCellDelegate>{
    NSMutableArray *DataArray;
    NSInteger ifPraise;

}

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation PartnerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!DataArray) {
        DataArray = [[NSMutableArray alloc]init];
    }
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refeleshController];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)headerFreshing{
    
    
    [HttpCenterAction GetPraiseUser:UserDefaultEntity.uuid type:3 Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=[result objectAtIndex:0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:dict];
            DataArray=(NSMutableArray*)rpnc.result;
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            DataArray=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            
        }else{
            DataArray=[[NSMutableArray alloc]init];
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
        if ([DataArray count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PartnerResult *model = [DataArray objectAtIndex:indexPath.row];
    ProjectCell *cell = (ProjectCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[ProjectCell class]]) {
                cell = (ProjectCell *)oneObject;
                cell.projectDelegate=self;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    cell.themeLabel.text = model.tUserRealName;
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.positionName,model.tUserCommpany];
    cell.contentLabel.text = [model.tUserRemark stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    cell.numLabel.text = model.fCount;
    
    NSArray *array1 = model.foucsArea;
    if ([array1 count]>0) {
        FoucsArea *fouce = array1[0];
        cell.statusLabel.text=fouce.foucsName;
    } else {
        cell.statusLabel.text=@"";
    }
    NSString *Beststring = @"";
    NSArray *array = model.best;
    for (int i = 0; i<[array count]; i++) {
        Best *best = array[i];
        NSString *beststring = best.bestName;
        if ([Beststring isEqualToString:@""]) {
            Beststring = beststring;
        } else {
            Beststring = [Beststring stringByAppendingString:[NSString stringWithFormat:@" / %@",beststring]];
        }
        
    }
    cell.label.text=@"Ta擅长:";
    cell.projectLabel.text=Beststring;
    ifPraise = [model.ifFoucs integerValue];
    if (ifPraise == 0) {
        [cell.careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];
    }else if (ifPraise==1){
        [cell.careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PartnerResult *model = [DataArray objectAtIndex:indexPath.row];
    QchpartnerVC *partner = [[QchpartnerVC alloc]init];
    partner.hidesBottomBarWhenPushed = YES;
    partner.Guid = model.guid;
    [self.navigationController pushViewController:partner animated:YES];

}

-(void)updateCareBtn:(ProjectCell *)cell{
    
    PartnerResult *model = [DataArray objectAtIndex:cell.tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:model.guid forKey:@"foucsUserGuid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpPartnerAction AddCareOrCancelPraise:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if (ifPraise==0) {
                ifPraise=1;
                [cell.careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];
               
                [self headerFreshing];
            }else{
                ifPraise=0;
                [cell.careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];
                
                [self headerFreshing];
            }
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
@end
