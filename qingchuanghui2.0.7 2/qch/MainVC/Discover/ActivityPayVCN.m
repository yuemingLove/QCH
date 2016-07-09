//
//  ActivityPayVC.m
//  qch
//
//  Created by 苏宾 on 16/2/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ActivityPayVCN.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"
#import "AccountPayVC.h"
#import "DeductionVC2.h"

@interface ActivityPayVCN ()<UIAlertViewDelegate>{
    
    UIButton *zfbBtn;
    UIButton *wxBtn;
    UIButton *accountBtn;
    UILabel *moneyLabel;
    UILabel *payLabel2;
    UILabel *activityTheme;
    UILabel *activityPrice;
    UIButton *butt;
    UILabel *orderNumber;
    NSDictionary *vouherDic;
    NSInteger index_btn;
    NSIndexPath *index;
    UILabel *label1;
}

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) OrderModel *model;

@end

@implementation ActivityPayVCN

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付"];
    [self GetMyVoucher];
    vouherDic = [NSDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpay:) name:@"wxpay" object:nil];
    
    self.view.backgroundColor=[UIColor themeGrayColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView=scrollView;
    
    [self.view addSubview:scrollView];
    
    UIView *fristView=[[UIView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 80*PMBWIDTH)];
    fristView.backgroundColor=[UIColor whiteColor];
    fristView.layer.masksToBounds=YES;
    fristView.layer.cornerRadius=2;
    [scrollView addSubview:fristView];
    
    UILabel *orderLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, 60*PMBWIDTH, 17*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"订单号:"];
    [fristView addSubview:orderLabel];
    
    orderNumber=[self createLabelFrame:CGRectMake(orderLabel.right, orderLabel.top, fristView.width-90*PMBWIDTH, orderLabel.height) color:TSEColor(170, 170, 170) font:Font(14) text:_orderNum];
    [fristView addSubview:orderNumber];
    
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, orderLabel.bottom+10*PMBWIDTH, fristView.width-10*PMBWIDTH, 1*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [fristView addSubview:line];
    
    
    activityTheme=[self createLabelFrame:CGRectMake(orderLabel.left, line.bottom+10*PMBWIDTH, fristView.width-20*SCREEN_WSCALE, 17*SCREEN_WSCALE) color:[UIColor themeBlueColor] font:Font(15) text:_titlestr];
    [fristView addSubview:activityTheme];
    
    
    UIView *secordView=[[UIView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, fristView.bottom+10*PMBWIDTH, fristView.width, 330*PMBWIDTH)];
    secordView.backgroundColor=[UIColor whiteColor];
    secordView.layer.masksToBounds=YES;
    secordView.layer.cornerRadius=2;
    [scrollView addSubview:secordView];
    
    //支付方式
    UILabel *payLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, orderLabel.height) color:[UIColor blackColor] font:Font(14) text:@"请选择支付方式"];
    [secordView addSubview:payLabel];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, payLabel.bottom+10*SCREEN_WSCALE, secordView.width-10*PMBWIDTH, 1*PMBWIDTH)];
    line2.backgroundColor=[UIColor themeGrayColor];
    [secordView addSubview:line2];
    
    UIImageView *zfbImageView=[[UIImageView alloc]initWithFrame:CGRectMake(payLabel.left, line2.bottom+10*PMBWIDTH, 40*SCREEN_WSCALE, 40*SCREEN_WSCALE)];
    [zfbImageView setImage:[UIImage imageNamed:@"apliy"]];
    [secordView addSubview:zfbImageView];
    
    UILabel *zfbLabel=[self createLabelFrame:CGRectMake(zfbImageView.right +20*PMBWIDTH, zfbImageView.top+(zfbImageView.height-20*PMBWIDTH)/2, SCREEN_WIDTH-70*SCREEN_WSCALE-zfbImageView.width, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(15) text:@"支付宝"];
    [secordView addSubview:zfbLabel];
    
    index_btn=1;
    
    zfbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //zfbBtn.backgroundColor = [UIColor cyanColor];
    zfbBtn.frame=CGRectMake(zfbImageView.right,zfbImageView.top+5*SCREEN_WSCALE, ScreenWidth-zfbImageView.right, 30*SCREEN_WSCALE);
    [zfbBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
    [zfbBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 85*PMBWIDTH, 0, -85*PMBWIDTH)];
    zfbBtn.tag=1;
    
    [zfbBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [secordView addSubview:zfbBtn];

    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(zfbImageView.left, zfbImageView.bottom+10*PMBWIDTH, secordView.width-20*SCREEN_WSCALE, 1*PMBWIDTH)];
    line3.backgroundColor=[UIColor themeGrayColor];
    [secordView addSubview:line3];
    
    UIImageView *wxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(zfbImageView.left, zfbImageView.bottom+20*PMBWIDTH, zfbImageView.width, zfbImageView.height)];
    [wxImageView setImage:[UIImage imageNamed:@"wx"]];
    [secordView addSubview:wxImageView];
    
    UILabel *wxLabel=[self createLabelFrame:CGRectMake(wxImageView.right +20*PMBWIDTH, wxImageView.top+(wxImageView.height-20*PMBWIDTH)/2, zfbLabel.width, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(15) text:@"微信支付"];
    [secordView addSubview:wxLabel];
    
    wxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.frame=CGRectMake(zfbImageView.right,wxImageView.top+5*SCREEN_WSCALE, ScreenWidth-zfbImageView.right, 30*SCREEN_WSCALE);
    //wxBtn.backgroundColor = [UIColor cyanColor];
    [wxBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    [wxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 85*PMBWIDTH, 0, -85*PMBWIDTH)];
    wxBtn.tag=2;
    [wxBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [secordView addSubview:wxBtn];
    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(line3.left, wxImageView.bottom+5*PMBWIDTH, line3.width, 1*PMBWIDTH)];
    line4.backgroundColor=[UIColor themeGrayColor];
    [secordView addSubview:line4];
    
    
    
    UIImageView *accountImageView=[[UIImageView alloc]initWithFrame:CGRectMake(wxImageView.left, wxImageView.bottom+20*PMBWIDTH, wxImageView.width, wxImageView.height)];
    [accountImageView setImage:[UIImage imageNamed:@"pay_account"]];
    [secordView addSubview:accountImageView];
    
    UILabel *accountLabel=[self createLabelFrame:CGRectMake(accountImageView.right +20*PMBWIDTH, accountImageView.top+(accountImageView.height-20*PMBWIDTH)/2, zfbLabel.width, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(15) text:@"账户余额支付"];
    [secordView addSubview:accountLabel];
    
    accountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //accountBtn.backgroundColor = [UIColor cyanColor];
    accountBtn.frame=CGRectMake(zfbImageView.right,accountImageView.top+5*SCREEN_WSCALE, ScreenWidth-zfbImageView.right, 30*SCREEN_WSCALE);
    [accountBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    [accountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 85*PMBWIDTH, 0, -85*PMBWIDTH)];
    accountBtn.tag=3;
    [accountBtn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
    [secordView addSubview:accountBtn];
    
    
    UIView *bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, accountImageView.bottom+10, secordView.width, secordView.bottom - accountImageView.bottom-11)];
    bgkView.backgroundColor = [UIColor themeGrayColor];
    [secordView addSubview:bgkView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, secordView.width, 60*PMBHEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    [bgkView addSubview:view];
    UILabel *label = [self createLabelFrame:CGRectMake(line3.left, 8*PMBHEIGHT, 60, 21) color:[UIColor blackColor] font:Font(15) text:@"代金券"];
    [view addSubview:label];
    moneyLabel = [self createLabelFrame:CGRectMake(label.right + 70*PMBWIDTH, 8*PMBHEIGHT, view.width - label.right - 110*PMBWIDTH, 21) color:TSEColor(110, 151, 245) font:Font(15) text:@""];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    //moneyLabel.backgroundColor = [UIColor cyanColor];
    [view addSubview:moneyLabel];
    
    label1 = [self createLabelFrame:CGRectMake(line3.left, label.bottom +  15*PMBHEIGHT, ScreenWidth*0.8, 18) color:TSEColor(170, 170, 170) font:Font(13) text:@""];
    [view addSubview:label1];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(moneyLabel.right, moneyLabel.top +8*PMBWIDTH, 20*PMBWIDTH, 20*PMBWIDTH)];
    imageView.image = [UIImage imageNamed:@"new_rightA"];
    [view addSubview:imageView];
    
    butt = [UIButton buttonWithType:UIButtonTypeSystem];
    butt.frame = CGRectMake(0, 0, secordView.width - 20*PMBWIDTH, 60*PMBHEIGHT);
    [butt addTarget:self action:@selector(buttAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:butt];
    
    payLabel2=[self createLabelFrame:CGRectMake(0, secordView.bottom- 15*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:[NSString stringWithFormat:@"需支付金额:¥%.2f元整",_price]];
    payLabel2.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:payLabel2];
    
    
    UIButton *payBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame=CGRectMake(35*SCREEN_WSCALE, secordView.bottom+25*SCREEN_WSCALE, SCREEN_WIDTH-70*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    payBtn.layer.masksToBounds=YES;
    payBtn.layer.cornerRadius=payBtn.height/2;
    [payBtn setTitle:@"确定" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor themeBlueThreeColor]];
    payBtn.titleLabel.font=Font(16);
    [payBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:payBtn];
    
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 560*PMBWIDTH);
    
}

- (void)GetMyVoucher{
    [HttpCenterAction GetMyVoucher:UserDefaultEntity.uuid type:@"1" page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            label1.text = @"无可用代金券";
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"true"]){
            label1.text = @"请选择您的代金券";
        }
    }];
}

- (void)buttAction {
    // 选取代金券
    DeductionVC2 *vc = [[DeductionVC2 alloc] init];
    vc.index = index;
    [vc setCouponBlock:^(NSDictionary *dic, NSIndexPath *index1) {
        index = index1;
        if (dic) {
            vouherDic = [NSDictionary dictionaryWithDictionary:dic];
            NSString *money = [dic objectForKey:@"T_Voucher_Price"];
            moneyLabel.text = [NSString stringWithFormat:@"%ld元代金券", [(NSNumber*)money integerValue]];
            _price = [(NSNumber *)self.orderDic[@"t_Order_Money"] floatValue] - [(NSNumber *)money integerValue];
            if (_price < 0) {
                _price = 0;
            }
            payLabel2.text = [NSString stringWithFormat:@"需支付金额:¥%.2f元整",_price];
        } else {
            moneyLabel.text = @"";
            _price = [(NSNumber *)self.orderDic[@"t_Order_Money"] floatValue];
            payLabel2.text = [NSString stringWithFormat:@"需支付金额:¥%.2f元整",_price];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)selectPayWay:(UIButton*)sender{
    
    UIButton *button=(UIButton*)sender;
    NSInteger index=[button tag];
    if (index==1) {
        index_btn=1;
        [zfbBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [accountBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    }else if(index==2){
        index_btn=2;
        [zfbBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
        [accountBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
    }else if(index==3){
        index_btn=3;
        [zfbBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];

        [accountBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateNormal];
    }
}

-(void)payOrder:(UIButton*)sender{
    if (_price == 0) {
        // 金额为零的时候
        [HttpAlipayAction EditVouher:[_orderDic objectForKey:@"Guid"] voucherGuid:[vouherDic objectForKey:@"T_Voucher_Guid"]  uservoucherGuid:[vouherDic objectForKey:@"Guid"]  Token:[MyAes aesSecretWith:@"orderGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
              // 修改订单状态
                [HttpAlipayAction EditOrderState:[_orderDic objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"orderGuid"] complete:^(id result, NSError *error) {
                    if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                        // 订单修改成功
                        [self payOrderMenoy:@"0"];
                    }
                        else if([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                    }
                }];
            } else if([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }

        }];
        
        return;
    }
    if (index_btn==1) {
        
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付宝未安装,是否下载最新版支付宝?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alert.tag = 8888;
            [alert show];
        }else{
            [self AlipayAction];
        }
    } else if(index_btn==2){
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信未安装,是否下载最新版微信?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            alert.tag = 8889;
            [alert show];
            return;
        }else{
            [self WXPayAction];
        }

    }else if(index_btn==3){
        [self linePayAction];
    }
}

-(void)AlipayAction{
    
    [HttpLoginAction GetPayKey:@"ALiPay" Token:[MyAes aesSecretWith:@"type"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
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
            order.tradeNO = _orderNum;//订单ID
            order.productName = _titlestr;
            order.productDescription = _titlestr;
            order.amount = [NSString stringWithFormat:@"%.2f",_price];
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
                        [self payOrderMenoy:_orderNum];
                    }
                }];
            }
        }
    }];
}

- (void)EditOrderNO:(NSString *)orderNO{
    [HttpUserBankAction EditOrderNO:orderNO Token:[MyAes aesSecretWith:@"orderNO"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _orderNum = [dict objectForKey:@"result"];
            [self WXPayAction];
        }
    }];
}


-(void)WXPayAction{
    
    [HttpLoginAction GetPayKey:@"wxPay" Token:[MyAes aesSecretWith:@"type"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _model=[[OrderModel alloc]init];
            _model.orderName = _titlestr;
            _model.orderPrice = [NSString stringWithFormat:@"%.f",_price*100];
            _model.orderNum = _orderNum;
            
            payRequsestHandler *rep = [payRequsestHandler alloc];
            [rep init:[dict objectForKey:@"APP_ID"] mch_id:[dict objectForKey:@"MCH_ID"]];
            [rep setKey:[dict objectForKey:@"PARTNER_ID"]];
            NSMutableDictionary *dict = [rep sendPay_demo:_model];
            if (dict == nil) {
                [self EditOrderNO:_orderNum];
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
            
        }
    }];
}

-(void)linePayAction{

    [HttpAlipayAction GetAccount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            float account=[(NSNumber*)[dict objectForKey:@"result"] floatValue];
            
            if (account < _price) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"余额不足，是否选择去充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alert.tag = 8890;
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要使用余额支付吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 8891;
                [alert show];
            }
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)addOrder{
    
    NSString *remark=@"";
    if (_type==1) {
        remark= @"众筹课程";
    }else if (_type==2){
        remark = @"课程";
    }else if (_type==3){
        remark = @"空间预约";
    }else{
        remark = @"活动支付";
    }

    [HttpAlipayAction AddAccount:_orderNum userGuid:UserDefaultEntity.uuid addReward:[MyAes aesSecretWith:@"0"] reduceReward:[MyAes aesSecretWith:[NSString stringWithFormat:@"%.2f",_price]] remark:[MyAes aesSecretWith:remark] Token:[MyAes aesSecretWith:@"accountNo"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            
            [self payOrderMenoy:_orderNum];
           
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
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
        }else if(alertView.tag==8890){
        
            AccountPayVC *accountPay=[[AccountPayVC alloc]init];
            [self.navigationController pushViewController:accountPay animated:YES];
        }else if (alertView.tag == 8891){
            [self addOrder];
        }
    }
}

-(void)wxpay:(NSNotification *)text{
    [self payOrderMenoy:_orderNum];
    
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpay" object:nil];
}

-(void)payOrderMenoy:(NSString *)orderNumber{
    if (![self isBlankString:moneyLabel.text]) {
        [HttpAlipayAction EditVouher:[_orderDic objectForKey:@"Guid"] voucherGuid:[vouherDic objectForKey:@"T_Voucher_Guid"]  uservoucherGuid:[vouherDic objectForKey:@"Guid"]  Token:[MyAes aesSecretWith:@"orderGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
        } else if([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            //[SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
        
    }];
    }
    if (_type==1) {

        [self.navigationController popViewControllerAnimated:YES];
    }else if (_type==2){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (_type==3){

        if (self.dealBlock) {
            self.dealBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"支付成功",@"textOne", nil];
        /*
         *  创建通知
         *  通过通知中心发送通知
         */
        
        NSNotification *notifiction = [NSNotification notificationWithName:@"activitysuccess" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notifiction];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
