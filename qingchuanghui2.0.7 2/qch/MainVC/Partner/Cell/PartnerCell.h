//
//  PartnerCell.h
//  
//
//  Created by 青创汇 on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import "PartnerResult.h"
#import "Intention.h"
#import "NowNeed.h"
@interface PartnerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *UserPic;
@property (weak, nonatomic) IBOutlet UILabel *UserRealName;
@property (weak, nonatomic) IBOutlet UILabel *domain;
@property (weak, nonatomic) IBOutlet UILabel *intention;

@property (weak, nonatomic) IBOutlet UILabel *CompanyAndPosition;
@property (weak, nonatomic) IBOutlet UILabel *Remark;
@property (weak, nonatomic) IBOutlet UILabel *Best;
@property (weak, nonatomic) IBOutlet UILabel *NowNeed;
- (void)updataFrame:(PartnerResult *)model;
@property (weak, nonatomic) IBOutlet UIImageView *biaoqian;
@end
