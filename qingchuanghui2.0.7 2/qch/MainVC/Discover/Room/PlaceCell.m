//
//  PlaceCell.m
//  qch
//
//  Created by 青创汇 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PlaceCell.h"

@implementation PlaceCell


- (void)awakeFromNib {
    // Initialization code
    _PlaceImg.layer.cornerRadius = _PlaceImg.height/2;
    _PlaceImg.layer.masksToBounds = YES;
}


@end
