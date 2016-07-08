//
//  SelectTimeVC.m
//  qch
//
//  Created by 苏宾 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SelectTimeVC.h"

@interface SelectTimeVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *defaultCity;
    
    BOOL status[1000]; //记录每个单元格的状态   默认no闭合
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *timelist;

@end

@implementation SelectTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择时间"];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_datelist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //加载是否显示二级详情
    BOOL closeAge = status[section];
    
    if (closeAge == NO) {
        return 0;
    }
    NSArray *array=(NSArray*)[[_datelist objectAtIndex:section] objectForKey:@"Times"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[[[_datelist objectAtIndex:indexPath.section] objectForKey:@"Times"] objectAtIndex:indexPath.row];
    
    static NSString *iden = @"cell_ciname";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        cell.backgroundColor = [UIColor clearColor];
        if ([[dict objectForKey:@"t_PlaceOder_Ordered"]isEqualToString:@"1"]) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.textLabel.textColor = [UIColor orangeColor];
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@:00--%@:00",[dict objectForKey:@"t_PlaceOder_sTime"],[dict objectForKey:@"t_PlaceOder_eTime"]];
    
    return cell;
}

//显示头部标签
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dict=[_datelist objectAtIndex:section];
    
    UIControl *titileView = [[UIControl alloc] initWithFrame:CGRectZero];
    titileView.tag = section;
    [titileView setBackgroundColor:[UIColor whiteColor]];
    [titileView addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置  头视图的标题什么的
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = Font(16);
    titleLable.text = [dict objectForKey:@"t_Order_Date"];
    [titleLable sizeToFit];
    [titileView addSubview:titleLable];
    
    UIImageView *nextImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, titleLable.top, 15*PMBWIDTH, titleLable.height)];
    nextImgeView.image = [UIImage imageNamed:@"select_next"];
    [titileView addSubview:nextImgeView];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(titleLable.left, titleLable.bottom+5, SCREEN_WIDTH-10, 1)];
    line.backgroundColor=[UIColor themeGrayColor];
    [titileView addSubview:line];
    
    return titileView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36*PMBWIDTH;
}

- (void)sectionAction:(UIControl *)control{
    
    NSInteger section = control.tag;
    
    status[section] = !status[section];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade]; //刷新制定单元格
    if (status[section]) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection: control.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36*PMBWIDTH;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *prevIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:prevIndexPath];
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary *dict=[_datelist objectAtIndex:indexPath.section];
    NSDictionary *timeDict=[[dict objectForKey:@"Times"] objectAtIndex:indexPath.row];
    if ([[timeDict objectForKey:@"t_PlaceOder_Ordered"]isEqualToString:@"1"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        if (self.dateBlock) {
            self.dateBlock([timeDict objectForKey:@"Guid"], indexPath.section);
            [self.navigationController popViewControllerAnimated:YES];
        }
//        if ([_timeDelegate respondsToSelector:@selector(selectDate:index:)]) {
//            NSInteger index=indexPath.section;
//            [_timeDelegate selectDate:[timeDict objectForKey:@"Guid"] index:index];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
}


@end
