//
//  SelectCourseVC.m
//  qch
//
//  Created by W.兵 on 16/4/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SelectCourseVC.h"
#import "CourseCollCell.h"

@interface SelectCourseVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *seleArray;

@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation SelectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系列课程";
    
    _seleArray = [[NSMutableArray array]init];
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *x=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = x;

    [self createTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done:(UIButton *)sender {
    
    if ([self.selectDeleage respondsToSelector:@selector(updateData:)]) {
        
        NSSet *set=[NSSet setWithArray:_seleArray];
        NSArray *array=[set allObjects];
        NSMutableArray *muArray=[array copy];
        [self.selectDeleage updateData:muArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    tableView.tableFooterView=view;
}

-(void)headerFreshing{
    
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [HttpCollegeAction GetGroupCourseList:_courseGroup userguid:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"groupguid"] complete:^(id result, NSError *error) {
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });
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
        
        [HttpCollegeAction GetGroupCourseList:_courseGroup userguid:UserDefaultEntity.uuid page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"groupguid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
//                [Utils showToastWithText:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"illegal"]) {
//                [Utils showToastWithText:[dict objectForKey:@"result"]];
            }else{
//                [Utils showToastWithText:@"数据加载失败，请重新加载"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    
    CourseCollCell *cell = (CourseCollCell*)[tableView dequeueReusableCellWithIdentifier:@"CourseCollCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"CourseCollCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[CourseCollCell class]]) {
                cell = (CourseCollCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    cell.titleLabel.text = [dict objectForKey:@"t_Course_Title"];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"t_Course_Price"]];
    
    if ([self setSignBtn:[dict objectForKey:@"Guid"]]) {
        
        if ([_seleArray count]==0) {
            [_seleArray addObject:dict];
        } else {
            if ([self setSaveBtn:[dict objectForKey:@"Guid"]]) {
                
                [_seleArray addObject:dict];
            }
        }
       
        cell.isSelect=YES;
        [cell.signBtn setImage:[UIImage imageNamed:@"xuanzhong.jpg"]];
    } else {
        cell.isSelect=NO;
        [cell.signBtn setImage:[UIImage imageNamed:@"weixuanzhong.jpg"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)setSignBtn:(NSString*)Guid{

    for (NSDictionary *item in _selectArray) {
        if ([[item objectForKey:@"Guid"] isEqualToString:Guid]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)setSaveBtn:(NSString *)guid{
    for (NSDictionary *item in _seleArray) {
        if (![[item objectForKey:@"Guid"] isEqualToString:guid]) {
            return YES;
        }else{
            
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseCollCell *cell = (CourseCollCell *)[tableView  cellForRowAtIndexPath:indexPath];
    
    if (cell.isSelect) {
        
        cell.isSelect=NO;
        [cell.signBtn setImage:[UIImage imageNamed:@"weixuanzhong.jpg"]];
        [_seleArray removeObject:[_funlist objectAtIndex:indexPath.row]];
    } else {
        
        cell.isSelect=YES;
        [cell.signBtn setImage:[UIImage imageNamed:@"xuanzhong.jpg"]];
        [_seleArray addObject:[_funlist objectAtIndex:indexPath.row]];
    }
}


@end
