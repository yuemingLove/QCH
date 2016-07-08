//
//	FoucsArea.h
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FoucsArea : NSObject

@property (nonatomic, strong) NSString * foucsName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end