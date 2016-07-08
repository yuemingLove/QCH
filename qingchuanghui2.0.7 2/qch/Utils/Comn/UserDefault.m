//
//  UserDefault.m
//  Jyg
//
//  Created by 苏宾 on 15/12/24.
//  Copyright © 2015年 wubing. All rights reserved.
//
#define SetUserDefault(key,Value)       [[NSUserDefaults standardUserDefaults] setValue:Value forKey:key];
#define GetUserDefaultValue(key)        [[NSUserDefaults standardUserDefaults] valueForKey:key];
#define RemoveUserDefault(key)          [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];


#import "UserDefault.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>


static UserDefault *_instance = nil;

@implementation UserDefault

+ (UserDefault *)currentDefault{
    @synchronized(self){
        if (_instance == nil)
        {
            _instance = [[UserDefault alloc] init];
            [_instance getUserDefault];
        }
    }
    return _instance;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (!_instance) {
            _instance = [super allocWithZone:zone]; //确保使用同一块内存地址
            [_instance getUserDefault];
            return _instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone;{
    return self; //确保copy对象也是唯一
}

-(void)getUserDefault{
    @synchronized(self){
        unsigned int propCount=0;
        objc_property_t *properties = class_copyPropertyList([UserDefault class], &propCount);
        for (int j =0 ; j < propCount ;j++) {
            objc_property_t property = properties[j];
            if (property==NULL) {
                break;
            }
            const char *propName = property_getName(property);
            NSString *name = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            const char *propType = getPropertyType(property);
            NSString *type = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
            if ([type isEqualToString:@"NSString"]) {
                NSString *value = GetUserDefaultValue(name);
                [self setValue:value forKey:name];
            }
        }
        free(properties);
    }
}

static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            char *attributeTemp=(char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute)] bytes];
            char *p = strtok(attributeTemp, "\"");
            if(p)
            {
                return (const char*)p;
            }
            p = strtok(NULL, "\"");
            if(p)
                return  (const char*)p;
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            char *attributeTemp=(char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute)] bytes];
            char *p = strtok(attributeTemp, "\"");
            if(p)
            {
                return (const char*)p;
            }
            p = strtok(NULL, "\"");
            if(p)
                return  (const char*)p;
        }
        return nil;
    }
    return nil;
}


+(void)saveUserDefault{
    @synchronized(self){
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([UserDefault class], &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            SEL selector = NSSelectorFromString(name);
            const char *propType = getPropertyType(property);
            NSString *type = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
            if ([type isEqualToString:@"NSString"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                NSString *value = (NSString *)[UserDefaultEntity performSelector:selector];
#pragma clang diagnostic pop
                if (value && ![value isKindOfClass:[NSNull class]]) {
                    [[NSUserDefaults standardUserDefaults] setValue:value forKey:name];
                    //NSLog(@"键：%@, 值： %@",name,value);
                }else{
                    RemoveUserDefault(name);
                }
            }
            
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

+(BOOL)saveObject:(id)object key:(NSString *)strKey{
    if (![object respondsToSelector:@selector(initWithCoder:)]) {
        return NO;
    }
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:udObject forKey:strKey];
    [ud synchronize];
    return YES;
}

+(id)getObject:(NSString *)strKey{
    NSObject *object = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [ud objectForKey:strKey];
    if (udObject) {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
        return object;
    } else {
        return nil;
    }
}


@end
