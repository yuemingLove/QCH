//
//  ProjectCell.m
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectCell2.h"

@implementation ProjectCell2

- (void)awakeFromNib {
    // Initialization code
    
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
    _pImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _pImageView.layer.borderWidth=0.5;
    
    _contentLabel.textColor=[UIColor themeBlueThreeColor];
    

    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



-(void)updateFrame:(NSDictionary*)dict{
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Project_ConverPic"]];
    [_pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    _themeLabel.text=[dict objectForKey:@"t_Project_Name"];
    _nameLabel.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"t_User_RealName"],[dict objectForKey:@"PositionName"]];
    _contentLabel.text=[dict objectForKey:@"t_Project_OneWord"];
    _statusLabel.text=[dict objectForKey:@"PhaseName"];
    
    _projectLabel.text=[NSString stringWithFormat:@"%@ / %@",[dict objectForKey:@"FiledName"],[dict objectForKey:@"FinancePhaseName"]];
}

@end
