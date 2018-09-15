//
//  ZPProvinces.h
//  自定义生日键盘
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPProvinces : NSObject

@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSString *name;

+ (instancetype)provincesWithDict:(NSDictionary *)dict;

@end
