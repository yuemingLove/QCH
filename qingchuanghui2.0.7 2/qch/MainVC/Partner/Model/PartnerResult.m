//
//	Result.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PartnerResult.h"

@interface PartnerResult ()
@end
@implementation PartnerResult




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(dictionary[@"Best"] != nil && [dictionary[@"Best"] isKindOfClass:[NSArray class]]){
        NSArray * bestDictionaries = dictionary[@"Best"];
        NSMutableArray * bestItems = [NSMutableArray array];
        for(NSDictionary * bestDictionary in bestDictionaries){
            Best * bestItem = [[Best alloc] initWithDictionary:bestDictionary];
            [bestItems addObject:bestItem];
        }
        self.best = bestItems;
    }
    if(![dictionary[@"FCount"] isKindOfClass:[NSNull class]]){
        self.fCount = dictionary[@"FCount"];
    }
    if(dictionary[@"FoucsArea"] != nil && [dictionary[@"FoucsArea"] isKindOfClass:[NSArray class]]){
        NSArray * foucsAreaDictionaries = dictionary[@"FoucsArea"];
        NSMutableArray * foucsAreaItems = [NSMutableArray array];
        for(NSDictionary * foucsAreaDictionary in foucsAreaDictionaries){
            FoucsArea * foucsAreaItem = [[FoucsArea alloc] initWithDictionary:foucsAreaDictionary];
            [foucsAreaItems addObject:foucsAreaItem];
        }
        self.foucsArea = foucsAreaItems;
    }
    if(![dictionary[@"Guid"] isKindOfClass:[NSNull class]]){
        self.guid = dictionary[@"Guid"];
    }
    if(dictionary[@"HistoryWork"] != nil && [dictionary[@"HistoryWork"] isKindOfClass:[NSArray class]]){
        NSArray * historyWorkDictionaries = dictionary[@"HistoryWork"];
        NSMutableArray * historyWorkItems = [NSMutableArray array];
        for(NSDictionary * historyWorkDictionary in historyWorkDictionaries){
            HistoryWork * historyWorkItem = [[HistoryWork alloc] initWithDictionary:historyWorkDictionary];
            [historyWorkItems addObject:historyWorkItem];
        }
        self.historyWork = historyWorkItems;
    }
    if(dictionary[@"Intention"] != nil && [dictionary[@"Intention"] isKindOfClass:[NSArray class]]){
        NSArray * intentionDictionaries = dictionary[@"Intention"];
        NSMutableArray * intentionItems = [NSMutableArray array];
        for(NSDictionary * intentionDictionary in intentionDictionaries){
            Intention * intentionItem = [[Intention alloc] initWithDictionary:intentionDictionary];
            [intentionItems addObject:intentionItem];
        }
        self.intention = intentionItems;
    }
    if(![dictionary[@"InvestArea"] isKindOfClass:[NSNull class]]){
        self.investArea = dictionary[@"InvestArea"];
    }
    if(![dictionary[@"InvestCase"] isKindOfClass:[NSNull class]]){
        self.investCase = dictionary[@"InvestCase"];
    }
    if(![dictionary[@"InvestPhase"] isKindOfClass:[NSNull class]]){
        self.investPhase = dictionary[@"InvestPhase"];
    }
    if(dictionary[@"NowNeed"] != nil && [dictionary[@"NowNeed"] isKindOfClass:[NSArray class]]){
        NSArray * nowNeedDictionaries = dictionary[@"NowNeed"];
        NSMutableArray * nowNeedItems = [NSMutableArray array];
        for(NSDictionary * nowNeedDictionary in nowNeedDictionaries){
            NowNeed * nowNeedItem = [[NowNeed alloc] initWithDictionary:nowNeedDictionary];
            [nowNeedItems addObject:nowNeedItem];
        }
        self.nowNeed = nowNeedItems;
    }
    if(![dictionary[@"PCount"] isKindOfClass:[NSNull class]]){
        self.pCount = dictionary[@"PCount"];
    }
    if(![dictionary[@"PositionName"] isKindOfClass:[NSNull class]]){
        self.positionName = dictionary[@"PositionName"];
    }
    if(![dictionary[@"PriaseProject"] isKindOfClass:[NSNull class]]){
        self.priaseProject = dictionary[@"PriaseProject"];
    }
    if(dictionary[@"Topic"] != nil && [dictionary[@"Topic"] isKindOfClass:[NSArray class]]){
        NSArray * topicDictionaries = dictionary[@"Topic"];
        NSMutableArray * topicItems = [NSMutableArray array];
        for(NSDictionary * topicDictionary in topicDictionaries){
            PartnerTopic * topicItem = [[PartnerTopic alloc] initWithDictionary:topicDictionary];
            [topicItems addObject:topicItem];
        }
        self.topic = topicItems;
    }
    if(dictionary[@"UserProject"] != nil && [dictionary[@"UserProject"] isKindOfClass:[NSArray class]]){
        NSArray * userProjectDictionaries = dictionary[@"UserProject"];
        NSMutableArray * userProjectItems = [NSMutableArray array];
        for(NSDictionary * userProjectDictionary in userProjectDictionaries){
            UserProject * userProjectItem = [[UserProject alloc] initWithDictionary:userProjectDictionary];
            [userProjectItems addObject:userProjectItem];
        }
        self.userProject = userProjectItems;
    }
    if(![dictionary[@"ifFoucs"] isKindOfClass:[NSNull class]]){
        self.ifFoucs = dictionary[@"ifFoucs"];
    }
    if(![dictionary[@"t_BackPic"] isKindOfClass:[NSNull class]]){
        self.tBackPic = dictionary[@"t_BackPic"];
    }
    if(dictionary[@"t_RongCloud_Token"] != nil && [dictionary[@"t_RongCloud_Token"] isKindOfClass:[NSArray class]]){
        NSArray * tRongCloudTokenDictionaries = dictionary[@"t_RongCloud_Token"];
        NSMutableArray * tRongCloudTokenItems = [NSMutableArray array];
        for(NSDictionary * tRongCloudTokenDictionary in tRongCloudTokenDictionaries){
            TRongCloudToken * tRongCloudTokenItem = [[TRongCloudToken alloc] initWithDictionary:tRongCloudTokenDictionary];
            [tRongCloudTokenItems addObject:tRongCloudTokenItem];
        }
        self.tRongCloudToken = tRongCloudTokenItems;
    }
    if(![dictionary[@"t_UserStyleAudit"] isKindOfClass:[NSNull class]]){
        self.tUserStyleAudit = dictionary[@"t_UserStyleAudit"];
    }
    if(![dictionary[@"t_User_Best"] isKindOfClass:[NSNull class]]){
        self.tUserBest = dictionary[@"t_User_Best"];
    }
    if(![dictionary[@"t_User_Birth"] isKindOfClass:[NSNull class]]){
        self.tUserBirth = dictionary[@"t_User_Birth"];
    }
    if(![dictionary[@"t_User_BusinessCard"] isKindOfClass:[NSNull class]]){
        self.tUserBusinessCard = dictionary[@"t_User_BusinessCard"];
    }
    if(![dictionary[@"t_User_City"] isKindOfClass:[NSNull class]]){
        self.tUserCity = dictionary[@"t_User_City"];
    }
    if(![dictionary[@"t_User_Commpany"] isKindOfClass:[NSNull class]]){
        self.tUserCommpany = dictionary[@"t_User_Commpany"];
    }
    if(![dictionary[@"t_User_Complete"] isKindOfClass:[NSNull class]]){
        self.tUserComplete = dictionary[@"t_User_Complete"];
    }
    if(![dictionary[@"t_User_Date"] isKindOfClass:[NSNull class]]){
        self.tUserDate = dictionary[@"t_User_Date"];
    }
    if(![dictionary[@"t_User_Email"] isKindOfClass:[NSNull class]]){
        self.tUserEmail = dictionary[@"t_User_Email"];
    }
    if(![dictionary[@"t_User_FocusArea"] isKindOfClass:[NSNull class]]){
        self.tUserFocusArea = dictionary[@"t_User_FocusArea"];
    }
    if(![dictionary[@"t_User_InvestArea"] isKindOfClass:[NSNull class]]){
        self.tUserInvestArea = dictionary[@"t_User_InvestArea"];
    }
    if(![dictionary[@"t_User_InvestMoney"] isKindOfClass:[NSNull class]]){
        self.tUserInvestMoney = dictionary[@"t_User_InvestMoney"];
    }
    if(![dictionary[@"t_User_InvestPhase"] isKindOfClass:[NSNull class]]){
        self.tUserInvestPhase = dictionary[@"t_User_InvestPhase"];
    }
    if(![dictionary[@"t_User_LoginId"] isKindOfClass:[NSNull class]]){
        self.tUserLoginId = dictionary[@"t_User_LoginId"];
    }
    if(![dictionary[@"t_User_Mobile"] isKindOfClass:[NSNull class]]){
        self.tUserMobile = dictionary[@"t_User_Mobile"];
    }
    if(![dictionary[@"t_User_Pic"] isKindOfClass:[NSNull class]]){
        self.tUserPic = dictionary[@"t_User_Pic"];
    }
    if(![dictionary[@"t_User_Position"] isKindOfClass:[NSNull class]]){
        self.tUserPosition = dictionary[@"t_User_Position"];
    }
    if(![dictionary[@"t_User_RealName"] isKindOfClass:[NSNull class]]){
        self.tUserRealName = dictionary[@"t_User_RealName"];
    }
    if(![dictionary[@"t_User_Remark"] isKindOfClass:[NSNull class]]){
        self.tUserRemark = dictionary[@"t_User_Remark"];
    }
    if(![dictionary[@"t_User_Sex"] isKindOfClass:[NSNull class]]){
        self.tUserSex = dictionary[@"t_User_Sex"];
    }
    if(![dictionary[@"t_User_Style"] isKindOfClass:[NSNull class]]){
        self.tUserStyle = dictionary[@"t_User_Style"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.best != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(Best * bestElement in self.best){
            [dictionaryElements addObject:[bestElement toDictionary]];
        }
        dictionary[@"Best"] = dictionaryElements;
    }
    if(self.fCount != nil){
        dictionary[@"FCount"] = self.fCount;
    }
    if(self.foucsArea != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(FoucsArea * foucsAreaElement in self.foucsArea){
            [dictionaryElements addObject:[foucsAreaElement toDictionary]];
        }
        dictionary[@"FoucsArea"] = dictionaryElements;
    }
    if(self.guid != nil){
        dictionary[@"Guid"] = self.guid;
    }
    if(self.historyWork != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(HistoryWork * historyWorkElement in self.historyWork){
            [dictionaryElements addObject:[historyWorkElement toDictionary]];
        }
        dictionary[@"HistoryWork"] = dictionaryElements;
    }
    if(self.intention != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(Intention * intentionElement in self.intention){
            [dictionaryElements addObject:[intentionElement toDictionary]];
        }
        dictionary[@"Intention"] = dictionaryElements;
    }
    if(self.investArea != nil){
        dictionary[@"InvestArea"] = self.investArea;
    }
    if(self.investCase != nil){
        dictionary[@"InvestCase"] = self.investCase;
    }
    if(self.investPhase != nil){
        dictionary[@"InvestPhase"] = self.investPhase;
    }
    if(self.nowNeed != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(NowNeed * nowNeedElement in self.nowNeed){
            [dictionaryElements addObject:[nowNeedElement toDictionary]];
        }
        dictionary[@"NowNeed"] = dictionaryElements;
    }
    if(self.pCount != nil){
        dictionary[@"PCount"] = self.pCount;
    }
    if(self.positionName != nil){
        dictionary[@"PositionName"] = self.positionName;
    }
    if(self.priaseProject != nil){
        dictionary[@"PriaseProject"] = self.priaseProject;
    }
    if(self.topic != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(PartnerTopic * topicElement in self.topic){
            [dictionaryElements addObject:[topicElement toDictionary]];
        }
        dictionary[@"Topic"] = dictionaryElements;
    }
    if(self.userProject != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(UserProject * userProjectElement in self.userProject){
            [dictionaryElements addObject:[userProjectElement toDictionary]];
        }
        dictionary[@"UserProject"] = dictionaryElements;
    }
    if(self.ifFoucs != nil){
        dictionary[@"ifFoucs"] = self.ifFoucs;
    }
    if(self.tBackPic != nil){
        dictionary[@"t_BackPic"] = self.tBackPic;
    }
    if(self.tRongCloudToken != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(TRongCloudToken * tRongCloudTokenElement in self.tRongCloudToken){
            [dictionaryElements addObject:[tRongCloudTokenElement toDictionary]];
        }
        dictionary[@"t_RongCloud_Token"] = dictionaryElements;
    }
    if(self.tUserStyleAudit != nil){
        dictionary[@"t_UserStyleAudit"] = self.tUserStyleAudit;
    }
    if(self.tUserBest != nil){
        dictionary[@"t_User_Best"] = self.tUserBest;
    }
    if(self.tUserBirth != nil){
        dictionary[@"t_User_Birth"] = self.tUserBirth;
    }
    if(self.tUserBusinessCard != nil){
        dictionary[@"t_User_BusinessCard"] = self.tUserBusinessCard;
    }
    if(self.tUserCity != nil){
        dictionary[@"t_User_City"] = self.tUserCity;
    }
    if(self.tUserCommpany != nil){
        dictionary[@"t_User_Commpany"] = self.tUserCommpany;
    }
    if(self.tUserComplete != nil){
        dictionary[@"t_User_Complete"] = self.tUserComplete;
    }
    if(self.tUserDate != nil){
        dictionary[@"t_User_Date"] = self.tUserDate;
    }
    if(self.tUserEmail != nil){
        dictionary[@"t_User_Email"] = self.tUserEmail;
    }
    if(self.tUserFocusArea != nil){
        dictionary[@"t_User_FocusArea"] = self.tUserFocusArea;
    }
    if(self.tUserInvestArea != nil){
        dictionary[@"t_User_InvestArea"] = self.tUserInvestArea;
    }
    if(self.tUserInvestMoney != nil){
        dictionary[@"t_User_InvestMoney"] = self.tUserInvestMoney;
    }
    if(self.tUserInvestPhase != nil){
        dictionary[@"t_User_InvestPhase"] = self.tUserInvestPhase;
    }
    if(self.tUserLoginId != nil){
        dictionary[@"t_User_LoginId"] = self.tUserLoginId;
    }
    if(self.tUserMobile != nil){
        dictionary[@"t_User_Mobile"] = self.tUserMobile;
    }
    if(self.tUserPic != nil){
        dictionary[@"t_User_Pic"] = self.tUserPic;
    }
    if(self.tUserPosition != nil){
        dictionary[@"t_User_Position"] = self.tUserPosition;
    }
    if(self.tUserRealName != nil){
        dictionary[@"t_User_RealName"] = self.tUserRealName;
    }
    if(self.tUserRemark != nil){
        dictionary[@"t_User_Remark"] = self.tUserRemark;
    }
    if(self.tUserSex != nil){
        dictionary[@"t_User_Sex"] = self.tUserSex;
    }
    if(self.tUserStyle != nil){
        dictionary[@"t_User_Style"] = self.tUserStyle;
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
    if(self.best != nil){
        [aCoder encodeObject:self.best forKey:@"Best"];
    }
    if(self.fCount != nil){
        [aCoder encodeObject:self.fCount forKey:@"FCount"];
    }
    if(self.foucsArea != nil){
        [aCoder encodeObject:self.foucsArea forKey:@"FoucsArea"];
    }
    if(self.guid != nil){
        [aCoder encodeObject:self.guid forKey:@"Guid"];
    }
    if(self.historyWork != nil){
        [aCoder encodeObject:self.historyWork forKey:@"HistoryWork"];
    }
    if(self.intention != nil){
        [aCoder encodeObject:self.intention forKey:@"Intention"];
    }
    if(self.investArea != nil){
        [aCoder encodeObject:self.investArea forKey:@"InvestArea"];
    }
    if(self.investCase != nil){
        [aCoder encodeObject:self.investCase forKey:@"InvestCase"];
    }
    if(self.investPhase != nil){
        [aCoder encodeObject:self.investPhase forKey:@"InvestPhase"];
    }
    if(self.nowNeed != nil){
        [aCoder encodeObject:self.nowNeed forKey:@"NowNeed"];
    }
    if(self.pCount != nil){
        [aCoder encodeObject:self.pCount forKey:@"PCount"];
    }
    if(self.positionName != nil){
        [aCoder encodeObject:self.positionName forKey:@"PositionName"];
    }
    if(self.priaseProject != nil){
        [aCoder encodeObject:self.priaseProject forKey:@"PriaseProject"];
    }
    if(self.topic != nil){
        [aCoder encodeObject:self.topic forKey:@"Topic"];
    }
    if(self.userProject != nil){
        [aCoder encodeObject:self.userProject forKey:@"UserProject"];
    }
    if(self.ifFoucs != nil){
        [aCoder encodeObject:self.ifFoucs forKey:@"ifFoucs"];
    }
    if(self.tBackPic != nil){
        [aCoder encodeObject:self.tBackPic forKey:@"t_BackPic"];
    }
    if(self.tRongCloudToken != nil){
        [aCoder encodeObject:self.tRongCloudToken forKey:@"t_RongCloud_Token"];
    }
    if(self.tUserStyleAudit != nil){
        [aCoder encodeObject:self.tUserStyleAudit forKey:@"t_UserStyleAudit"];
    }
    if(self.tUserBest != nil){
        [aCoder encodeObject:self.tUserBest forKey:@"t_User_Best"];
    }
    if(self.tUserBirth != nil){
        [aCoder encodeObject:self.tUserBirth forKey:@"t_User_Birth"];
    }
    if(self.tUserBusinessCard != nil){
        [aCoder encodeObject:self.tUserBusinessCard forKey:@"t_User_BusinessCard"];
    }
    if(self.tUserCity != nil){
        [aCoder encodeObject:self.tUserCity forKey:@"t_User_City"];
    }
    if(self.tUserCommpany != nil){
        [aCoder encodeObject:self.tUserCommpany forKey:@"t_User_Commpany"];
    }
    if(self.tUserComplete != nil){
        [aCoder encodeObject:self.tUserComplete forKey:@"t_User_Complete"];
    }
    if(self.tUserDate != nil){
        [aCoder encodeObject:self.tUserDate forKey:@"t_User_Date"];
    }
    if(self.tUserEmail != nil){
        [aCoder encodeObject:self.tUserEmail forKey:@"t_User_Email"];
    }
    if(self.tUserFocusArea != nil){
        [aCoder encodeObject:self.tUserFocusArea forKey:@"t_User_FocusArea"];
    }
    if(self.tUserInvestArea != nil){
        [aCoder encodeObject:self.tUserInvestArea forKey:@"t_User_InvestArea"];
    }
    if(self.tUserInvestMoney != nil){
        [aCoder encodeObject:self.tUserInvestMoney forKey:@"t_User_InvestMoney"];
    }
    if(self.tUserInvestPhase != nil){
        [aCoder encodeObject:self.tUserInvestPhase forKey:@"t_User_InvestPhase"];
    }
    if(self.tUserLoginId != nil){
        [aCoder encodeObject:self.tUserLoginId forKey:@"t_User_LoginId"];
    }
    if(self.tUserMobile != nil){
        [aCoder encodeObject:self.tUserMobile forKey:@"t_User_Mobile"];
    }
    if(self.tUserPic != nil){
        [aCoder encodeObject:self.tUserPic forKey:@"t_User_Pic"];
    }
    if(self.tUserPosition != nil){
        [aCoder encodeObject:self.tUserPosition forKey:@"t_User_Position"];
    }
    if(self.tUserRealName != nil){
        [aCoder encodeObject:self.tUserRealName forKey:@"t_User_RealName"];
    }
    if(self.tUserRemark != nil){
        [aCoder encodeObject:self.tUserRemark forKey:@"t_User_Remark"];
    }
    if(self.tUserSex != nil){
        [aCoder encodeObject:self.tUserSex forKey:@"t_User_Sex"];
    }
    if(self.tUserStyle != nil){
        [aCoder encodeObject:self.tUserStyle forKey:@"t_User_Style"];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.best = [aDecoder decodeObjectForKey:@"Best"];
    self.fCount = [aDecoder decodeObjectForKey:@"FCount"];
    self.foucsArea = [aDecoder decodeObjectForKey:@"FoucsArea"];
    self.guid = [aDecoder decodeObjectForKey:@"Guid"];
    self.historyWork = [aDecoder decodeObjectForKey:@"HistoryWork"];
    self.intention = [aDecoder decodeObjectForKey:@"Intention"];
    self.investArea = [aDecoder decodeObjectForKey:@"InvestArea"];
    self.investCase = [aDecoder decodeObjectForKey:@"InvestCase"];
    self.investPhase = [aDecoder decodeObjectForKey:@"InvestPhase"];
    self.nowNeed = [aDecoder decodeObjectForKey:@"NowNeed"];
    self.pCount = [aDecoder decodeObjectForKey:@"PCount"];
    self.positionName = [aDecoder decodeObjectForKey:@"PositionName"];
    self.priaseProject = [aDecoder decodeObjectForKey:@"PriaseProject"];
    self.topic = [aDecoder decodeObjectForKey:@"Topic"];
    self.userProject = [aDecoder decodeObjectForKey:@"UserProject"];
    self.ifFoucs = [aDecoder decodeObjectForKey:@"ifFoucs"];
    self.tBackPic = [aDecoder decodeObjectForKey:@"t_BackPic"];
    self.tRongCloudToken = [aDecoder decodeObjectForKey:@"t_RongCloud_Token"];
    self.tUserStyleAudit = [aDecoder decodeObjectForKey:@"t_UserStyleAudit"];
    self.tUserBest = [aDecoder decodeObjectForKey:@"t_User_Best"];
    self.tUserBirth = [aDecoder decodeObjectForKey:@"t_User_Birth"];
    self.tUserBusinessCard = [aDecoder decodeObjectForKey:@"t_User_BusinessCard"];
    self.tUserCity = [aDecoder decodeObjectForKey:@"t_User_City"];
    self.tUserCommpany = [aDecoder decodeObjectForKey:@"t_User_Commpany"];
    self.tUserComplete = [aDecoder decodeObjectForKey:@"t_User_Complete"];
    self.tUserDate = [aDecoder decodeObjectForKey:@"t_User_Date"];
    self.tUserEmail = [aDecoder decodeObjectForKey:@"t_User_Email"];
    self.tUserFocusArea = [aDecoder decodeObjectForKey:@"t_User_FocusArea"];
    self.tUserInvestArea = [aDecoder decodeObjectForKey:@"t_User_InvestArea"];
    self.tUserInvestMoney = [aDecoder decodeObjectForKey:@"t_User_InvestMoney"];
    self.tUserInvestPhase = [aDecoder decodeObjectForKey:@"t_User_InvestPhase"];
    self.tUserLoginId = [aDecoder decodeObjectForKey:@"t_User_LoginId"];
    self.tUserMobile = [aDecoder decodeObjectForKey:@"t_User_Mobile"];
    self.tUserPic = [aDecoder decodeObjectForKey:@"t_User_Pic"];
    self.tUserPosition = [aDecoder decodeObjectForKey:@"t_User_Position"];
    self.tUserRealName = [aDecoder decodeObjectForKey:@"t_User_RealName"];
    self.tUserRemark = [aDecoder decodeObjectForKey:@"t_User_Remark"];
    self.tUserSex = [aDecoder decodeObjectForKey:@"t_User_Sex"];
    self.tUserStyle = [aDecoder decodeObjectForKey:@"t_User_Style"];
    return self;
    
}
@end