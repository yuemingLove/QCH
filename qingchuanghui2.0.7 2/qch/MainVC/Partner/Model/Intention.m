//
//	Intention.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "Intention.h"

@interface Intention ()
@end
@implementation Intention




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"IntentionID"] isKindOfClass:[NSNull class]]){
		self.intentionID = dictionary[@"IntentionID"];
	}	
	if(![dictionary[@"IntentionName"] isKindOfClass:[NSNull class]]){
		self.intentionName = dictionary[@"IntentionName"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.intentionID != nil){
		dictionary[@"IntentionID"] = self.intentionID;
	}
	if(self.intentionName != nil){
		dictionary[@"IntentionName"] = self.intentionName;
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
	if(self.intentionID != nil){
		[aCoder encodeObject:self.intentionID forKey:@"IntentionID"];
	}
	if(self.intentionName != nil){
		[aCoder encodeObject:self.intentionName forKey:@"IntentionName"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.intentionID = [aDecoder decodeObjectForKey:@"IntentionID"];
	self.intentionName = [aDecoder decodeObjectForKey:@"IntentionName"];
	return self;

}
@end