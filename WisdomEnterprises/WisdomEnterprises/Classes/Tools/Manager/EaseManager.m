//
//  EaseManager.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EaseManager.h"

@implementation EaseManager


+(instancetype)shareManager
{
    static EaseManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[EaseManager alloc]init];
    });
    
    return manager;
    
}

-(void)loginWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void(^)(EMError *error))completionHandler{
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
     EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(error);
            if (!error) {
            
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
            }
            
        });
    });
    
    
}

-(void)getDBDatacompletionHandler:(void(^)())completionHandler{
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] migrateDatabaseToLatestSDK];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[ChatDemoHelper shareHelper] asyncGroupFromServer];
//            [[ChatDemoHelper shareHelper] asyncConversationFromDB];
//            [[ChatDemoHelper shareHelper] asyncPushOptions];
            
            completionHandler();
            
            //保存最近一次登录用户名
            [weakself saveLastLoginUsername];
        });
    });
    

    
    
    
}


#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

@end
