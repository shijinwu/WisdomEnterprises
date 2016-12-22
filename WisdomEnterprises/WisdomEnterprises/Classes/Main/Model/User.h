//
//  User.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,copy)NSString * nickName;

@property (nonatomic,copy)NSString * name;

@property (nonatomic,copy)NSString * tel;

@property (nonatomic,copy)NSString * gender;

@property (nonatomic,copy)NSString * hobby;

@property (nonatomic,copy)NSString * imageUrl;

+(instancetype)userWithDictionary:(NSDictionary *)dic;

@end
