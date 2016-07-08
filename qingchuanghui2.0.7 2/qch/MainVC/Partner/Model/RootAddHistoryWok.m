//
//	RootClass.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "RootAddHistoryWok.h"

@interface RootAddHistoryWok ()
@end
@implementation RootAddHistoryWok




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"result"] != nil && [dictionary[@"result"] isKindOfClass:[NSArray class]]){
		NSArray * resultDictionaries = dictionary[@"result"];
		NSMutableArray * resultItems = [NSMutableArray array];
		for(NSDictionary * resultDictionary in resultDictionaries){
			AddHistoryWork * resultItem = [[AddHistoryWork alloc] initWithDictionary:resultDictionary];
			[resultItems addObject:resultItem];
		}
		self.result = resultItems;
	}
	if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[@"state"] boolValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.result != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(AddHistoryWork * resultElement in self.result){
			[dictionaryElements addObject:[resultElement toDictionary]];
		}
		dictionary[@"result"] = dictionaryElements;
	}
	dictionary[@"state"] = @(self.state);
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
	if(self.result != nil){
		[aCoder encodeObject:self.result forKey:@"result"];
	}
	[aCoder encodeObject:@(self.state) forKey:@"state"];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.result = [aDecoder decodeObjectForKey:@"result"];
	self.state = [[aDecoder decodeObjectForKey:@"state"] boolValue];
	return self;

}
@end