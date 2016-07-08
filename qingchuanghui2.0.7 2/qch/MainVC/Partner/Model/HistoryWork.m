//
//	HistoryWork.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HistoryWork.h"

@interface HistoryWork ()
@end
@implementation HistoryWork




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"Guid"] isKindOfClass:[NSNull class]]){
		self.guid = dictionary[@"Guid"];
	}	
	if(![dictionary[@"t_Commpany"] isKindOfClass:[NSNull class]]){
		self.tCommpany = dictionary[@"t_Commpany"];
	}	
	if(![dictionary[@"t_Position"] isKindOfClass:[NSNull class]]){
		self.tPosition = dictionary[@"t_Position"];
	}	
	if(![dictionary[@"t_User_Guid"] isKindOfClass:[NSNull class]]){
		self.tUserGuid = dictionary[@"t_User_Guid"];
	}	
	if(![dictionary[@"t_eDate"] isKindOfClass:[NSNull class]]){
		self.tEDate = dictionary[@"t_eDate"];
	}	
	if(![dictionary[@"t_sDate"] isKindOfClass:[NSNull class]]){
		self.tSDate = dictionary[@"t_sDate"];
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
	if(self.tCommpany != nil){
		dictionary[@"t_Commpany"] = self.tCommpany;
	}
	if(self.tPosition != nil){
		dictionary[@"t_Position"] = self.tPosition;
	}
	if(self.tUserGuid != nil){
		dictionary[@"t_User_Guid"] = self.tUserGuid;
	}
	if(self.tEDate != nil){
		dictionary[@"t_eDate"] = self.tEDate;
	}
	if(self.tSDate != nil){
		dictionary[@"t_sDate"] = self.tSDate;
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
	if(self.tCommpany != nil){
		[aCoder encodeObject:self.tCommpany forKey:@"t_Commpany"];
	}
	if(self.tPosition != nil){
		[aCoder encodeObject:self.tPosition forKey:@"t_Position"];
	}
	if(self.tUserGuid != nil){
		[aCoder encodeObject:self.tUserGuid forKey:@"t_User_Guid"];
	}
	if(self.tEDate != nil){
		[aCoder encodeObject:self.tEDate forKey:@"t_eDate"];
	}
	if(self.tSDate != nil){
		[aCoder encodeObject:self.tSDate forKey:@"t_sDate"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.guid = [aDecoder decodeObjectForKey:@"Guid"];
	self.tCommpany = [aDecoder decodeObjectForKey:@"t_Commpany"];
	self.tPosition = [aDecoder decodeObjectForKey:@"t_Position"];
	self.tUserGuid = [aDecoder decodeObjectForKey:@"t_User_Guid"];
	self.tEDate = [aDecoder decodeObjectForKey:@"t_eDate"];
	self.tSDate = [aDecoder decodeObjectForKey:@"t_sDate"];
	return self;

}
@end