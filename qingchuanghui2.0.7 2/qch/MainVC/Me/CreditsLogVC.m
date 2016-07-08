//
//  CreditsLogVC.m
//  qch
//
//  Created by 青创汇 on 16/6/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CreditsLogVC.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "IntegralrecordCell.h"
@interface CreditsLogVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *type;
    UIButton *TypeBtn;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation CreditsLogVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分纪录";
    type=@"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimiss:) name:@"dimiss" object:nil];
    
    TypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    TypeBtn.frame = CGRectMake(0, 0, 60, 32);
    [TypeBtn setTitle:@"全部" forState:UIControlStateNormal];
    TypeBtn.titleLabel.font = Font(16);
    [TypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
    [TypeBtn addTarget:self action:@selector(Filter:) forControlEvents:UIControlEventTouchUpInside];
    TypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    TypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, TypeBtn.titleLabel.width+15, 0, -TypeBtn.width-15);
    UIBarButtonItem *TypeBtnItem=[[UIBarButtonItem alloc]initWithCustomView:TypeBtn];
    self.navigationItem.rightBarButtonItem = TypeBtnItem;
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    [self createTableView];
}

- (NSArray *) titles {
    return @[@"全部",
             @"消费",
             @"获得"
             ];
}
- (NSArray *) images {
    return @[@"quanbu",
             @"xiaofei",
             @"huode"
             ];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:_tableView];
    [self refeleshController];
    [self setExtraCellLineHidden:_tableView];
    
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)headerFreshing{
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [HttpCenterAction IntegralList:UserDefaultEntity.uuid type:type page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
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

-(void)footerFreshing{
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        [HttpCenterAction IntegralList:UserDefaultEntity.uuid type:type page:[_funlist count]/PAGESIZE +1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
            }
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
        }];
        
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    IntegralrecordCell *cell = (IntegralrecordCell*)[tableView dequeueReusableCellWithIdentifier:@"IntegralrecordCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"IntegralrecordCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[IntegralrecordCell class]]) {
                cell = (IntegralrecordCell *)oneObject;
                
            }
        }
    }
    [cell updata:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)Filter:(id)sender
{
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao2"] forState:UIControlStateNormal];
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:120 menuFrame:[self menuFrame]                                                             item:obj
                                                           action:^(NSInteger index) {
     [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
       if (index==0) {
           [TypeBtn setTitle:@"全部" forState:UIControlStateNormal];
       }else if (index==1){
           [TypeBtn setTitle:@"消费" forState:UIControlStateNormal];
       }else if (index==2){
           [TypeBtn setTitle:@"获得" forState:UIControlStateNormal];
       }
    type = [NSString stringWithFormat:@"%ld",(long)index];
    [self headerFreshing];
    }];

}
- (CGRect)menuFrame {
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width - 72;
    CGFloat menuY = 18;
    CGFloat width = 120;
    CGFloat heigh = 20 * 6;
    return (CGRect){menuX,menuY,width,heigh};
}

-(void)dimiss:(NSNotification *)text{
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpay" object:nil];
}
@end
