//
//	NowNeed.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NowNeed.h"

@interface NowNeed ()
@end
@implementation NowNeed




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"NowNeedID"] isKindOfClass:[NSNull class]]){
		self.nowNeedID = dictionary[@"NowNeedID"];
	}	
	if(![dictionary[@"NowNeedName"] isKindOfClass:[NSNull class]]){
		self.nowNeedName = dictionary[@"NowNeedName"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.nowNeedID != nil){
		dictionary[@"NowNeedID"] = self.nowNeedID;
	}
	if(self.nowNeedName != nil){
		dictionary[@"NowNeedName"] = self.nowNeedName;
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
	if(self.nowNeedID != nil){
		[aCoder encodeObject:self.nowNeedID forKey:@"NowNeedID"];
	}
	if(self.nowNeedName != nil){
		[aCoder encodeObject:self.nowNeedName forKey:@"NowNeedName"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.nowNeedID = [aDecoder decodeObjectForKey:@"NowNeedID"];
	self.nowNeedName = [aDecoder decodeObjectForKey:@"NowNeedName"];
	return self;

}
@end