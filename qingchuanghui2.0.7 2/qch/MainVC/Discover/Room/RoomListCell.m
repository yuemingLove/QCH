//
//  RoomListCell.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RoomListCell.h"

@implementation RoomListCell

- (void)awakeFromNib {
    // Initialization code
    _contentLabel.textColor=[UIColor themeBlueThreeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateFrame:(NSDictionary*)dict{
    
    NSMutableArray *array=(NSMutableArray*)[dict objectForKey:@"Pic"];
    if ([array count]==0) {
        _rImageView.image = [UIImage imageNamed:@"loading_2"];
    }else{
        NSDictionary *dict2=[array objectAtIndex:0];
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict2 objectForKey:@"t_Pic_Url"]];
        [_rImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    }
    _themeLabel.text=[dict objectForKey:@"t_Place_Name"];
    _contentLabel.text=[dict objectForKey:@"t_Place_OneWord"];
    
    NSMutableArray *tipArray=(NSMutableArray*)[dict objectForKey:@"Tips"];
    NSMutableArray *ProvideArray=(NSMutableArray*)[dict objectForKey:@"ProvideService"];
    NSString *tip=nil;
    for (NSDictionary *tipDict in tipArray) {
        if ([self isBlankString:tip]) {
            tip=[tipDict objectForKey:@"TipName"];
        }else{
            tip=[tip stringByAppendingFormat:@"/%@",[tipDict objectForKey:@"TipName"]];
        }
    }
    NSString *provide=nil;
    for (NSDictionary *provideDict in ProvideArray) {
        if ([self isBlankString:provide]) {
            provide=[provideDict objectForKey:@"ServiceName"];
        }else{
            provide=[provide stringByAppendingFormat:@"/%@",[provideDict objectForKey:@"ServiceName"]];
        }
    }
    
    _statusLabel.text=tip;
    _serviceLabel.text=provide;
    _distrustLabel.text=[dict objectForKey:@"Distance"];
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
