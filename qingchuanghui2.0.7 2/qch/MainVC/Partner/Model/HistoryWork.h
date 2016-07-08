//
//	HistoryWork.h
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface HistoryWork : NSObject

@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSString * tCommpany;
@property (nonatomic, strong) NSString * tPosition;
@property (nonatomic, strong) NSString * tUserGuid;
@property (nonatomic, strong) NSString * tEDate;
@property (nonatomic, strong) NSString * tSDate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end