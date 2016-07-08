//
//  PrivateVC.m
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PrivateVC.h"
#import "PrivateCell.h"
#import "SubmitPrivateVC.h"
#import "QYServiceVC.h"

@interface PrivateVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation PrivateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"私人定制"];
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    [self createTableView];
    [self getData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    tableView.tableFooterView=view;
}

-(void)getData{

    NSMutableArray *item=[[NSMutableArray alloc]init];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"企业服务",@"name",
                     @"根据您企业需求和发展需要，专业为您打造一套符合您公司发展的完美方案",@"content",
                     @"qyfw",@"image",
                     nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"技术教练",@"name",
                     @"根据团队特点制定成长和考核路径，帮助创业者打造一支技术铁军",@"content",
                     @"jsjl",@"image",
                     nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"商业诊断",@"name",
                     @"好的商业模式等于成功了一半，我们具有专业的项目诊断专家，全程为您保驾护航",@"content",
                     @"syzd",@"image",
                     nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"品牌推广",@"name",
                     @"成功第一步，打开知名度，您负责成功，剩下的交给青创汇，为您提供专业品牌推广服务",@"content",
                     @"pptg",@"image",
                     nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"投融咨询",@"name",
                     @"公司的发展，离不开创投的呵护，专业的服务，为您企业获得更多的投融资机会",@"content",
                     @"trzx",@"image",
                     nil]];
    _funlist=item;
    [self.tableView reloadData];
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
    
    PrivateCell *cell = (PrivateCell*)[tableView dequeueReusableCellWithIdentifier:@"PrivateCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PrivateCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[PrivateCell class]]) {
                cell = (PrivateCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    NSString *image=[dict objectForKey:@"image"];
    [cell.pImageView setImage:[UIImage imageNamed:image]];
    cell.nameLabel.text=[dict objectForKey:@"name"];
    cell.contentLabel.text=[dict objectForKey:@"content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    NSString *name=[dict objectForKey:@"name"];
    if ([name isEqualToString:@"企业服务"]) {
        QYServiceVC *service=[[QYServiceVC alloc]init];
        service.pralar=@"根据您企业需求和发展需要，专业为您打造一套符合您公司发展的完美方案";
        [self.navigationController pushViewController:service animated:YES];
    }else if ([name isEqualToString:@"技术教练"]){
    
        SubmitPrivateVC *submit=[[SubmitPrivateVC alloc]init];
        submit.theme=@"技术教练";
        submit.type=1;
        submit.pralar=@"目前在做一个智能家居项目，目前团队处于？阶段，产品处于？阶段，我们在此过程遇到了？问题，由于我们缺乏？。希望专家能为我的团队和项目进行指导，并传授一些技术团队的管理经验 ";
        submit.text=@"认真填写问题和信息，有助于您的问题得到更迅捷的解决";
        [self.navigationController pushViewController:submit animated:YES];
    }else if ([name isEqualToString:@"商业诊断"]){
        SubmitPrivateVC *submit=[[SubmitPrivateVC alloc]init];
        submit.theme=@"商业诊断";
        submit.type=2;
        submit.pralar=@"目前在做一个智能家居项目，希望专家能为我的商业模式进行诊断指导，并传授一些创业经验。";
        submit.text=@"认真填写问题和信息，有助于您的问题得到更迅捷的解决";
        [self.navigationController pushViewController:submit animated:YES];
    }else if ([name isEqualToString:@"品牌推广"]){
        SubmitPrivateVC *submit=[[SubmitPrivateVC alloc]init];
        submit.theme=@"品牌推广";
        submit.type=3;
        submit.pralar=@"请输入您的推广需求";
        submit.text=@"认真填写问题和信息，有助于您的问题得到更迅捷的解决";
        [self.navigationController pushViewController:submit animated:YES];
    }else if ([name isEqualToString:@"投融咨询"]){
        SubmitPrivateVC *submit=[[SubmitPrivateVC alloc]init];
        submit.theme=@"投融咨询";
        submit.type=4;
        submit.pralar=@"目前在做一个智能家居项目，公司运营状况处于？阶段，我们在此过程遇到了投融资问题，由于我们缺乏投融资方面的人才和经验。希望专家能为我的项目进行指导，并传授一些相关的管理经验";
        submit.text=@"认真填写问题和信息，有助于您的问题得到更迅捷的解决";
        [self.navigationController pushViewController:submit animated:YES];
    }
}

@end
