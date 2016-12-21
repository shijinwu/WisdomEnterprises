//
//  EaseManager.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseUI.h"
@interface EaseManager : NSObject

+(instancetype)shareManager;

-(void)loginWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void(^)(EMError *error))completionHandler;

-(void)getDBDatacompletionHandler:(void(^)())completionHandler;

@end
