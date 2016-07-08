#import <UIKit/UIKit.h>

@interface NowNeed : NSObject

@property (nonatomic, strong) NSString * nowNeedID;
@property (nonatomic, strong) NSString * nowNeedName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end