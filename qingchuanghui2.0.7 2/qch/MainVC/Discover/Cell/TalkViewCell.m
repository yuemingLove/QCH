//
//  TalkViewCell.m
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TalkViewCell.h"

@implementation TalkViewCell

- (void)awakeFromNib {

    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(_timeLabel.right+30*PMBWIDTH, _headImageView.top+4*PMBHEIGHT, 44*PMBWIDTH, 20*PMBHEIGHT);
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:TSEColor(213, 226, 253) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = Font(14);
    [_deleteBtn addTarget:self action:@selector(removeTalk:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [self addSubview:_deleteBtn];
    _toUserName.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _headImageView.layer.masksToBounds=YES;
    _headImageView.layer.cornerRadius=_headImageView.height/2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateData:(DynamicTalkModel*)model{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    if (model.tUserRealName.length>5) {
        _nameLabel.text = [model.tUserRealName substringToIndex:5];
    }else{
        _nameLabel.text=model.tUserRealName;
    }
    _timeLabel.text=model.tTalkFromDate;
    model.tTalkFromContent = [model.tTalkFromContent stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    model.tTalkFromContent = [model.tTalkFromContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self isBlankString:model.toUserRealName]) {
        _toUserName.text=[NSString stringWithFormat:@""];
        self.contentLabel.text = model.tTalkFromContent;
    } else {
        if (model.toUserRealName.length>5) {
            NSString *name = [[NSString stringWithFormat:@"%@",model.toUserRealName] substringToIndex:5];
            _toUserName.text = [NSString stringWithFormat:@"回复%@:",name];
        } else {
        _toUserName.text=[NSString stringWithFormat:@"回复%@:",model.toUserRealName];
        }
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",_toUserName.text, model.tTalkFromContent]];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:12.0]
         
                              range:NSMakeRange(0, _toUserName.text.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:TSEColor(170, 170, 170)
         
                              range:NSMakeRange(0, _toUserName.text.length)];
        
        self.contentLabel.attributedText = AttributedStr;
    }
    if ([model.tTalkFromUserGuid isEqualToString:UserDefaultEntity.uuid]) {
        _deleteBtn.hidden = NO;
    }
    [self setIntroductionText];
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText {
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值

    self.contentLabel.numberOfLines =0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, size.height);
    
    //计算出自适应的高度
    frame.size.height = size.height+40*PMBWIDTH;
    
    _line2=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.left, frame.size.height, SCREEN_WIDTH, 1*SCREEN_WHCALE)];
    [_line2 setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:_line2];

    self.frame = frame;
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

-(void)removeTalk:(UIButton *)sender{

    if ([self.talkdelegate respondsToSelector:@selector(deletetalkClick:index:)]) {
        [self.talkdelegate deletetalkClick:self index:[sender tag]];
    }
}

@end
