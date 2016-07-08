//
//	Pic.m
//
//	Create by 创汇 青 on 20/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PartnerPic.h"

@interface PartnerPic ()
@end
@implementation PartnerPic




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"t_Pic_Remark"] isKindOfClass:[NSNull class]]){
		self.tPicRemark = dictionary[@"t_Pic_Remark"];
	}	
	if(![dictionary[@"t_Pic_Url"] isKindOfClass:[NSNull class]]){
		self.tPicUrl = dictionary[@"t_Pic_Url"];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.tPicRemark != nil){
		dictionary[@"t_Pic_Remark"] = self.tPicRemark;
	}
	if(self.tPicUrl != nil){
		dictionary[@"t_Pic_Url"] = self.tPicUrl;
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
	if(self.tPicRemark != nil){
		[aCoder encodeObject:self.tPicRemark forKey:@"t_Pic_Remark"];
	}
	if(self.tPicUrl != nil){
		[aCoder encodeObject:self.tPicUrl forKey:@"t_Pic_Url"];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.tPicRemark = [aDecoder decodeObjectForKey:@"t_Pic_Remark"];
	self.tPicUrl = [aDecoder decodeObjectForKey:@"t_Pic_Url"];
	return self;

}
@end