//
//  DynamicTWCell.m
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DynamicTWCell5.h"

@implementation DynamicTWCell5{
    UIButton *relayBtn;
    NSString *Userguid;
    DynamicModel *Model;
}

- (void)awakeFromNib {
    CGRect bounds = _bgkView.bounds;
    bounds.size.width = ScreenWidth - 25;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    _bgkView.layer.mask = maskLayer;
    
    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius=_headImageView.height/2;
    _professionLabel.layer.cornerRadius = _professionLabel.height/2;
    _professionLabel.layer.masksToBounds = YES;
    _professionLabel.layer.borderWidth = 0.6;
    _professionLabel.layer.borderColor = [UIColor colorWithRed:188 green:234 blue:255 alpha:1].CGColor;
    [_headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapheadImage:)]];
    _headImageView.userInteractionEnabled = YES;
    
}

- (void)tapheadImage:(UITapGestureRecognizer *)tap{
    if ([self.dyDelegate respondsToSelector:@selector(tapImg5:tap:)]) {
        [self.dyDelegate tapImg5:self tap:tap];
    }
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
        _skillLabel.text = [NSString stringWithFormat:@"•Ta擅长: %@",Beststring];
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
        _skillLabel.text = [NSString stringWithFormat:@"•Ta需要: %@",nowneedname];
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
    CGFloat item=(SCREEN_WIDTH-50)/3;

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
    NSString *text = [NSString stringWithFormat:@"%@",model.t_Topic_Contents];
    if (count==0) {
        [self setIntroductionText:text index:0];
    }else{
        [self setIntroductionText:text index:(item+2)*index];
    }
    
    [self.contentLabel setText:text];
    
    _MoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _MoreBtn.frame = CGRectMake(self.contentLabel.left-2*PMBWIDTH, self.contentLabel.bottom+3*PMBWIDTH, 28*PMBWIDTH, 14*PMBWIDTH);
    [_MoreBtn setTitle:@"全文" forState:UIControlStateNormal];
    _MoreBtn.titleLabel.font = Font(14);
    [_MoreBtn setTitleColor:[UIColor themeBlueColor] forState:UIControlStateNormal];
    _MoreBtn.hidden = YES;
    _MoreBtn.tag = self.tag;
    [self addSubview:_MoreBtn];
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake((self.contentLabel.frame.size.width)*SCREEN_WSCALE, MAXFLOAT)];
    CGFloat height = 0;
    if (self.contentLabel.height>98*PMBWIDTH) {
        height=_bgkView.bottom+size.height+10+14*PMBWIDTH;
    }else{
        height=_bgkView.bottom+size.height+10;
    }
    
    _imageViews = [NSMutableArray array];
    for (int i=0; i<[array count]; i++) {
        
       UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(_headImageView.left+(item+2)*(i % 3), height+(2+item)*(i/3), item, item)];
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
        locationimg.frame=CGRectMake(_headImageView.left, height, 8*PMBWIDTH, 10*SCREEN_WSCALE);
        [locationimg setImage:[UIImage imageNamed:@"dongtai_dd1_btn"]];
        [self addSubview:locationimg];
        
        UILabel*locationlab = [[UILabel alloc]initWithFrame:CGRectMake(locationimg.right+5*PMBWIDTH, locationimg.top, 200*PMBWIDTH, locationimg.height)];
        locationlab.textColor = [UIColor lightGrayColor];
        locationlab.font = Font(10);
        locationlab.text = model.t_Topic_Address;
        [self addSubview:locationlab];

        height=height+20*SCREEN_WSCALE;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_contentLabel.left,height,_contentLabel.width*SCREEN_WSCALE,25*SCREEN_WSCALE)];
    view.layer.cornerRadius = view.height/2;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 0.5*PMBWIDTH;
    view.layer.borderColor = TSEColor(228, 228, 228).CGColor;
    [self addSubview:view];
    
    relayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relayBtn.frame = CGRectMake(self.headImageView.left+10*PMBWIDTH,height,70*PMBWIDTH,25*SCREEN_WSCALE);
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
    
    UILabel*timelab = [[UILabel alloc]initWithFrame:CGRectMake(_headImageView.left, relayBtn.bottom+8*PMBHEIGHT, ScreenWidth/2-50*PMBWIDTH, 15*PMBHEIGHT)];
    timelab.textColor = [UIColor lightGrayColor];
    timelab.text = model.t_Date;
    timelab.adjustsFontSizeToFitWidth = YES;
    timelab.font = Font(14);
    [self addSubview:timelab];
    
//    _collectBtn.frame = _chatbtn.frame;
    
    _DeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _DeleteBtn.frame = CGRectMake(timelab.right+1*PMBHEIGHT, timelab.top+1*PMBHEIGHT, 28*PMBWIDTH, 14*PMBHEIGHT);
    [_DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_DeleteBtn setTitleColor:TSEColor(213, 226, 253) forState:UIControlStateNormal];
    _DeleteBtn.titleLabel.font = Font(14);
    [_DeleteBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    _DeleteBtn.tag = self.tag;
    _DeleteBtn.hidden = YES;
    [self addSubview:_DeleteBtn];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(_headImageView.left, timelab.bottom+10*PMBHEIGHT, 13*PMBWIDTH, 13*PMBHEIGHT)];
    [img setImage:[UIImage imageNamed:@"dongtai_xhrs_btn"]];
    [self addSubview:img];
    
    
    NSArray *namearray = model.PraiseUsers;
    NSInteger nameCount=0;
    if ([namearray count]>3) {
        nameCount=3;
    }else{
        nameCount=[namearray count];
    }
    NSString *namestring = nil;
    for (int i =0; i<nameCount; i++) {
        
        NSDictionary *namedict = [namearray objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"%@",[namedict objectForKey:@"PraiseUserRealName"]];
        // 去除首位空格和换行
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (name.length > 6) {
            name = [name substringToIndex:6];
        }

        if ([self isBlankString:[namedict objectForKey:@"PraiseUserRealName"]]) {
            name = @"匿名";
        }
        if (namestring == nil) {
            namestring = name;
        } else {
            namestring = [namestring stringByAppendingString:[NSString stringWithFormat:@"、%@",name]];
        }
    }
    UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(img.right+5*PMBWIDTH, img.top, ScreenWidth-img.right-30*PMBWIDTH, 12*PMBHEIGHT)];
    namelab.textColor = [UIColor lightGrayColor];
    namelab.font = Font(12);
    namelab.text = [NSString stringWithFormat:@"%@ %lu人觉得很赞",namestring,(unsigned long)namearray.count];
    if (namearray.count == 0) {
        img.hidden = YES;
        namelab.hidden = YES;
    }else if (namearray.count == 1){
        namelab.text = namestring;
    }else if (namearray.count>3){
        namelab.text = [NSString stringWithFormat:@"%@ 等%lu人觉得很赞",namestring,(unsigned long)namearray.count];
    }
    namelab.numberOfLines = 2;
    CGSize size1 = [namelab sizeThatFits:CGSizeMake(namelab.frame.size.width, MAXFLOAT)];
    namelab.frame = CGRectMake(namelab.frame.origin.x, namelab.frame.origin.y, namelab.frame.size.width, size1.height);
    [self addSubview:namelab];
    
    if ([model.ifPraise isEqualToString:@"1"]) {
        [_collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [_collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];

    }
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(25, self.bottom - 6, ScreenWidth-25, 1)];
    linelab.backgroundColor = TSEColor(213, 226, 253);
    [self addSubview:linelab];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, linelab.bottom-6, 10, 10)];
    image.backgroundColor = TSEColor(213, 226, 253);
    image.layer.cornerRadius = image.height/2;
    image.layer.masksToBounds = YES;
    [self addSubview:image];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 1, self.height)];
    line.backgroundColor = TSEColor(213, 226, 253);
    [self addSubview:line];

}

- (void)tapImage:(UITapGestureRecognizer *)tap{
    if ([self.dyDelegate respondsToSelector:@selector(tapImageWithObject5:tap:)]) {
        [self.dyDelegate tapImageWithObject5:self tap:tap];
    }
}

- (void)careClicked:(UIButton*)sender{
    
    if ([self.dyDelegate respondsToSelector:@selector(careClicked5:index:)]) {
        [self.dyDelegate careClicked5:self index:[sender tag]];
    }
}
- (void)share:(UIButton *)sender
{
    if ([self.dyDelegate respondsToSelector:@selector(shareClicked5:index:)]) {
        [self.dyDelegate shareClicked5:self index:[sender tag]];
    }
}
- (void)TalkClicked:(UIButton *)sender
{
    if ([self.dyDelegate respondsToSelector:@selector(talkClicked5:index:)]) {
        [self.dyDelegate talkClicked5:self index:[sender tag]];
    }
}
- (void)remove:(UIButton *)sender
{
    if ([self.dyDelegate respondsToSelector:@selector(deleteClicked5:index:)]) {
        [self.dyDelegate deleteClicked5:self index:[sender tag]];
    }
}
//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text index:(NSInteger)index{
    //获得当前cell高度
    CGRect frame = [self frame];
    self.contentLabel.text = text;
    //文本赋值
    self.contentLabel.numberOfLines = 7;
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake((self.contentLabel.frame.size.width)*SCREEN_WSCALE, MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    
    CGFloat hegiht=10;
    
    if (![self isBlankString:Model.t_Topic_Address]) {
        //计算出自适应的高度
        if ([Model.PraiseCount isEqualToString:@"0"]) {
            hegiht+=20+50*SCREEN_WSCALE;
        }else{
            hegiht+=20+76*SCREEN_WSCALE;
        }

    }else{
        //计算出自适应的高度
        if ([Model.PraiseCount isEqualToString:@"0"]) {
            hegiht+= 50*SCREEN_WSCALE;
        }else{
            hegiht+= 76*SCREEN_WSCALE;
        }
    }
    if (self.contentLabel.height>98*PMBWIDTH) {
        hegiht+=15*PMBWIDTH;
    }
    
    frame.size.height=size.height+_bgkView.bottom+index+hegiht+25;
    
    self.frame = frame;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    if ([Userguid isEqualToString: UserDefaultEntity.uuid]) {
        _DeleteBtn.hidden = NO;
    }
    
    if (self.contentLabel.height>98*PMBWIDTH) {
        _MoreBtn.hidden = NO;
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
