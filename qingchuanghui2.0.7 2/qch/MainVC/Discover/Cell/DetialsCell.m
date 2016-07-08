//
//  DetialsCell.m
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DetialsCell.h"

@implementation DetialsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setIntroductionText:(NSString*)text{
     CGRect frame = [self frame];
    self.Introduction.text = text;
    self.Introduction.numberOfLines =0;
    self.Introduction.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize size = [self.Introduction sizeThatFits:CGSizeMake(self.Introduction.frame.size.width, MAXFLOAT)];
    
    self.Introduction.frame = CGRectMake(self.Introduction.frame.origin.x, self.Introduction.frame.origin.y, self.Introduction.frame.size.width, size.height);
    frame.size.height = size.height+12*SCREEN_WSCALE;
    self.frame = frame;
}

@end
