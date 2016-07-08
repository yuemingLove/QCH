//
//	Topic.h
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "PartnerPic.h"

@interface PartnerTopic : NSObject

@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSArray * pic;
@property (nonatomic, strong) NSString * tDate;
@property (nonatomic, strong) NSString * tTopicAddress;
@property (nonatomic, strong) NSString * tTopicCity;
@property (nonatomic, strong) NSString * tTopicContents;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end