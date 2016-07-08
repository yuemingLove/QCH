//
//  PartnerCell.m
//  
//
//  Created by 青创汇 on 16/6/20.
//
//

#import "PartnerCell.h"

@implementation PartnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _UserPic.layer.cornerRadius = _UserPic.height/2;
    _UserPic.layer.masksToBounds = YES;
    _domain.layer.cornerRadius = _domain.height/2;
    _domain.layer.masksToBounds = YES;
    _domain.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updataFrame:(PartnerResult *)model
{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,model.tUserPic];
    [_UserPic sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    if (model.tUserRealName.length>10) {
        _UserRealName.text = [NSString stringWithFormat:@"%@",[model.tUserRealName substringToIndex:10]];
    }else{
        _UserRealName.text = model.tUserRealName;
    }
    _CompanyAndPosition.text = [NSString stringWithFormat:@"%@  %@",model.positionName,model.tUserCommpany];
    _Remark.text = model.tUserRemark;
    _Remark.text = [[NSString stringWithFormat:@"%@",model.tUserRemark] stringByReplacingOccurrencesOfString:@"===" withString:@" "];
    
    NSString *Beststring = @"";
    NSArray *array = model.best;
    for (int i = 0; i<[array count]; i++) {
        Best *best = array[i];
        NSString *beststring = best.bestName;
        if ([Beststring isEqualToString:@""]) {
            Beststring = beststring;
        } else {
            Beststring = [Beststring stringByAppendingString:[NSString stringWithFormat:@" / %@",beststring]];
        }
    }
    _Best.text = [NSString stringWithFormat:@"Ta擅长:%@",Beststring];
    
    NSArray *array1 = model.foucsArea;
    FoucsArea *fouce = array1[0];
    _domain.text = [NSString stringWithFormat:@"\t%@\t",fouce.foucsName];
    
    if ([model.intention count]>0) {
        NSArray *array2 = model.intention;
        Intention *intention = array2[0];
        _intention.text = intention.intentionName;
    }else{
        _intention.hidden = YES;
        _biaoqian.hidden = YES;
    }
    if ([model.nowNeed count]>0) {
        NSArray *array2 = model.nowNeed;
        NSString *nowNeedName = @"";
        for (int i = 0; i<[array2 count]; i++) {
            NowNeed *need = array2[i];
            NSString *needstr = need.nowNeedName;
            if ([nowNeedName isEqualToString:@""]) {
                nowNeedName = needstr;
            } else {
                nowNeedName = [nowNeedName stringByAppendingString:[NSString stringWithFormat:@" / %@",needstr]];
            }
        }
        _NowNeed.text = [NSString stringWithFormat:@"Ta需要:%@",nowNeedName];
    }else{
        _NowNeed.hidden = YES;
        CGRect frame = self.frame;
        float height =frame.size.height-20*PMBWIDTH;
        self.height = height;
    }

}

@end
