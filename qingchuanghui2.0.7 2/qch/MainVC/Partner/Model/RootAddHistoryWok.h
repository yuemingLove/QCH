//
//	RootClass.h
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "AddHistoryWork.h"

@interface RootAddHistoryWok : NSObject

@property (nonatomic, strong) NSArray * result;
@property (nonatomic, assign) BOOL state;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end