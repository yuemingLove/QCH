//
//	UserProject.m
//
//	Create by 创汇 青 on 23/2/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "UserProject.h"

@interface UserProject ()
@end
@implementation UserProject




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"Guid"] isKindOfClass:[NSNull class]]){
		self.guid = dictionary[@"Guid"];
	}	
	if(![dictionary[@"ProjectName"] isKindOfClass:[NSNull class]]){
		self.projectName = dictionary[@"ProjectName"];
	}	
	if(![dictionary[@"t_Project_ConverPic"] isKindOfClass:[NSNull class]]){
		self.tProjectConverPic = dictionary[@"t_Project_ConverPic"];
	}
    if(![dictionary[@"t_Project_OneWord"] isKindOfClass:[NSNull class]]){
        self.tProjectOneWord = dictionary[@"t_Project_OneWord"];
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
	if(self.projectName != nil){
		dictionary[@"ProjectName"] = self.projectName;
	}
	if(self.tProjectConverPic != nil){
		dictionary[@"t_Project_ConverPic"] = self.tProjectConverPic;
	}
    if(self.tProjectOneWord != nil){
        dictionary[@"t_Project_OneWord"] = self.tProjectOneWord;
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
	if(self.projectName != nil){
		[aCoder encodeObject:self.projectName forKey:@"ProjectName"];
	}
	if(self.tProjectConverPic != nil){
		[aCoder encodeObject:self.tProjectConverPic forKey:@"t_Project_ConverPic"];
	}
    if(self.tProjectOneWord != nil){
        [aCoder encodeObject:self.tProjectOneWord forKey:@"t_Project_OneWord"];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.guid = [aDecoder decodeObjectForKey:@"Guid"];
	self.projectName = [aDecoder decodeObjectForKey:@"ProjectName"];
	self.tProjectConverPic = [aDecoder decodeObjectForKey:@"t_Project_ConverPic"];
    self.tProjectOneWord = [aDecoder decodeObjectForKey:@"t_Project_OneWord"];
	return self;

}
@end