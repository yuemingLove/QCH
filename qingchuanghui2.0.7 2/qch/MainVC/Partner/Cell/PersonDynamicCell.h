//
//  PersonDynamicCell.h
//  
//
//  Created by 青创汇 on 16/2/17.
//
//

#import <UIKit/UIKit.h>

@interface PersonDynamicCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,strong)PartnerResult *model;
@property (nonatomic,strong)UIButton *SelctedBtn;

@end
