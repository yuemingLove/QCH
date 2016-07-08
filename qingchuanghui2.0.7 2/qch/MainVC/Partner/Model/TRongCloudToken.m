//
//	TRongCloudToken.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "TRongCloudToken.h"

@interface TRongCloudToken ()
@end
@implementation TRongCloudToken




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"code"] isKindOfClass:[NSNull class]]){
		self.code = [dictionary[@"code"] integerValue];
	}

	if(![dictionary[@"token"] isKindOfClass:[NSNull class]]){
		self.token = dictionary[@"token"];
	}	
	if(![dictionary[@"userId"] isKindOfClass:[NSNull class]]){
		self.userId = dictionary[@"userId"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[@"code"] = @(self.code);
	if(self.token != nil){
		dictionary[@"token"] = self.token;
	}
	if(self.userId != nil){
		dictionary[@"userId"] = self.userId;
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
	[aCoder encodeObject:@(self.code) forKey:@"code"];	if(self.token != nil){
		[aCoder encodeObject:self.token forKey:@"token"];
	}
	if(self.userId != nil){
		[aCoder encodeObject:self.userId forKey:@"userId"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.code = [[aDecoder decodeObjectForKey:@"code"] integerValue];
	self.token = [aDecoder decodeObjectForKey:@"token"];
	self.userId = [aDecoder decodeObjectForKey:@"userId"];
	return self;

}
@end