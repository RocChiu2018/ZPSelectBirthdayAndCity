//
//  ZPProvinces.m
//  自定义生日键盘
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZPProvinces.h"

@implementation ZPProvinces

+ (instancetype)provincesWithDict:(NSDictionary *)dict
{
    ZPProvinces *province = [[self alloc] init];
    
    [province setValuesForKeysWithDictionary:dict];
    
    return province;
}

@end
