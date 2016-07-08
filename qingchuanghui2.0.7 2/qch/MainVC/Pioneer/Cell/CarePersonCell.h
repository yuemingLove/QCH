//
//  CarePersonCell.h
//  qch
//
//  Created by 青创汇 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarePersonCell;

@protocol CarePersonCellDeleagte <NSObject>
- (void)careClicked:(CarePersonCell *)cell index:(NSInteger)index;
@end
@interface CarePersonCell : UITableViewCell

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,strong) UIImageView *IconImage;
@property (nonatomic,strong) UILabel *NameLab;
@property (nonatomic,strong) UIButton *CareBtn;
@property (nonatomic,strong) UILabel *IdentityLab;
@property (nonatomic,weak) id<CarePersonCellDeleagte> CareDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;




@end
