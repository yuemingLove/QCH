//
//	Result.h
//
//	Create by 创汇 青 on 22/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface DynamicTalkModel : NSObject

@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSArray * strReply;
@property (nonatomic, strong) NSString * tAssociateGuid;
@property (nonatomic, strong) NSString * tDelState;
@property (nonatomic, strong) NSString * tTalkAudit;
@property (nonatomic, strong) NSString * tTalkBad;
@property (nonatomic, strong) NSString * tTalkFromContent;
@property (nonatomic, strong) NSString * tTalkFromDate;
@property (nonatomic, strong) NSString * tTalkFromUserGuid;
@property (nonatomic, strong) NSString * tTalkGood;
@property (nonatomic, strong) NSString * tTalkToContent;
@property (nonatomic, strong) NSString * tTalkToDate;
@property (nonatomic, strong) NSString * tTalkToUserGuid;
@property (nonatomic, strong) NSString * tUserLoginId;
@property (nonatomic, strong) NSString * tUserPic;
@property (nonatomic, strong) NSString * tUserRealName;
@property (nonatomic, strong) NSString * toUserLoginId;
@property (nonatomic, strong) NSString * toUserPic;
@property (nonatomic, strong) NSString * toUserRealName;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end