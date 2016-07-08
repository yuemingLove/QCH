//
//  AmbitusCell.m
//  qch
//
//  Created by 青创汇 on 16/1/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AmbitusCell.h"

@implementation AmbitusCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.CityLab = [[UILabel alloc]initWithFrame:CGRectMake(15*PMBWIDTH, 5*PMBWIDTH, ScreenWidth-5*PMBWIDTH, 15*PMBWIDTH)];
    self.CityLab.textColor = [UIColor blackColor];
    self.CityLab.font = Font(15);
    [self addSubview:self.CityLab];
    
    self.AddressLab = [[UILabel alloc]initWithFrame:CGRectMake(self.CityLab.left, self.CityLab.bottom+2*PMBWIDTH, self.CityLab.width, 14*PMBWIDTH)];
    self.AddressLab.textColor = [UIColor lightGrayColor];
    self.AddressLab.font = Font(14);
    [self addSubview:self.AddressLab];
}
@end
