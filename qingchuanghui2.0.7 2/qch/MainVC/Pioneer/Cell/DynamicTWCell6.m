//
//  DynamicTWCell.m
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DynamicTWCell6.h"

@implementation DynamicTWCell6{
    UIButton *relayBtn;
    UIButton *DeleteBtn;
    NSString *Userguid;
    DynamicModel *Model;
}

- (void)awakeFromNib {
    
//    CGRect bounds = _bgkView.bounds;
//    bounds.size.width = ScreenWidth - 20;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = bounds;
//    maskLayer.path = maskPath.CGPath;
//    _bgkView.layer.mask = maskLayer;
    _bgkView.layer.cornerRadius = 15;
    _bgkView.layer.borderWidth = 1;
    _bgkView.layer.borderColor = TSEColor(228, 234, 250).CGColor;

    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius=_headImageView.height/2;
    _professionLabel.layer.cornerRadius = _professionLabel.height/2;
    _professionLabel.layer.masksToBounds = YES;
    _professionLabel.layer.borderWidth = 0.6;
    _professionLabel.layer.borderColor = [UIColor colorWithRed:188 green:234 blue:255 alpha:1].CGColor;

    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius=_headImageView.height/2;
    [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapheadImage:)]];
    _headImageView.userInteractionEnabled = YES;
    self.contentLabel = [[HTCopyableLabel alloc] initWithFrame:CGRectMake(_bgkView.left, _bgkView.bottom + 10, ScreenWidth - 35, 15)];
    self.contentLabel.font = Font(14);
    [self.contentView addSubview:_contentLabel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateData:(DynamicModel*)model{
    
    NSString *Beststring = @"";
    if ([model.Best count]>0) {
        NSArray *array1 = model.Best;
        for (int i = 0; i<[array1 count]; i++) {
            NSDictionary *dict = array1[i];
            NSString *beststring = [dict objectForKey:@"BestName"];
            if ([Beststring isEqualToString:@""]) {
                Beststring = beststring;
            } else {
                Beststring = [Beststring stringByAppendingString:[NSString stringWithFormat:@" / %@",beststring]];
            }
        }
        _skillLabel.text = [NSString stringWithFormat:@"•Ta擅长: %@", Beststring];
    }
    NSString *nowneedname=@"";
    if ([model.NowNeed count]>0) {
        NSArray *array2 = model.NowNeed;
        for (int i = 0; i<[array2 count]; i++) {
            NSDictionary *dict =array2[i];
            NSString *need = [dict objectForKey:@"NowNeedName"];
            if ([nowneedname isEqualToString:@""]) {
                nowneedname = need;
            } else {
                nowneedname = [nowneedname stringByAppendingString:[NSString stringWithFormat:@" / %@",need]];
            }
        }
        _skillLabel.text = [NSString stringWithFormat:@"•Ta需要: %@", nowneedname];
    }
    
    NSString *IntentionName = @"";
    if ([model.Intention count]>0) {
        NSArray *Array = model.Intention;
        for (int i = 0; i <[Array count]; i++) {
            NSDictionary *dict = Array[i];
            NSString *intention = [dict objectForKey:@"IntentionName"];
            if ([self isBlankString:IntentionName]) {
                IntentionName = intention;
            } else {
                IntentionName = [IntentionName stringByAppendingString:[NSString stringWithFormat:@" %@",intention]];
            }
        }
        _tabLabel.text =IntentionName;
    }else{
        _tabLabel.hidden = YES;
        _tapimg.hidden = YES;
    }

    
    Model=model;
    self.nameLabel.text =model.t_User_RealName;
    Userguid = model.t_User_Guid;
    
    NSString *position;
    if (![self isBlankString:model.PositionName]) {
        position=model.PositionName;
        
        if (![self isBlankString:model.t_User_Commpany]) {
            position=[position stringByAppendingFormat:@"   %@",model.t_User_Commpany];
        }
    }else{
        if (![self isBlankString:model.t_User_Commpany]) {
            position=model.t_User_Commpany;
        }
    }
    
    self.positionLabel.text=position;
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.t_User_Pic];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    NSArray *array=model.Pic;
    CGFloat item=(SCREEN_WIDTH-40)/3;
    
    NSInteger count=[array count];
    NSInteger index=0;
    if (count>6) {
        index=3;
    }
    if (count>3 && count<=6) {
        index=2;
    }
    if (count>0 && count<=3) {
        index=1;
    }
    if (count==0) {
        index=0;
    }
    
    if (count==0) {
        [self setIntroductionText:model.t_Topic_Contents index:0];
    }else{
        [self setIntroductionText:model.t_Topic_Contents index:(item+2)*index];
    }
    
    [self.contentLabel setText:model.t_Topic_Contents];
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake((self.contentLabel.frame.size.width), MAXFLOAT)];
    CGFloat height = 0;
    if (![self isBlankString:model.t_Topic_Contents]) {
        height=_bgkView.bottom+size.height+20;
    } else {
        height=_bgkView.bottom+size.height+10;
    }
    
    _imageViews = [NSMutableArray array];
    for (int i=0; i<[array count]; i++) {
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20+(item+2)*(i % 3), height+(2+item)*(i/3), item, item)];
        NSDictionary *pic=array[i];
        image.tag =i;
        
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[pic objectForKey:@"t_Pic_Url"]];
        [image sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        [self addSubview:image];
        
        [image setContentScaleFactor:[[UIScreen mainScreen] scale]];
        image.contentMode =  UIViewContentModeScaleAspectFill;
        image.clipsToBounds  = YES;
        
        
        [_imageViews addObject:image];
    }
    
    height=index*(item+2)+height+10;
    if (![self isBlankString:model.t_Topic_Address]) {
        UIImageView *locationimg = [[UIImageView alloc]init];
        locationimg.frame=CGRectMake(20, height, 10*PMBWIDTH, 10*SCREEN_WSCALE);
        [locationimg setImage:[UIImage imageNamed:@"dongtai_dd1_btn"]];
        [self addSubview:locationimg];
        
        
        UILabel*locationlab = [[UILabel alloc]initWithFrame:CGRectMake(locationimg.right+5*PMBWIDTH, locationimg.top, 200*PMBWIDTH, locationimg.height)];
        locationlab.textColor = [UIColor lightGrayColor];
        locationlab.font = Font(10);
        locationlab.text = model.t_Topic_Address;
        [self addSubview:locationlab];
        
        height=height+20*SCREEN_WSCALE;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.left,height,_contentLabel.width,25*SCREEN_WSCALE)];
    view.layer.cornerRadius = view.height/2;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 0.5*PMBWIDTH;
    view.layer.borderColor = TSEColor(228, 228, 228).CGColor;
    [self addSubview:view];
    
    relayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relayBtn.frame = CGRectMake(self.headImageView.left+25*PMBWIDTH,height,70*PMBWIDTH,25*SCREEN_WSCALE);
    //relayBtn.backgroundColor = [UIColor redColor];
    relayBtn.titleLabel.font = Font(12);
    [relayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [relayBtn setTitle:@"分享" forState:UIControlStateNormal];
    [relayBtn setImage:[UIImage imageNamed:@"new_share"] forState:UIControlStateNormal];
    [relayBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    relayBtn.tag = self.tag;
    [self addSubview:relayBtn];
    
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(relayBtn.right+25*PMBWIDTH, relayBtn.top, relayBtn.width, relayBtn.height);
    //_collectBtn.backgroundColor = [UIColor redColor];
    _collectBtn.titleLabel.font = Font(12);
    [_collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_collectBtn setTitle:@"赞" forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
    _collectBtn.tag=self.tag;
    [_collectBtn addTarget:self action:@selector(careClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectBtn];
    
    
    _chatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chatbtn.frame = CGRectMake(_collectBtn.right+25*PMBWIDTH, _collectBtn.top, _collectBtn.width, _collectBtn.height);
    //_chatbtn.backgroundColor = [UIColor cyanColor];
    _chatbtn.titleLabel.font = Font(12);
    [_chatbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_chatbtn setImage:[UIImage imageNamed:@"new_comment_nor"] forState:UIControlStateNormal];
    if (![model.talkcount isEqualToString:@"0"]) {
        [_chatbtn setTitle:model.talkcount forState:UIControlStateNormal];
    }
    [_chatbtn addTarget:self action:@selector(TalkClicked:) forControlEvents:UIControlEventTouchUpInside];
    _chatbtn.tag = self.tag;
    [self addSubview:_chatbtn];
    
    UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(relayBtn.right+12*PMBWIDTH, relayBtn.top + 5*PMBHEIGHT, 0.5*PMBWIDTH, relayBtn.height - 10*PMBHEIGHT)];
    lin.backgroundColor = TSEColor(228, 228, 228);
    [self addSubview:lin];
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(_collectBtn.right+20*PMBWIDTH, relayBtn.top + 5*PMBHEIGHT, 0.5*PMBWIDTH, relayBtn.height - 10*PMBHEIGHT)];
    lin1.backgroundColor = TSEColor(228, 228, 228);
    [self addSubview:lin1];
    
    UILabel*timelab = [[UILabel alloc]initWithFrame:CGRectMake(self.contentLabel.left, relayBtn.bottom+10*PMBHEIGHT, ScreenWidth/2-50*PMBWIDTH, 15*PMBHEIGHT)];
    timelab.textColor = [UIColor lightGrayColor];
    timelab.text = model.t_Date;
    timelab.adjustsFontSizeToFitWidth = YES;
    timelab.font = [UIFont systemFontOfSize:14];
    [self addSubview:timelab];
    
    if ([model.ifPraise isEqualToString:@"1"]) {
        [_collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [_collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    if ([self.dyDelegate respondsToSelector:@selector(tapImageWithObject6:tap:)]) {
        [self.dyDelegate tapImageWithObject6:self tap:tap];
    }
}

- (void)tapheadImage:(UITapGestureRecognizer *)tap{
    if ([self.dyDelegate respondsToSelector:@selector(tapImg6:tap:)]) {
        [self.dyDelegate tapImg6:self tap:tap];
    }
}

- (void)careClicked:(UIButton*)sender{
    
    if ([self.dyDelegate respondsToSelector:@selector(careClicked6:index:)]) {
        [self.dyDelegate careClicked6:self index:[sender tag]];
    }
}

- (void)share:(UIButton *)sender{
    if ([self.dyDelegate respondsToSelector:@selector(shareClicked6:index:)]) {
        [self.dyDelegate shareClicked6:self index:[sender tag]];
    }
}

- (void)TalkClicked:(UIButton *)sender{
    if ([self.dyDelegate respondsToSelector:@selector(talkClicked6:index:)]) {
        [self.dyDelegate talkClicked6:self index:[sender tag]];
    }
}


//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text index:(NSInteger)index{
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值
    self.contentLabel.text = text;
    self.contentLabel.numberOfLines =0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake((self.contentLabel.frame.size.width), MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    
    //计算出自适应的高度
    //    frame.size.height = size.height+52+23+index+65*PMBHEIGHT;
    
    CGFloat hegiht=10;
    
    if (![self isBlankString:Model.t_Topic_Address]) {
        hegiht+=20+50*SCREEN_WSCALE;
        
    }else{
        //计算出自适应的高度
        hegiht+= 50*SCREEN_WSCALE;
    }
    
    frame.size.height=size.height+_bgkView.bottom+index+hegiht+30;
    
    self.frame = frame;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if ([Userguid isEqualToString: UserDefaultEntity.uuid]) {
        DeleteBtn.hidden = NO;
    }
}
- (BOOL) isBlankString:(NSString *)string {
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
