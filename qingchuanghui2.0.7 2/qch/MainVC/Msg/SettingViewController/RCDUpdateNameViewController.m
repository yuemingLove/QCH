//
//  RCDUpdateNameViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDUpdateNameViewController.h"


@implementation RCDUpdateNameViewController



-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIView *bgkView=[[UIView alloc]initWithFrame:CGRectMake(0, 20*PMBWIDTH, SCREEN_WIDTH, 30*PMBWIDTH)];
    [bgkView setBackgroundColor:[UIColor themeGrayColor]];
    [self.view addSubview:bgkView];
    
    self.tfName=[[UITextField alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 2*PMBWIDTH, SCREEN_WIDTH-20*SCREEN_WSCALE, 26*PMBWIDTH)];
    self.tfName.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tfName.textColor=[UIColor blackColor];
    self.tfName.font=Font(15);
    [bgkView addSubview:self.tfName];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    
    self.tfName.text = self.displayText;
    
}

-(void) backBarButtonItemClicked:(id) sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) rightBarButtonItemClicked:(id) sender{
    
    //保存讨论组名称
    if(self.tfName.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入讨论组名称!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //回传值
    if (self.setDisplayTextCompletion) {
        self.setDisplayTextCompletion(self.tfName.text);
    }
    
    //保存设置
    [[RCIMClient sharedRCIMClient] setDiscussionName:self.targetId name:self.tfName.text success:^{
        
    } error:^(RCErrorCode status) {
        
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //收起键盘
    [self.tfName resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}
@end
