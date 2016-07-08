//
//  OrderCell.m
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell (){
    
    UIView *bgkView;
    
    UILabel *orderNumLabel;
    UILabel *statesLabel;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *timeLabel;
    
    UILabel *payWayLabel;
    UILabel *payWay;
    
    UIView *line2;
    UIView *line3;
    UIButton *moreTextBtn;
    UIButton *moreBtn;
    
    UILabel *activityName;
    
    
    UILabel *fristLabel;
    UILabel *fristTxt;
    
    UILabel *secordLabel;
    UILabel *secordTxt;
    
    UILabel *thridLabel;
    UILabel *thridTxt;
    
    UILabel *fourLabel;
    UILabel *fourTxt;
    
    UILabel *fiveLabel;
    UILabel *fiveTxt;
    
    CGFloat lineHeight;
    
}

@end

@implementation OrderCell


+ (CGFloat)cellDefaultHeight:(MyOrder *)myOrder{
    
    //默认cell高度
    return 144.0;
}

+ (CGFloat)cellMoreHeight:(MyOrder *)myOrder{
    
    CGFloat height=0;
    
    if (myOrder.t_Order_OrderType==1) {
        height+=30;
    } else {
        height+=70+20*5;
    }

    return 144.0 + height;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[UIColor themeGrayColor];
        bgkView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, self.height)];
        bgkView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:bgkView];
        
        orderNumLabel=[self createLabelFrame:CGRectMake(10, 10, 200, 18) color:[UIColor colorWithRed:(74.0f / 255.0f) green:(144.0f / 255.0f) blue:(226.0f / 255.0f) alpha:1.0f] font:Font(14) text:@"21321312313"];
        [bgkView addSubview:orderNumLabel];
        
        statesLabel=[self createLabelFrame:CGRectMake(bgkView.width-100, orderNumLabel.top, 90, orderNumLabel.height) color:[UIColor blackColor] font:Font(14) text:@""];
        statesLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:statesLabel];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(5, orderNumLabel.bottom+10, bgkView.width-10, 1)];
        line.backgroundColor=[UIColor themeGrayColor];
        [bgkView addSubview:line];
        
        nameLabel=[self  createLabelFrame:CGRectMake(orderNumLabel.left, line.bottom+10, 100, 20) color:[UIColor blackColor] font:Font(15) text:@"332"];
        [bgkView addSubview:nameLabel];
        
        priceLabel=[self createLabelFrame:CGRectMake(bgkView.width-100, nameLabel.top, 90, nameLabel.height) color:[UIColor colorWithRed:(225.0f / 255.0f) green:(119.0f / 255.0f) blue:(62.0f / 255.0f) alpha:1.0f] font:Font(15) text:@"¥12.00"];
        priceLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:priceLabel];
        
        timeLabel=[self createLabelFrame:CGRectMake(orderNumLabel.left, nameLabel.bottom+10, 200, 16) color:[UIColor lightGrayColor] font:Font(14) text:@"2016-12-12 21:12:12"];
        [bgkView addSubview:timeLabel];
        
        //支付
        payWayLabel=[self createLabelFrame:CGRectMake(timeLabel.left, timeLabel.bottom+10, 60, 20) color:[UIColor blackColor] font:Font(14) text:@"支付方式:"];
        payWayLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:payWayLabel];
        
        payWay=[self createLabelFrame:CGRectMake(payWayLabel.right+10, payWayLabel.top, bgkView.width-110, payWayLabel.height) color:[UIColor blackColor] font:Font(14) text:@"支付宝支付"];
        [bgkView addSubview:payWay];
        
        
        //活动
        activityName=[self createLabelFrame:CGRectMake(payWayLabel.left, timeLabel.bottom+10, bgkView.width-20, 20) color:[UIColor colorWithRed:(74.0f / 255.0f) green:(144.0f / 255.0f) blue:(226.0f / 255.0f) alpha:1.0f] font:Font(15) text:@""];
        [bgkView addSubview:activityName];
        
        fristLabel=[self createLabelFrame:CGRectMake(timeLabel.left, activityName.bottom+10, 60, 18) color:[UIColor lightGrayColor] font:Font(14) text:@"主办方:"];
        fristLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:fristLabel];
        
        fristTxt=[self createLabelFrame:CGRectMake(fristLabel.right+10, fristLabel.top, bgkView.width-90, fristLabel.height) color:[UIColor blackColor] font:Font(14) text:@"青创会"];
        [bgkView addSubview:fristTxt];
        
        secordLabel=[self createLabelFrame:CGRectMake(timeLabel.left, fristLabel.bottom+10, 60, 18) color:[UIColor lightGrayColor] font:Font(14) text:@"活动费用:"];
        secordLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:secordLabel];
        
        secordTxt=[self createLabelFrame:CGRectMake(secordLabel.right+10, secordLabel.top, bgkView.width-90, secordLabel.height) color:[UIColor blackColor] font:Font(14) text:@"青创会"];
        [bgkView addSubview:secordTxt];
        
        thridLabel=[self createLabelFrame:CGRectMake(timeLabel.left, secordLabel.bottom+10, 60, 18) color:[UIColor lightGrayColor] font:Font(14) text:@"咨询电话:"];
        thridLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:thridLabel];
        
        thridTxt=[self createLabelFrame:CGRectMake(thridLabel.right+10, thridLabel.top, bgkView.width-90, thridLabel.height) color:[UIColor blackColor] font:Font(14) text:@"青创会"];
        [bgkView addSubview:thridTxt];
        
        fourLabel=[self createLabelFrame:CGRectMake(timeLabel.left, thridLabel.bottom+10, 60, 18) color:[UIColor lightGrayColor] font:Font(14) text:@"活动时间:"];
        fourLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:fourLabel];
        
        fourTxt=[self createLabelFrame:CGRectMake(fourLabel.right+10, fourLabel.top, bgkView.width-90, fourLabel.height) color:[UIColor blackColor] font:Font(14) text:@"青创会"];
        [bgkView addSubview:fourTxt];
        
        fiveLabel=[self createLabelFrame:CGRectMake(timeLabel.left, fourLabel.bottom+10, 60, 18) color:[UIColor lightGrayColor] font:Font(14) text:@"活动地点:"];
        fiveLabel.textAlignment=NSTextAlignmentRight;
        [bgkView addSubview:fiveLabel];
        
        fiveTxt=[self createLabelFrame:CGRectMake(fiveLabel.right+10, fiveLabel.top, bgkView.width-90, fiveLabel.height) color:[UIColor blackColor] font:Font(14) text:@"青创会"];
        [bgkView addSubview:fiveTxt];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    orderNumLabel.text=self.myOrder.t_Order_No;
    
    if (self.myOrder.t_Order_State==0) {
        statesLabel.text=@"未支付";
    } else {
        statesLabel.text=@"已支付";
    }
    
    if (self.myOrder.t_Order_OrderType ==1) {
        nameLabel.text=@"充值";
    } else if (self.myOrder.t_Order_OrderType ==2){
        nameLabel.text=@"活动";
    }
    
    priceLabel.text = [NSString stringWithFormat:@"¥%@",self.myOrder.t_Order_Money];
    timeLabel.text=self.myOrder.t_Order_Date;
    payWay.text=self.myOrder.t_Order_PayType;
    
    activityName.text=self.myOrder.t_Activity_Title;
    fristTxt.text=self.myOrder.t_Activity_Holder;
    secordTxt.text=[NSString stringWithFormat:@"¥%@",self.myOrder.t_Order_Money];
    thridTxt.text=self.myOrder.t_Activity_Tel;
    
    NSString *beginTime=self.myOrder.t_Activity_sDate;
    NSString *endTime=self.myOrder.t_Activity_eDate;
    if (![self isBlankString:beginTime]) {
        beginTime=[beginTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        beginTime=[beginTime substringFromIndex:5];
        beginTime=[beginTime substringToIndex:11];
    }
    if (![self isBlankString:endTime]) {
        endTime=[endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        endTime=[endTime substringFromIndex:5];
        endTime=[endTime substringToIndex:11];
    }
    
    fourTxt.text=[NSString stringWithFormat:@"%@--%@",beginTime,endTime];
    fiveTxt.text=self.myOrder.t_Activity_Street;
    if (self.myOrder.isShowMoreText){
        
        ///计算文本高度
        if (self.myOrder.t_Order_OrderType==1) {
            
            payWayLabel.hidden=NO;
            payWay.hidden=NO;
            activityName.hidden=YES;
            
            fristLabel.hidden=YES;
            fristTxt.hidden=YES;
            secordLabel.hidden=YES;
            secordTxt.hidden=YES;
            thridLabel.hidden=YES;
            thridTxt.hidden=YES;
            fourLabel.hidden=YES;
            fourTxt.hidden=YES;
            fiveLabel.hidden=YES;
            fiveTxt.hidden=YES;
            
            lineHeight=payWay.height+10;
        } else if(self.myOrder.t_Order_OrderType==2){
            
            payWayLabel.hidden=YES;
            payWay.hidden=YES;
            activityName.hidden=NO;
            
            fristLabel.hidden=NO;
            fristTxt.hidden=NO;
            secordLabel.hidden=NO;
            secordTxt.hidden=NO;
            thridLabel.hidden=NO;
            thridTxt.hidden=NO;
            fourLabel.hidden=NO;
            fourTxt.hidden=NO;
            fiveLabel.hidden=NO;
            fiveTxt.hidden=NO;
            
            lineHeight=70+20*5;
        }
    }else{
        
        payWayLabel.hidden=YES;
        payWay.hidden=YES;
        activityName.hidden=YES;
        fristLabel.hidden=YES;
        fristTxt.hidden=YES;
        secordLabel.hidden=YES;
        secordTxt.hidden=YES;
        thridLabel.hidden=YES;
        thridTxt.hidden=YES;
        fourLabel.hidden=YES;
        fourTxt.hidden=YES;
        fiveLabel.hidden=YES;
        fiveTxt.hidden=YES;
        
        lineHeight=0;
    }
    
    [bgkView setFrame:CGRectMake(bgkView.left, 0, SCREEN_WIDTH - 20, 144.0+lineHeight)];
    
    
    line3=[[UIView alloc]initWithFrame:CGRectMake(5, timeLabel.bottom+10+lineHeight, bgkView.width-10, 1)];
    line3.backgroundColor=[UIColor themeGrayColor];
    [bgkView addSubview:line3];
    
    moreTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreTextBtn.frame=CGRectMake((bgkView.width-40)/2, line3.bottom+10, 40, 20);
    
    if (self.myOrder.isShowMoreText){
        [moreTextBtn setImage:[UIImage imageNamed:@"pay_up"] forState:UIControlStateNormal];
    }else{
        [moreTextBtn setImage:[UIImage imageNamed:@"pay_down"] forState:UIControlStateNormal];
    }
    moreTextBtn.tag=self.tag;
    [moreTextBtn addTarget:self action:@selector(showMoreText:) forControlEvents:UIControlEventTouchUpInside];
    [bgkView addSubview:moreTextBtn];
}

- (void)showMoreText:(UIButton*)sender{
    //将当前对象的isShowMoreText属性设为相反值
    self.myOrder.isShowMoreText = !self.myOrder.isShowMoreText;
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self);
    }
}

-(UILabel *)createLabelFrame:(CGRect)frame color:(UIColor*)color font:(UIFont *)font text:(NSString *)text{
    
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.font=font;
    label.textColor=color;
    label.textAlignment=NSTextAlignmentLeft;
    label.text=text;
    
    return label;
}


- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
