//
//  ProjectModel.h
//  qch
//
//  Created by W.兵 on 16/5/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSString *pro_id, *pro_name, *pro_phase, *pro_brief, *pro_city, *pro_field, *pro_describe, *pro_advantage, *pro_users, *pro_financingStage, *pro_financingAmount, *pro_capitalUseProportion, *pro_profitableWay, *pro_websiteLink, *pro_linkLink, *pro_weixinLink, *pro_photoStr;
@property (nonatomic, strong) UIImage *pro_icon, *pro_productImage1, *pro_productImage2, *pro_productImage3, *pro_productImage4, *pro_productImage5, *pro_productImage6, *pro_productImage7, *pro_productImage8, *pro_productImage9, *pro_productImage;
@property (nonatomic, copy) NSString *photoStr, *stage, *territory, *rongzi;

@end
