//
//  ActivityVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ActivityVC.h"
#import "PActivityModel.h"
#import "ActivityCell.h"
#import "ActivityDetailVC.h"

@interface ActivityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *userlist;


@end

@implementation ActivityVC

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
    
   [HttpCenterAction GetPraiseActivity:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error){
       
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PActivityModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
            _userlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            _userlist=[[NSMutableArray alloc]init];
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
 
        }else{
            _funlist=[[NSMutableArray alloc]init];
            _userlist=[[NSMutableArray alloc]init];
 
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
    return 110*SCREEN_WSCALE;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PActivityModel *model=[_funlist objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%zi%zi",indexPath.section,indexPath.row];
    
    ActivityCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (cell == nil) {
        cell=[[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PActivityModel *model=[_funlist objectAtIndex:indexPath.row];
    ActivityDetailVC *activityDetail=[[ActivityDetailVC alloc]init];
    activityDetail.guid=model.Guid;
    [self.navigationController pushViewController:activityDetail animated:YES];
}


@end
