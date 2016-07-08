#import <UIKit/UIKit.h>
#import "Best.h"
#import "FoucsArea.h"
#import "HistoryWork.h"
#import "Intention.h"
#import "NowNeed.h"
#import "PartnerTopic.h"
#import "UserProject.h"
#import "TRongCloudToken.h"

@interface PartnerResult : NSObject

@property (nonatomic, strong) NSArray * best;
@property (nonatomic, strong) NSString * fCount;
@property (nonatomic, strong) NSArray * foucsArea;
@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSArray * historyWork;
@property (nonatomic, strong) NSArray * intention;
@property (nonatomic, strong) NSArray * investArea;
@property (nonatomic, strong) NSArray * investCase;
@property (nonatomic, strong) NSArray * investPhase;
@property (nonatomic, strong) NSArray * nowNeed;
@property (nonatomic, strong) NSString * pCount;
@property (nonatomic, strong) NSString * positionName;
@property (nonatomic, strong) NSArray * priaseProject;
@property (nonatomic, strong) NSArray * topic;
@property (nonatomic, strong) NSArray * userProject;
@property (nonatomic, strong) NSString * ifFoucs;
@property (nonatomic, strong) NSString * tBackPic;
@property (nonatomic, strong) NSArray * tRongCloudToken;
@property (nonatomic, strong) NSString * tUserStyleAudit;
@property (nonatomic, strong) NSString * tUserBest;
@property (nonatomic, strong) NSString * tUserBirth;
@property (nonatomic, strong) NSString * tUserBusinessCard;
@property (nonatomic, strong) NSString * tUserCity;
@property (nonatomic, strong) NSString * tUserCommpany;
@property (nonatomic, strong) NSString * tUserComplete;
@property (nonatomic, strong) NSString * tUserDate;
@property (nonatomic, strong) NSString * tUserEmail;
@property (nonatomic, strong) NSString * tUserFocusArea;
@property (nonatomic, strong) NSString * tUserInvestArea;
@property (nonatomic, strong) NSString * tUserInvestMoney;
@property (nonatomic, strong) NSString * tUserInvestPhase;
@property (nonatomic, strong) NSString * tUserLoginId;
@property (nonatomic, strong) NSString * tUserMobile;
@property (nonatomic, strong) NSString * tUserPic;
@property (nonatomic, strong) NSString * tUserPosition;
@property (nonatomic, strong) NSString * tUserRealName;
@property (nonatomic, strong) NSString * tUserRemark;
@property (nonatomic, strong) NSString * tUserSex;
@property (nonatomic, strong) NSString * tUserStyle;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end