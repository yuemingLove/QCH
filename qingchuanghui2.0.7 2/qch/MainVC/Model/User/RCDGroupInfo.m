//
//  RCDGroupInfo.m
//  qch
//
//  Created by 苏宾 on 16/1/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RCDGroupInfo.h"

@implementation RCDGroupInfo
#define KEY_RCDGROUP_INFO_NUMBER @"number"

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        if (decoder == nil) {
            return self;
        }
        //
        self.number = [decoder decodeObjectForKey:KEY_RCDGROUP_INFO_NUMBER];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.number forKey:KEY_RCDGROUP_INFO_NUMBER];
}


@end
