//
//  AddFriendViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AddFriendViewController.h"
#import "SearchFriendResultCell.h"

@interface AddFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *searchResult;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"查询好友"];
    if (_searchResult !=nil) {
        _searchResult=[[NSMutableArray alloc] init];
    }
    
    [self createSearch];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createSearch{

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 44)];
    _searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索好友" style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];

}

-(void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_tableView];
}

- (void)searchAction:(id)sender {
    /**if ([self.searchBar.text length] > 0) {
        NSString *keyWords = self.searchBar.text;
        
        [self.tableView reloadData];
    }**/
    
    NSMutableArray *item=[[NSMutableArray alloc]init];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"小明",@"name",
                    @"e4fa30f6-b059-4b07-b00a-3131c8dad724",@"userId",
                    @"",@"image", nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"小花",@"name",
                @"978ca611-7f10-4467-809f-cc5f5f11b6c4",@"userId",
                     @"",@"image", nil]];
    [item addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     @"小兰",@"name",
                @"aad46aa0-154c-4be1-80cc-92e9671b8c00",@"userId",
                     @"",@"image", nil]];
    _searchResult=item;
    [self.tableView reloadData];
}

#pragma mark - searchResultDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _searchResult.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reusableCellWithIdentifier = @"SearchFriendResultCell";
    SearchFriendResultCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    
    cell = [[SearchFriendResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellWithIdentifier];
    
    NSDictionary *dict=[_searchResult objectAtIndex:indexPath.row];
    
    cell.lblName.text = [dict objectForKey:@"name"];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    /**
    RCDUserInfo *user =_searchResult[indexPath.row];
    if(user){
        cell.lblName.text = user.name;
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
    **/
    return cell;
}

#pragma mark - searchResultDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict=[_searchResult objectAtIndex:indexPath.row];
    
    RCContactNotificationMessage *message=[RCContactNotificationMessage new];
    message.operation=ContactNotificationMessage_ContactOperationRequest;
    message.sourceUserId=UserDefaultEntity.userId;
    message.targetUserId=[dict objectForKey:@"userId"];
    message.message=@"新的好友请求";
    message.extra=nil;
    [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_SYSTEM targetId:message.sourceUserId content:message pushContent:@"&&添加你为好友" success:^(long messageId) {
        
        NSLog(@"回复参数：%ld",messageId);
        [Utils showAlertView:@"温馨提示" :@"添加成功" :@"知道了"];
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
        NSLog(@"回复参数：%ld===错误编码：%ld",messageId,nErrorCode);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
