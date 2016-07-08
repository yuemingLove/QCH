//
//  MessageModel.h
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong) NSString *Guid;
@property (nonatomic,strong) NSString *t_Alert;
@property (nonatomic,strong) NSString *t_Associate_Guid;
@property (nonatomic,strong) NSString *t_Date;
@property (nonatomic,strong) NSString *t_Title;
@property (nonatomic,strong) NSString *t_Type;
@property (nonatomic,strong) NSString *t_User_Guid;
@property (nonatomic,strong) NSString *t_IfRead;

@end
