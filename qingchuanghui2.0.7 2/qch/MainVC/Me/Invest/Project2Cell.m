//
//  ProjectCell.m
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "Project2Cell.h"

@implementation Project2Cell

- (void)awakeFromNib {
    // Initialization code
    
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
    
    _delBtn.layer.masksToBounds=YES;
    _delBtn.layer.cornerRadius=_delBtn.height/2;
    _delBtn.layer.borderColor=[UIColor redColor].CGColor;
    _delBtn.layer.borderWidth=1;
    
    _goodBtn.layer.masksToBounds=YES;
    _goodBtn.layer.cornerRadius=_goodBtn.height/2;
    _goodBtn.layer.borderWidth=1;
    _goodBtn.layer.borderColor=[UIColor themeBlueTwoColor].CGColor;
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
    _numLabel.text=[dict objectForKey:@"PraiseCount"];
    
    NSInteger ifPraise=[(NSNumber*)[dict objectForKey:@"ifPraise"]integerValue];
    if (ifPraise==0) {
        [_careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];
    }else{
        [_careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];
    }

    _projectLabel.text=[NSString stringWithFormat:@"%@ / %@",[dict objectForKey:@"FiledName"],[dict objectForKey:@"FinancePhaseName"]];
}

-(IBAction)delCareBtn:(UIButton*)sender{
    if ([self.projectDelegate respondsToSelector:@selector(delCareProject:index:)]) {
        [self.projectDelegate delCareProject:self index:[sender tag]];
    }
}

-(IBAction)addCareBtn:(UIButton*)sender{

    if ([self.projectDelegate respondsToSelector:@selector(addCareProject:index:)]) {
        [self.projectDelegate addCareProject:self index:[sender tag]];
    }
}

@end
