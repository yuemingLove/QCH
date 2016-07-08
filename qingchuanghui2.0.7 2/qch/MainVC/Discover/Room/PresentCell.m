//
//  PresentCell.m
//  
//
//  Created by 青创汇 on 16/2/27.
//
//

#import "PresentCell.h"

@implementation PresentCell

- (void)awakeFromNib {
    // Initialization code
    
    _RoomRmark.textColor=[UIColor themeBlueThreeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //文本赋值
    self.RoomRmark.text = text;
    self.RoomRmark.numberOfLines =0;
    self.RoomRmark.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.RoomRmark sizeThatFits:CGSizeMake(self.RoomRmark.frame.size.width, MAXFLOAT)];
    
    self.RoomRmark.frame = CGRectMake(self.RoomRmark.frame.origin.x, self.RoomRmark.frame.origin.y, self.RoomRmark.frame.size.width, size.height);
    
    //计算出自适应的高度
    frame.size.height = size.height+64*PMBWIDTH;

    self.frame = frame;
}


@end
