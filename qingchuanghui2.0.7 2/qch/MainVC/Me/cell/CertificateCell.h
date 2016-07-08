//
//  CertificateCell.h
//  qch
//
//  Created by 青创汇 on 16/4/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Typelab;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *OrganizerLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *AddressLab;


@property (nonatomic,weak) IBOutlet UIView *bgkView;

@end
