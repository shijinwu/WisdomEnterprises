//
//  InfoManager.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "InfoManager.h"

@implementation InfoManager

+(instancetype)shareManager
{
    static InfoManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[InfoManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [[User alloc]init];
    }
    return self;
}

@end
