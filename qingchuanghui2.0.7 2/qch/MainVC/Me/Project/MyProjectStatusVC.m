//
//  MyProjectStatusVC.m
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyProjectStatusVC.h"
#import "ProjectCell2.h"
#import "ProjectDetailVC.h"
@interface MyProjectStatusVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;



@end

@implementation MyProjectStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
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
    [self headerFreshing];
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
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
    
    [HttpCenterAction GetMyProject:UserDefaultEntity.uuid ifAudit:-1 page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
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
-(void)footerFreshing{
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        
        [HttpCenterAction GetMyProject:UserDefaultEntity.uuid ifAudit:-1 page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }
            [self.tableView reloadData];
            
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
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    
    ProjectCell2 *cell = (ProjectCell2*)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell2"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectCell2" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[ProjectCell2 class]]) {
                cell = (ProjectCell2 *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Project_ConverPic"]];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    cell.themeLabel.text=[dict objectForKey:@"t_Project_Name"];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"t_User_RealName"],[dict objectForKey:@"PositionName"]];
    cell.contentLabel.text=[dict objectForKey:@"t_Project_OneWord"];
    cell.statusLabel.text=[dict objectForKey:@"PhaseName"];
    
    cell.projectLabel.text=[NSString stringWithFormat:@"%@ / %@",[dict objectForKey:@"FiledName"],[dict objectForKey:@"FinancePhaseName"]];
    [cell.Deletebtn addTarget:self action:@selector(DeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger status=[(NSNumber*)[dict objectForKey:@"t_Project_Audit"]integerValue];
    if (status==1) {
        [cell.statesImageView setImage:[UIImage imageNamed:@"yitongguo"]];
        cell.Deletebtn.hidden=YES;
    } else{
        [cell.statesImageView setImage:[UIImage imageNamed:@"weitongguo"]];
        cell.Deletebtn.hidden=NO;
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    ProjectDetailVC *projectDeatil=[[ProjectDetailVC alloc]init];
    projectDeatil.guId=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:projectDeatil animated:YES];
    
}

- (void)DeleteAction:(UIButton *)sender
{

    NSInteger index =sender.tag;
    NSDictionary *dict=[_funlist objectAtIndex:index];
    [self delete:[dict objectForKey:@"Guid"]];
    
}


//- (NSArray *)leftButtons{
//    
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:@"删除"];
//    
//    return rightUtilityButtons;
//}
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
//    
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
//    [self delete:[dict objectForKey:@"Guid"]];
//    NSMutableArray *array=[[NSMutableArray alloc]init];
//    for (int i=0; i<[_funlist count]; i++) {
//        NSDictionary *dict=[_funlist objectAtIndex:i];
//        if (i!=indexPath.row) {
//            [array addObject:dict];
//        }
//    }
//    _funlist=array;
//    [self.tableView reloadData];
//}


- (void)delete:(NSString*)guId{
    
    [HttpProjectAction DelProject:guId Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
        [self refeleshController];
    }];
    
}


@end
