//
//  MyAppointCell.h
//  qch
//
//  Created by 苏宾 on 16/3/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAppointCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *rImageView;
@property (nonatomic,weak) IBOutlet UIImageView *sImageView;
@property (nonatomic,weak) IBOutlet UILabel *roomNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;
@property (nonatomic,weak) IBOutlet UILabel *addressLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;

-(void)updateFrame:(NSDictionary*)dict;


@end
