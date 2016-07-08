//
//	FoucsArea.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FoucsArea.h"

@interface FoucsArea ()
@end
@implementation FoucsArea




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"FoucsName"] isKindOfClass:[NSNull class]]){
		self.foucsName = dictionary[@"FoucsName"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.foucsName != nil){
		dictionary[@"FoucsName"] = self.foucsName;
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
	if(self.foucsName != nil){
		[aCoder encodeObject:self.foucsName forKey:@"FoucsName"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.foucsName = [aDecoder decodeObjectForKey:@"FoucsName"];
	return self;

}
@end