//
//	Topic.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PartnerTopic.h"

@interface PartnerTopic ()
@end
@implementation PartnerTopic




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"Guid"] isKindOfClass:[NSNull class]]){
		self.guid = dictionary[@"Guid"];
	}	
	if(dictionary[@"pic"] != nil && [dictionary[@"pic"] isKindOfClass:[NSArray class]]){
		NSArray * picDictionaries = dictionary[@"pic"];
		NSMutableArray * picItems = [NSMutableArray array];
		for(NSDictionary * picDictionary in picDictionaries){
			PartnerPic * picItem = [[PartnerPic alloc] initWithDictionary:picDictionary];
			[picItems addObject:picItem];
		}
		self.pic = picItems;
	}
	if(![dictionary[@"t_Date"] isKindOfClass:[NSNull class]]){
		self.tDate = dictionary[@"t_Date"];
	}	
	if(![dictionary[@"t_Topic_Address"] isKindOfClass:[NSNull class]]){
		self.tTopicAddress = dictionary[@"t_Topic_Address"];
	}	
	if(![dictionary[@"t_Topic_City"] isKindOfClass:[NSNull class]]){
		self.tTopicCity = dictionary[@"t_Topic_City"];
	}	
	if(![dictionary[@"t_Topic_Contents"] isKindOfClass:[NSNull class]]){
		self.tTopicContents = [dictionary[@"t_Topic_Contents"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.guid != nil){
		dictionary[@"Guid"] = self.guid;
	}
	if(self.pic != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(PartnerPic * picElement in self.pic){
			[dictionaryElements addObject:[picElement toDictionary]];
		}
		dictionary[@"pic"] = dictionaryElements;
	}
	if(self.tDate != nil){
		dictionary[@"t_Date"] = self.tDate;
	}
	if(self.tTopicAddress != nil){
		dictionary[@"t_Topic_Address"] = self.tTopicAddress;
	}
	if(self.tTopicCity != nil){
		dictionary[@"t_Topic_City"] = self.tTopicCity;
	}
	if(self.tTopicContents != nil){
		dictionary[@"t_Topic_Contents"] = self.tTopicContents;
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
	if(self.guid != nil){
		[aCoder encodeObject:self.guid forKey:@"Guid"];
	}
	if(self.pic != nil){
		[aCoder encodeObject:self.pic forKey:@"pic"];
	}
	if(self.tDate != nil){
		[aCoder encodeObject:self.tDate forKey:@"t_Date"];
	}
	if(self.tTopicAddress != nil){
		[aCoder encodeObject:self.tTopicAddress forKey:@"t_Topic_Address"];
	}
	if(self.tTopicCity != nil){
		[aCoder encodeObject:self.tTopicCity forKey:@"t_Topic_City"];
	}
	if(self.tTopicContents != nil){
		[aCoder encodeObject:self.tTopicContents forKey:@"t_Topic_Contents"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.guid = [aDecoder decodeObjectForKey:@"Guid"];
	self.pic = [aDecoder decodeObjectForKey:@"pic"];
	self.tDate = [aDecoder decodeObjectForKey:@"t_Date"];
	self.tTopicAddress = [aDecoder decodeObjectForKey:@"t_Topic_Address"];
	self.tTopicCity = [aDecoder decodeObjectForKey:@"t_Topic_City"];
	self.tTopicContents = [aDecoder decodeObjectForKey:@"t_Topic_Contents"];
	return self;

}
@end