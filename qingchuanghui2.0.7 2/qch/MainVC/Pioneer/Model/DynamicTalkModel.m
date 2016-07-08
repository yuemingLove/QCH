//
//	Result.m
//
//	Create by 创汇 青 on 22/1/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DynamicTalkModel.h"

@interface DynamicTalkModel ()
@end
@implementation DynamicTalkModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"Guid"] isKindOfClass:[NSNull class]]){
        self.guid = dictionary[@"Guid"];
    }
    if(![dictionary[@"strReply"] isKindOfClass:[NSNull class]]){
        self.strReply = dictionary[@"strReply"];
    }
    if(![dictionary[@"t_Associate_Guid"] isKindOfClass:[NSNull class]]){
        self.tAssociateGuid = dictionary[@"t_Associate_Guid"];
    }
    if(![dictionary[@"t_DelState"] isKindOfClass:[NSNull class]]){
        self.tDelState = dictionary[@"t_DelState"];
    }
    if(![dictionary[@"t_Talk_Audit"] isKindOfClass:[NSNull class]]){
        self.tTalkAudit = dictionary[@"t_Talk_Audit"];
    }
    if(![dictionary[@"t_Talk_Bad"] isKindOfClass:[NSNull class]]){
        self.tTalkBad = dictionary[@"t_Talk_Bad"];
    }
    if(![dictionary[@"t_Talk_FromContent"] isKindOfClass:[NSNull class]]){
        self.tTalkFromContent = dictionary[@"t_Talk_FromContent"];
    }
    if(![dictionary[@"t_Talk_FromDate"] isKindOfClass:[NSNull class]]){
        self.tTalkFromDate = dictionary[@"t_Talk_FromDate"];
    }
    if(![dictionary[@"t_Talk_FromUserGuid"] isKindOfClass:[NSNull class]]){
        self.tTalkFromUserGuid = dictionary[@"t_Talk_FromUserGuid"];
    }
    if(![dictionary[@"t_Talk_Good"] isKindOfClass:[NSNull class]]){
        self.tTalkGood = dictionary[@"t_Talk_Good"];
    }
    if(![dictionary[@"t_Talk_ToContent"] isKindOfClass:[NSNull class]]){
        self.tTalkToContent = dictionary[@"t_Talk_ToContent"];
    }
    if(![dictionary[@"t_Talk_ToDate"] isKindOfClass:[NSNull class]]){
        self.tTalkToDate = dictionary[@"t_Talk_ToDate"];
    }
    if(![dictionary[@"t_Talk_ToUserGuid"] isKindOfClass:[NSNull class]]){
        self.tTalkToUserGuid = dictionary[@"t_Talk_ToUserGuid"];
    }
    if(![dictionary[@"t_User_LoginId"] isKindOfClass:[NSNull class]]){
        self.tUserLoginId = dictionary[@"t_User_LoginId"];
    }
    if(![dictionary[@"t_User_Pic"] isKindOfClass:[NSNull class]]){
        self.tUserPic = dictionary[@"t_User_Pic"];
    }
    if(![dictionary[@"t_User_RealName"] isKindOfClass:[NSNull class]]){
        self.tUserRealName = dictionary[@"t_User_RealName"];
    }
    if(![dictionary[@"toUserLoginId"] isKindOfClass:[NSNull class]]){
        self.toUserLoginId = dictionary[@"toUserLoginId"];
    }
    if(![dictionary[@"toUserPic"] isKindOfClass:[NSNull class]]){
        self.toUserPic = dictionary[@"toUserPic"];
    }
    if(![dictionary[@"toUserRealName"] isKindOfClass:[NSNull class]]){
        self.toUserRealName = dictionary[@"toUserRealName"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.guid != nil){
        dictionary[@"Guid"] = self.guid;
    }
    if(self.strReply != nil){
        dictionary[@"strReply"] = self.strReply;
    }
    if(self.tAssociateGuid != nil){
        dictionary[@"t_Associate_Guid"] = self.tAssociateGuid;
    }
    if(self.tDelState != nil){
        dictionary[@"t_DelState"] = self.tDelState;
    }
    if(self.tTalkAudit != nil){
        dictionary[@"t_Talk_Audit"] = self.tTalkAudit;
    }
    if(self.tTalkBad != nil){
        dictionary[@"t_Talk_Bad"] = self.tTalkBad;
    }
    if(self.tTalkFromContent != nil){
        dictionary[@"t_Talk_FromContent"] = self.tTalkFromContent;
    }
    if(self.tTalkFromDate != nil){
        dictionary[@"t_Talk_FromDate"] = self.tTalkFromDate;
    }
    if(self.tTalkFromUserGuid != nil){
        dictionary[@"t_Talk_FromUserGuid"] = self.tTalkFromUserGuid;
    }
    if(self.tTalkGood != nil){
        dictionary[@"t_Talk_Good"] = self.tTalkGood;
    }
    if(self.tTalkToContent != nil){
        dictionary[@"t_Talk_ToContent"] = self.tTalkToContent;
    }
    if(self.tTalkToDate != nil){
        dictionary[@"t_Talk_ToDate"] = self.tTalkToDate;
    }
    if(self.tTalkToUserGuid != nil){
        dictionary[@"t_Talk_ToUserGuid"] = self.tTalkToUserGuid;
    }
    if(self.tUserLoginId != nil){
        dictionary[@"t_User_LoginId"] = self.tUserLoginId;
    }
    if(self.tUserPic != nil){
        dictionary[@"t_User_Pic"] = self.tUserPic;
    }
    if(self.tUserRealName != nil){
        dictionary[@"t_User_RealName"] = self.tUserRealName;
    }
    if(self.toUserLoginId != nil){
        dictionary[@"toUserLoginId"] = self.toUserLoginId;
    }
    if(self.toUserPic != nil){
        dictionary[@"toUserPic"] = self.toUserPic;
    }
    if(self.toUserRealName != nil){
        dictionary[@"toUserRealName"] = self.toUserRealName;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.guid != nil){
        [aCoder encodeObject:self.guid forKey:@"Guid"];
    }
    if(self.strReply != nil){
        [aCoder encodeObject:self.strReply forKey:@"strReply"];
    }
    if(self.tAssociateGuid != nil){
        [aCoder encodeObject:self.tAssociateGuid forKey:@"t_Associate_Guid"];
    }
    if(self.tDelState != nil){
        [aCoder encodeObject:self.tDelState forKey:@"t_DelState"];
    }
    if(self.tTalkAudit != nil){
        [aCoder encodeObject:self.tTalkAudit forKey:@"t_Talk_Audit"];
    }
    if(self.tTalkBad != nil){
        [aCoder encodeObject:self.tTalkBad forKey:@"t_Talk_Bad"];
    }
    if(self.tTalkFromContent != nil){
        [aCoder encodeObject:self.tTalkFromContent forKey:@"t_Talk_FromContent"];
    }
    if(self.tTalkFromDate != nil){
        [aCoder encodeObject:self.tTalkFromDate forKey:@"t_Talk_FromDate"];
    }
    if(self.tTalkFromUserGuid != nil){
        [aCoder encodeObject:self.tTalkFromUserGuid forKey:@"t_Talk_FromUserGuid"];
    }
    if(self.tTalkGood != nil){
        [aCoder encodeObject:self.tTalkGood forKey:@"t_Talk_Good"];
    }
    if(self.tTalkToContent != nil){
        [aCoder encodeObject:self.tTalkToContent forKey:@"t_Talk_ToContent"];
    }
    if(self.tTalkToDate != nil){
        [aCoder encodeObject:self.tTalkToDate forKey:@"t_Talk_ToDate"];
    }
    if(self.tTalkToUserGuid != nil){
        [aCoder encodeObject:self.tTalkToUserGuid forKey:@"t_Talk_ToUserGuid"];
    }
    if(self.tUserLoginId != nil){
        [aCoder encodeObject:self.tUserLoginId forKey:@"t_User_LoginId"];
    }
    if(self.tUserPic != nil){
        [aCoder encodeObject:self.tUserPic forKey:@"t_User_Pic"];
    }
    if(self.tUserRealName != nil){
        [aCoder encodeObject:self.tUserRealName forKey:@"t_User_RealName"];
    }
    if(self.toUserLoginId != nil){
        [aCoder encodeObject:self.toUserLoginId forKey:@"toUserLoginId"];
    }
    if(self.toUserPic != nil){
        [aCoder encodeObject:self.toUserPic forKey:@"toUserPic"];
    }
    if(self.toUserRealName != nil){
        [aCoder encodeObject:self.toUserRealName forKey:@"toUserRealName"];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.guid = [aDecoder decodeObjectForKey:@"Guid"];
    self.strReply = [aDecoder decodeObjectForKey:@"strReply"];
    self.tAssociateGuid = [aDecoder decodeObjectForKey:@"t_Associate_Guid"];
    self.tDelState = [aDecoder decodeObjectForKey:@"t_DelState"];
    self.tTalkAudit = [aDecoder decodeObjectForKey:@"t_Talk_Audit"];
    self.tTalkBad = [aDecoder decodeObjectForKey:@"t_Talk_Bad"];
    self.tTalkFromContent = [aDecoder decodeObjectForKey:@"t_Talk_FromContent"];
    self.tTalkFromDate = [aDecoder decodeObjectForKey:@"t_Talk_FromDate"];
    self.tTalkFromUserGuid = [aDecoder decodeObjectForKey:@"t_Talk_FromUserGuid"];
    self.tTalkGood = [aDecoder decodeObjectForKey:@"t_Talk_Good"];
    self.tTalkToContent = [aDecoder decodeObjectForKey:@"t_Talk_ToContent"];
    self.tTalkToDate = [aDecoder decodeObjectForKey:@"t_Talk_ToDate"];
    self.tTalkToUserGuid = [aDecoder decodeObjectForKey:@"t_Talk_ToUserGuid"];
    self.tUserLoginId = [aDecoder decodeObjectForKey:@"t_User_LoginId"];
    self.tUserPic = [aDecoder decodeObjectForKey:@"t_User_Pic"];
    self.tUserRealName = [aDecoder decodeObjectForKey:@"t_User_RealName"];
    self.toUserLoginId = [aDecoder decodeObjectForKey:@"toUserLoginId"];
    self.toUserPic = [aDecoder decodeObjectForKey:@"toUserPic"];
    self.toUserRealName = [aDecoder decodeObjectForKey:@"toUserRealName"];
    return self;
    
}
@end