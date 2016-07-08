//
//  SubmitPrivateVC.m
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SubmitPrivateVC.h"

@interface SubmitPrivateVC ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,strong) UILabel *planceLabel;

@end

@implementation SubmitPrivateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.theme];
    
    [self.view setBackgroundColor:[UIColor themeGrayColor]];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 200)];
    _textView.font=Font(14);
    _textView.layer.cornerRadius=3;
    _textView.delegate=self;
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    
    _planceLabel=[self createLabelFrame:CGRectMake(5*SCREEN_WSCALE, 5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 20) color:[UIColor lightGrayColor] font:Font(14) text:self.pralar];
    [self setIntroductionText:self.pralar];
    [_textView addSubview:_planceLabel];
    
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitPrivate:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self.textView frame];
    
    //文本赋值
    _planceLabel.text = text;
    _planceLabel.numberOfLines =0;
    _planceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [_planceLabel sizeThatFits:CGSizeMake(_planceLabel.frame.size.width, MAXFLOAT)];
    
    _planceLabel.frame = CGRectMake(_planceLabel.frame.origin.x, _planceLabel.frame.origin.y, _planceLabel.frame.size.width, size.height);
    
    //计算出自适应的高度
    frame.size.height = size.height;
    [_textView addSubview:_planceLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)submitPrivate:(id)sender{
    
    if ([self isBlankString:_textView.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"信息不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    NSMutableDictionary *request=[NSMutableDictionary new];
    [request setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [request setObject:_textView.text forKey:@"contents"];
    [request setObject:[NSString stringWithFormat:@"%ld",_type] forKey:@"type"];
    [request setObject:@"" forKey:@"style"];
    [request setObject:[MyAes aesSecretWith:@"contents"] forKey:@"Token"];
    
    [HttpDiscoverAction AddPersonal:request complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"true"]){
            
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请假查信息重新提交" maskType:SVProgressHUDMaskTypeBlack];
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

@end
