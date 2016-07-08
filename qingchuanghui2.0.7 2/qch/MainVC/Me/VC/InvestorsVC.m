//
//  InvestorsVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestorsVC.h"
#import "ProjectCell.h"
#import "ParntDetailVC.h"

@interface InvestorsVC ()<UITableViewDataSource,UITableViewDelegate,ProjectCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation InvestorsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    [self createTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refeleshController];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40*PMBWIDTH) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
    [self refeleshController];
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
    
    [HttpCenterAction GetPraiseUser:UserDefaultEntity.uuid type:2 Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=[result objectAtIndex:0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
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
    [self headerFreshing];
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
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    
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
    cell.tag = indexPath.row;
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    cell.themeLabel.text=[dict objectForKey:@"t_User_RealName"];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"PositionName"],[dict objectForKey:@"t_User_Commpany"]];
    cell.contentLabel.text=[[dict objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    cell.numLabel.text=[dict objectForKey:@"FCount"];
    
    NSArray *array2=(NSArray*)[dict objectForKey:@"InvestPhase"];
    if ([array2 count]>0) {
        NSDictionary *item=array2[0];
        cell.statusLabel.text=[item objectForKey:@"InvestPhaseName"];
    }else{
       cell.statusLabel.text=@"";
    }
    
    NSInteger ifPraise=[(NSNumber*)[dict objectForKey:@"ifFoucs"]integerValue];
    if (ifPraise==0) {
        [cell.careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];
    }else{
        [cell.careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *array=(NSMutableArray*)[dict objectForKey:@"InvestArea"];
    NSString *string=@"";
    for (NSDictionary *item2 in array) {
        //InvestAreaName
        if ([self isBlankString:string]) {
            string=[item2 objectForKey:@"InvestAreaName"];
        } else {
            string=[string stringByAppendingFormat:@" / %@",[item2 objectForKey:@"InvestAreaName"]];
        }
    }
    cell.projectLabel.text=string;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    ParntDetailVC *parntDetailVC=[[ParntDetailVC alloc]init];
    parntDetailVC.Guid=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:parntDetailVC animated:YES];
}


@end
