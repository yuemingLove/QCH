//
//  SearchViewController.m
//  qch
//
//  Created by 青创汇 on 16/5/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) NSUserDefaults *userDef;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self.view addSubview:self.searchBar];
    [self createTableView];
    self.arr = [NSMutableArray arrayWithCapacity:1];
    [self.arr addObjectsFromArray: [self.userDef valueForKey:@"search"]];

}



- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = YES;
        _searchBar.frame = CGRectMake(0, 20, ScreenWidth, 44);
        _tableView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight-64-44);
        _searchBar.showsCancelButton = YES;
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
    _tableView.frame = CGRectMake(0,44,ScreenWidth,ScreenHeight-64-44);
    self.navigationController.navigationBarHidden = NO;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"搜索字数不能超过20个字" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        NSMutableArray *arr = [NSMutableArray arrayWithArray: [self.userDef valueForKey:@"search"]];
        if ([arr containsObject:_searchBar.text]) {
            [arr removeObject:_searchBar.text];
            [self.tableView reloadData];
            
        }else{
            [arr addObject:self.searchBar.text];
            [self.userDef setValue:arr forKey:@"search"];
            [self.userDef synchronize];
        }
        
        [self.arr addObject:self.searchBar.text];
        [self.tableView reloadData];

        
        if (self.returnstringblock!=nil) {
            self.returnstringblock(searchBar.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)returnString:(ReturnStringBlock)block
{
    self.returnstringblock = block;
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.arr == nil) {
        return 1;
    }else
    {
        return 2+self.arr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40*PMBWIDTH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[UITableViewCell alloc
                 ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normal"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"搜索历史";
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.row == self.arr.count+1){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"清空搜索历史";
        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }
    else{
        cell.textLabel.text = self.arr[indexPath.row-1];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.arr.count+1) {
        [self.userDef setValue:nil forKey:@"search"];
        [self.userDef synchronize];
        self.arr = nil;
        [self.tableView reloadData];
    }else{
        self.searchBar.text = self.arr[indexPath.row-1];
        if (self.returnstringblock!=nil) {
            self.returnstringblock(_searchBar.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - getter
- (NSUserDefaults *)userDef{
    
    if (_userDef == nil) {
        self.userDef = [NSUserDefaults standardUserDefaults];
    }
    return _userDef;
}
@end
