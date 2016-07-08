//
//	UserProject.h
//
//	Create by 创汇 青 on 23/2/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface UserProject : NSObject

@property (nonatomic, strong) NSString * guid;
@property (nonatomic, strong) NSString * projectName;
@property (nonatomic, strong) NSString * tProjectConverPic;
@property (nonatomic, strong) NSString * tProjectOneWord;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end