//
//  QYServiceVC.m
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QYServiceVC.h"

@interface QYServiceVC ()<UITextViewDelegate>{
    CGFloat width;
    NSString *style;
}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) NSMutableArray *itemlist;

@property (nonatomic,strong) UILabel *themeLabel;

@property (nonatomic,strong) UILabel *planceLabel;

@end

@implementation QYServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"企业服务"];
    
    if (_itemlist !=nil) {
        _itemlist=[[NSMutableArray alloc]init];
    }
    
    [self.view setBackgroundColor:[UIColor themeGrayColor]];
    
    [self createHeaderView];
    [self createTextView];
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitPrivate:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createHeaderView{
    
//    CGFloat height=([_itemlist count]/3+1) *40;

    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    _headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_headView];
    
    width=(SCREEN_WIDTH-60)/3;
    
    _themeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    _themeLabel.text=@"服务需求";
    _themeLabel.font=Font(15);
    _themeLabel.textColor=[UIColor blackColor];
    [self.view addSubview:_themeLabel];
    
    if ([_itemlist count]>2) {
        
        for (int i=0; i<3; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+15*SCREEN_WSCALE), _themeLabel.bottom+10*SCREEN_WSCALE+(i/3)*40*SCREEN_WSCALE, width, 30*SCREEN_WSCALE);
            NSDictionary *dict=[_itemlist objectAtIndex:i];
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            
            [_headView addSubview:button];
        }
        
    } else {
        
        for (int i=0; i<[_itemlist count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), _themeLabel.bottom+10, width, 30*SCREEN_WSCALE);
            NSDictionary *dict=[_itemlist objectAtIndex:i];
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            
            [_headView addSubview:button];
        }

        
        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake([_itemlist count]%3 *(width+20)+20, _themeLabel.bottom+10, 30, 30)];
        [addBtn setImage:[UIImage imageNamed:@"add_private"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(selectStyle:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:addBtn];
    }
}

-(void)createTextView{

    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, _headView.bottom+15, SCREEN_WIDTH-20, 200)];
    _textView.delegate=self;
    _textView.font=Font(14);
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    _planceLabel=[self createLabelFrame:CGRectMake(5*SCREEN_WSCALE, 5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 32) color:[UIColor lightGrayColor] font:Font(14) text:self.pralar];
    _planceLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _planceLabel.numberOfLines=2;
    [_textView addSubview:_planceLabel];

    
    UILabel *label=[self createLabelFrame:CGRectMake(40, _textView.bottom +20, SCREEN_WIDTH-80, 13) color:[UIColor grayColor] font:Font(13) text:@"请填写基本信息，青创汇会在第一时间与您联系，"];
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *label2=[self createLabelFrame:CGRectMake(40, label.bottom, 140*SCREEN_WSCALE, 13) color:[UIColor grayColor] font:Font(13) text:@"如有问题，请联系"];
    label2.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:label2];
    
    UILabel *label3=[self createLabelFrame:CGRectMake(label2.right, label2.top, 100, label2.height) color:[UIColor themeRedColor] font:Font(13) text:@"青创小秘书"];
    label3.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:label3];
}

-(void)selectStyle:(id)sender{

    BestAndDomainVC *best = [[BestAndDomainVC alloc]init];
    
    best.Byid = 108;
    [best returnArray:^(NSArray *SelectedArray) {
        _itemlist= [SelectedArray mutableCopy];
        [self createHeaderView];
    }];
    [self.navigationController pushViewController:best animated:YES];
}

-(void)submitPrivate:(id)sender{
    
    if ([_itemlist count]>3) {
        for (int i=0; i<3; i++) {
            NSDictionary *dict=[_itemlist objectAtIndex:i];
            if ([self isBlankString:style]) {
                style=[dict objectForKey:@"Id"];
            } else {
                style=[style stringByAppendingFormat:@";%@",[dict objectForKey:@"Id"]];
            }
        }
    } else {
        for (NSDictionary *dict in _itemlist) {
            if ([self isBlankString:style]) {
                style=[dict objectForKey:@"Id"];
            } else {
                style=[style stringByAppendingFormat:@";%@",[dict objectForKey:@"Id"]];
            }
        }
    }
    
    if ([self isBlankString:style]) {
        
        [SVProgressHUD showErrorWithStatus:@"服务需求为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if([_itemlist count]>3){
        
        [SVProgressHUD showErrorWithStatus:@"服务需求最多三个" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self isBlankString:_textView.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"信息不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSMutableDictionary *request=[NSMutableDictionary new];
    [request setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [request setObject:_textView.text forKey:@"contents"];
    [request setObject:@"0" forKey:@"type"];
    [request setObject:style forKey:@"style"];
    [request setObject:[MyAes aesSecretWith:@"contents"] forKey:@"Token"];
    
    [HttpDiscoverAction AddPersonal:request complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"true"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请检查信息重新提交" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length]>0) {
        _planceLabel.hidden=YES;
    }else{
        _planceLabel.hidden=NO;
    }
}

@end
