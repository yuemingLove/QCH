//
//  RoomListCell.h
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *rImageView;

@property (nonatomic,weak) IBOutlet UILabel *themeLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *serviceLabel;
@property (nonatomic,weak) IBOutlet UILabel *distrustLabel;

-(void)updateFrame:(NSDictionary*)dict;

@end
