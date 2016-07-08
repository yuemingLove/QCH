//
//	RootClass.h
//
//	Create by 创汇 青 on 22/1/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "DynamicTalkModel.h"

@interface RootDynamicTalkClass : NSObject

@property (nonatomic, strong) NSArray * result;
@property (nonatomic, assign) BOOL state;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end