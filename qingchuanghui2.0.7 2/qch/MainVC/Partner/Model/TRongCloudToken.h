//
//	TRongCloudToken.h
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface TRongCloudToken : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end