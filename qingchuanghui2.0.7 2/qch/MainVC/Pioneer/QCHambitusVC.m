//
//  QCHambitusVC.m
//  qch
//
//  Created by 青创汇 on 16/1/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHambitusVC.h"
#import "QCHNavigationController.h"
#import "AmbitusCell.h"
#import "ADDdynamicVC.h"

@interface QCHambitusVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * CityStr;
}

@property (nonatomic, strong)UITableView *hambitustableview;

@end

@implementation QCHambitusVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancle)];
    [self.navigationItem setLeftBarButtonItem:leftitem];
    [self createTableView];
   
}

-(void)createTableView{
    self.hambitustableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.hambitustableview.delegate = self;
    self.hambitustableview.dataSource = self;
    [self setExtraCellLineHidden:_hambitustableview];
    [self.view addSubview:self.hambitustableview];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)cancle{
    if ([self.navigationController isKindOfClass:[QCHNavigationController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return UserDefaultEntity.poilist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const TableViewCellIdentifier = @"Cell";
    AmbitusCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    if (cell == nil) {
        cell = [[AmbitusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BMKPoiInfo *poiInfo = UserDefaultEntity.poilist[indexPath.row];
    cell.CityLab.text = poiInfo.name;
    cell.AddressLab.text = poiInfo.address;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*SCREEN_WSCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *poiInfo = UserDefaultEntity.poilist[indexPath.row];
    CityStr = poiInfo.name;
    if (self.returnTextBlock !=nil) {
        self.returnTextBlock(CityStr);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
@end
