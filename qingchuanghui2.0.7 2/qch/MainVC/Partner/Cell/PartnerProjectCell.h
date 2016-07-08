//
//  PartnerProjectCell.h
//  qch
//
//  Created by 青创汇 on 16/3/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerProjectCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,strong)PartnerResult *model;
@property (nonatomic,strong)UIButton *MoreBtn;

@end
