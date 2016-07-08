//
//  AccountPayVC.m
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AccountPayVC.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"

@interface AccountPayVC ()<UITextFieldDelegate,UIAlertViewDelegate>{
    UIButton *zfbBtn;
    UIButton *wxBtn;

    NSInteger index_btn;
    
    UIButton *payBtn;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic,strong) UITextField *numTextField;
@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) OrderModel *model;

@end

@implementation AccountPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"创业币充值"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpay:) name:@"wxpay" object:nil];
    
    self.view.backgroundColor=[UIColor themeGrayColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView=scrollView;
    
    [self.view addSubview:scrollView];
    
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 40*SCREEN_WSCALE, 80, 80)];
    [headImageView setImage:[UIImage imageNamed:@"cyb_img"]];
    [scrollView addSubview:headImageView];
    
    _numTextField=[[UITextField alloc]initWithFrame:CGRectMake(headImageView.left, headImageView.bottom+10*SCREEN_WSCALE, headImageView.width, 30)];
    _numTextField.placeholder=@"请输入金额";
    _numTextField.textColor=[UIColor redColor];
    _numTextField.delegate=self;
    _numTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _numTextField.textAlignment = NSTextAlignmentCenter;
    _numTextField.font=Font(14);
    [_numTextField addTarget:self action:@selector(updatePriceView:) forControlEvents:UIControlEventEditingChanged];
    [_numTextField addTarget:self action:@selector(complete:) forControlEvents:UIControlEventEditingDidEnd];
    [scrollView addSubview:_numTextField];
    
    UILabel *line=[self createLabelFrame:CGRectMake(0, _numTextField.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 10) color:[UIColor themeGrayColor] font:Font(0) text:@""];
    line.backgroundColor=[UIColor themeGrayColor];
    [scrollView addSubview:line];
    
    UILabel *themeLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, 20*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"请选择支付方式"];
    [scrollView addSubview:themeLabel];
    
    UILabel *line2=[self createLabelFrame:CGRectMake(themeLabel.left, themeLabel.bottom+10, SCREEN_WIDTH, 1) color:nil font:nil text:nil];
    line2.backgroundColor=[UIColor themeGrayColor];
    [scrollView addSubview:line2];
    
    UIImageView *zfbImageView=[[UIImageView alloc]initWithFrame:CGRectMake(line2.left, line2.bottom+10, 40*SCREEN_WSCALE, 40*SCREEN_WSCALE)];
    [zfbImageView setImage:[UIImage imageNamed:@"apliy"]];
    [scrollView addSubview:zfbImageView];
    
    UILabel *zfbLabel=[self createLabelFrame:CGRectMake(zfbImageView.right +20, zfbImageView.top, SCREEN_WIDTH-20-50*SCREEN_WSCALE-zfbImageView.width, 20) color:[UIColor blackColor] font:Font(15) text:@"支付宝"];
    [scrollView addSubview:zfbLabel];
    
    index_btn=1;
    
    zfbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    zfbBtn.frame=CGRectMake( SCREEN_WIDTH-30*SCREEN_WSCALE,zfbImageView.top+10*SCREEN_WSCALE, 20*SCREEN_WSCALE, 20*SCREEN_WSCALE);
    [zfbBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
    zfbBtn.tag=1;
    
    [zfbBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:zfbBtn];
    
    
    UILabel *zfbDetail=[self createLabelFrame:CGRectMake(zfbLabel.left, zfbImageView.bottom-14, zfbLabel.width, 14) color:[UIColor lightGrayColor] font:Font(12) text:@"推荐已安装支付宝客户端的用户使用"];
    [scrollView addSubview:zfbDetail];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(zfbLabel.left, zfbDetail.bottom+10, SCREEN_WIDTH-60, 1)];
    line3.backgroundColor=[UIColor themeGrayColor];
    [scrollView addSubview:line3];
    
    UIImageView *wxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(zfbImageView.left, zfbImageView.bottom+20, zfbImageView.width, zfbImageView.height)];
    [wxImageView setImage:[UIImage imageNamed:@"wx"]];
    [scrollView addSubview:wxImageView];
    
    UILabel *wxLabel=[self createLabelFrame:CGRectMake(wxImageView.right +20, wxImageView.top, zfbLabel.width, 20) color:[UIColor blackColor] font:Font(15) text:@"微信支付"];
    [scrollView addSubview:wxLabel];
    
    UILabel *wxDetail=[self createLabelFrame:CGRectMake(wxLabel.left, wxImageView.bottom-14, zfbLabel.width, 14) color:[UIColor lightGrayColor] font:Font(12) text:@"推荐已安装微信客户端的用户使用"];
    [scrollView addSubview:wxDetail];
    
    wxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.frame=CGRectMake( SCREEN_WIDTH-30*SCREEN_WSCALE,wxImageView.top+10*SCREEN_WSCALE, 20*SCREEN_WSCALE, 20*SCREEN_WSCALE);
    [wxBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    wxBtn.tag=2;
    [wxBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:wxBtn];
    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(0, wxImageView.bottom+20, SCREEN_WIDTH, 10)];
    line4.backgroundColor=[UIColor themeGrayColor];
    [scrollView addSubview:line4];
    
    UILabel *payLabel=[self createLabelFrame:CGRectMake(20*SCREEN_WSCALE, line4.bottom+20, SCREEN_WIDTH/2-20, 20) color:[UIColor blackColor] font:Font(14) text:@"需要支付金额:"];
    payLabel.textAlignment=NSTextAlignmentRight;
    [scrollView addSubview:payLabel];
    
    _priceLabel=[self createLabelFrame:CGRectMake(payLabel.right, payLabel.top, SCREEN_WIDTH/2-20*SCREEN_WSCALE, payLabel.height) color:[UIColor redColor] font:Font(14) text:@"*元"];
    [scrollView addSubview:_priceLabel];
    
    payBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame=CGRectMake(20*SCREEN_WSCALE, _priceLabel.bottom+15*SCREEN_WSCALE, SCREEN_WIDTH-40*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    payBtn.layer.borderColor=[UIColor blackColor].CGColor;
    payBtn.layer.borderWidth=1;
    payBtn.layer.masksToBounds=YES;
    payBtn.layer.cornerRadius=payBtn.height/2;
    [payBtn setTitle:@"确定" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font=Font(15);
    [payBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.enabled=YES;
    [scrollView addSubview:payBtn];
    
    
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 500*SCREEN_WSCALE);
}



-(void)updatePriceView:(id)sender{
    if ([self isBlankString:_numTextField.text]) {
        _priceLabel.text=@"";
    } else {
        if (_numTextField.text.length>9) {
            _priceLabel.text=[NSString stringWithFormat:@"%@元",[_numTextField.text substringToIndex:9]];
        }else if ([_numTextField.text floatValue]<0.00999999977){
            _priceLabel.text = @"0.01";
            
        }
        else{
        _priceLabel.text=[NSString stringWithFormat:@"%@元",_numTextField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        
        _isHaveDian = NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //                    [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    _priceLabel.text=[NSString stringWithFormat:@"%@元",textField.text];
                    return NO;
                }
                //                if (single == '0') {
                //
                //                    //                    [self alertView:@"亲，第一个数字不能为0"];
                //
                //                    [activityPrice.text stringByReplacingCharactersInRange:range withString:@""];
                //
                //                    return NO;
                //
                //                }
                
            }
            if (single=='.')
            {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian=YES;
                    return YES;
                }else{
                    //                    [self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    _priceLabel.text=[NSString stringWithFormat:@"%@元",textField.text];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        //                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            //            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            _priceLabel.text=[NSString stringWithFormat:@"%@元",textField.text];
            return NO;
        }
    }else{
        return YES;
    }
    

}

- (void)complete:(id)sender
{

    if (![self isBlankString:_numTextField.text]) {
        if ([_numTextField.text floatValue]<0.00999999977) {
            [SVProgressHUD showErrorWithStatus:@"充值金额不能小于一分噢 亲!" maskType:SVProgressHUDMaskTypeBlack];
            _numTextField.text = @"0.01";
        }
    }
}

-(void)selectPayWay:(UIButton*)sender{

    UIButton *button=(UIButton*)sender;
    NSInteger index=[button tag];
    if (index==1) {
        index_btn=1;
        [zfbBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    }else{
        index_btn=2;
        [zfbBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
    }
}

-(void)payOrder:(UIButton*)sender{
    
    if ([self isBlankString:_numTextField.text]) {

        [SVProgressHUD showErrorWithStatus:@"请填写创业币" maskType:SVProgressHUDMaskTypeBlack];
    } else {
        payBtn.enabled=NO;
        [self createOrderPay];
    }
}

-(void)createOrderPay{

    NSString *payType;
    if (index_btn==1) {
        payType=@"支付宝支付";
    }else{
        payType=@"微信支付";
    }
    
    NSString *guid=@"";
    

    [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
    
    [HttpAlipayAction AddOrder:guid userGuid:UserDefaultEntity.uuid ordertype:1 paytype:payType money:_numTextField.text name:@"创业币充值" remark:@"创业币充值" Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

        payBtn.enabled=YES;
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *param=[dict objectForKey:@"result"][0];
            
            NSString *orderNum=[param objectForKey:@"t_Order_No"];
            
            if (index_btn==1) {
                
                if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付宝未安装,是否下载最新版支付宝?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                    alert.tag = 8888;
                    [alert show];
                }else{
                    
                    [self AlipayAction:orderNum];
                }
            } else {
                if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信未安装,是否下载最新版微信?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                    alert.tag = 8889;
                    [alert show];
                    return;
                }else{
                    
                    if ([self isBlankString:_numTextField.text]) {
                        [SVProgressHUD showErrorWithStatus:@"创业币不能为空" maskType:SVProgressHUDMaskTypeBlack];
                        return;
                    }
                    
                    [self WXPayAction:orderNum];
                }
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取订单失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)AlipayAction:(NSString *)orderNum{
    
    if ([self isBlankString:orderNum]) {
        [SVProgressHUD showErrorWithStatus:@"订单不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    
    [HttpLoginAction GetPayKey:@"ALiPay" Token:[MyAes aesSecretWith:@"type"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            float price=[(NSNumber*)_priceLabel.text floatValue];
            
            NSString *partner = [dict objectForKey:@"PartnerID"];
            NSString *seller = [dict objectForKey:@"SellerID"];
            NSString *privateKey = [dict objectForKey:@"PartnerPrivKey"];
            
            if ([partner length] == 0 ||
                [seller length] == 0 ||
                [privateKey length] == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"缺少partner或者seller或者私钥。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            Order *order = [[Order alloc]init];
            order.partner = partner;
            order.seller = seller;
            order.tradeNO = orderNum;//订单ID
            order.productName = @"创业币充值";
            order.productDescription = @"创业币充值";
            order.amount = [NSString stringWithFormat:@"%.2f",price];
            order.notifyURL = @"http://www.cn-qch.com:8002/Alipay/notify_url.aspx";
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            NSString *appScheme = @"qch";
            //将商品信息拼接为字符串
            NSString *orderSpec = [order description];
            
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            //将签名成功字符串格式化为订单字符串
            NSString *orderString =nil;
            if (signedString !=nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signedString,@"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    Liu_DBG(@"reslut = %@",resultDic);
                    if ([resultDic objectForKey:@"seller_id"]) {
                         [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            
        } else{
    
            [SVProgressHUD showErrorWithStatus:@"交易失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)WXPayAction:(NSString *)orderNum{
    
    if ([self isBlankString:orderNum]) {

        [SVProgressHUD showErrorWithStatus:@"订单不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    
    [HttpLoginAction GetPayKey:@"wxPay" Token:[MyAes aesSecretWith:@"type"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
        
            _model=[[OrderModel alloc]init];
            _model.orderName = @"创业币充值";
            _model.orderPrice = [NSString stringWithFormat:@"%.f",[(NSNumber*)_numTextField.text floatValue]*100];//*100
            _model.orderNum = orderNum;
            
            payRequsestHandler *rep = [payRequsestHandler alloc];
            [rep init:[dict objectForKey:@"APP_ID"] mch_id:[dict objectForKey:@"MCH_ID"]];
            [rep setKey:[dict objectForKey:@"PARTNER_ID"]];
            NSMutableDictionary *dict = [rep sendPay_demo:_model];
            if (dict == nil) {
                [super showAlertWithTitle:@"交易失败，请选择其他支付方式"];
            }else{
                NSMutableString *stamp = [dict objectForKey:@"timestamp"];
                //调起微信支付
                PayReq *req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
            }

        }else{
            [SVProgressHUD showErrorWithStatus:@"交易失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
            
        }
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }else if (buttonIndex == 1){
        if (alertView.tag == 8888) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/zhi-fu-bao-zhifubao-kou-bei/id333206289?mt=8#"];
            [[UIApplication sharedApplication]openURL:url];
        }else if (alertView.tag==8889){
            NSURL *url =[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"];
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }
}

-(void)wxpay:(NSNotification *)text{
    
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpay" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_numTextField.text.length>9) {
        [SVProgressHUD showErrorWithStatus:@"请输入9位以内" maskType:SVProgressHUDMaskTypeBlack];
        _numTextField.text = [_numTextField.text substringToIndex:9];
    }
}
@end
