//
//  RCDGroupInfo.h
//  qch
//
//  Created by 苏宾 on 16/1/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCDGroupInfo : RCGroup<NSCoding>
/** 人数 */
@property(nonatomic, strong) NSString* number;
/** 最大人数 */
@property(nonatomic, strong) NSString* maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString* introduce;

/** 创建者Id */
@property(nonatomic, strong) NSString* creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString* creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL  isJoin;

@end
