//
//  User.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "User.h"

@implementation User

+(instancetype)userWithDictionary:(NSDictionary *)dic{
    
    User * u = [[self alloc]init];
    
    
    [u setValuesForKeysWithDictionary:dic];
    
    
    return u;
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

-(void)setNilValueForKey:(NSString *)key{
    
    
}
@end
