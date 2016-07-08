//
//  SelectProjectVC.m
//  qch
//
//  Created by 苏宾 on 16/3/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SelectProjectVC.h"
#import "ProjectCell.h"

@interface SelectProjectVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SelectProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的项目"];
    
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView*)tableView{

    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=view;
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
            }
        }
    }
    cell.tag = indexPath.row;
    [cell updateFrame:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"t_Project_Audit"]isEqualToString:@"0"]) {
        
        [SVProgressHUD showErrorWithStatus:@"该项目正在审核中……" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        
    if ([self.spDelegate respondsToSelector:@selector(selectProject:)]) {
        [self.spDelegate selectProject:[dict objectForKey:@"Guid"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    }
}


@end
