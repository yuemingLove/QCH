//
//  PConsultModel.h
//  qch
//
//  Created by 苏宾 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PConsultModel : NSObject

@property (nonatomic,strong) NSString *Guid;
@property (nonatomic,strong) NSString *t_News_Style;
@property (nonatomic,strong) NSString *t_News_Pic;
@property (nonatomic,strong) NSString *t_News_Title;
@property (nonatomic,strong) NSString *t_News_Author;
@property (nonatomic,strong) NSString *t_News_Date;
@property (nonatomic,strong) NSString *t_News_Counts;
@property (nonatomic,strong) NSString *t_News_Index;
@property (nonatomic,strong) NSString *t_News_Recommand;
@property (nonatomic,strong) NSString *t_Style_Name;
@property (nonatomic,strong) NSString *ProvinceName;
@property (nonatomic,strong) NSString *CityName;
@property (nonatomic,strong) NSString *t_News_LimitContents;

@end
