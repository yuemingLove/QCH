//
//  LocationCityCell.m
//  qch
//
//  Created by W.兵 on 16/5/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "LocationCityCell.h"
#import "BAddressHeader.h"

@implementation LocationCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.locationLabel.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
    self.locationLabel.layer.borderWidth = 1;
    self.locationLabel.layer.cornerRadius = BUTTON_HEIGHT / 2;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
