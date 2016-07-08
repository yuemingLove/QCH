//
//  BaseInformationCell.h
//  qch
//
//  Created by 青创汇 on 16/2/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInformationCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,strong)PartnerResult *model;
@property (nonatomic,strong)UILabel *FansLab;
@end
