#import <UIKit/UIKit.h>

@interface Intention : NSObject

@property (nonatomic, strong) NSString * intentionID;
@property (nonatomic, strong) NSString * intentionName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end