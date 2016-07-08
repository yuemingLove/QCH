//
//  OrderModel.m
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    self.nu = value;
}


@end
