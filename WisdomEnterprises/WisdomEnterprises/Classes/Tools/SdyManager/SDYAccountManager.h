//
//  SDYAccountManager.h
//  sdy
//
//  Created by Bode Smile on 14-9-8.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDYUserInfo.h"
#import "SDYCommunityInfo.h"

typedef enum
{
  SDYAccountLoginResultSuccess,
  SDYAccountLoginResultSeriveError,
  SDYAccountLoginResultFailed,
  SDYAccountLoginResultNeedPassword,
  SDYAccountLoginResultOldVersion,
}SDYAccountLoginResult;

#define DEFAULT_USER @"GUEST"
#define DEFAULT_PASSWORD @"000000"
#define DEFAULT_COUNT 20
//当使用这个用户时，不用短信验证，供上线审核用
#define TEST_USER @"18907124406"

#define _CustomerId ([SDYAccountManager currentUser].customer[@"customerId"])
#define _UserId ([SDYAccountManager currentUser].userId)
#define _UserName ([SDYAccountManager currentUser].customer[@"customerName"])
#define _UserNickName ([SDYAccountManager currentUser].user[@"nickName"])
#define _UserPhone ([SDYAccountManager currentUser].customer[@"smsMobileNo"])
#define _TOKEN ([[SDYAccountManager currentUser] token])

@interface SDYAccountManager : NSObject

+(BOOL)isNeedWelcomeVC;
+(void)skipCurrentWelcomeVC;

+(BOOL)currentAccountAutoLogin;
+(void)setCurrentAccountAutoLogin:(BOOL)autoLogin;

+(NSString*)currentAccountPhoneNumber;
+(void)setCurrentAccountPhoneNumber:(NSString*)currentPhoneNumber;

+(NSString*)pushUserID;
+(void)setPushUserID:(NSString*)userid;

+(NSDictionary*)lastLoginAccount;

+(BOOL)isFirstTimeLogin:(NSString*)phoneNumber;
+(void)setIsFirstTimeLogin:(NSString*)phoneNumber firstTime:(BOOL)firstTime;

+(void)setLastLoginAccount:(NSString*)phoneNumber pwdType:(NSString*)pwdType password:(NSString*)password autoLogin:(BOOL)autoLogin;

+(NSArray*)allAccount;

+(SDYUserInfo*)currentUser;
+(void)setCurrentUser:(SDYUserInfo*)user;
+(NSArray*)doLoginWithErrorCode:(NSString*)phoneNumber password:(NSString*)password pwdType:(NSString*)pwdType;
+(void)refreshUserInfo;
+(void)adminUserInfo;
+(BOOL)refreshToken;
+(NSArray*)changePassword:(NSString*)password type:(NSString*)type;
+(NSArray*)changePayPassword:(NSString*)password oldPassword:(NSString*)old noPassword:(BOOL)nopassword touchID:(BOOL)touchID;

+(BOOL)isCurrentAdmin;
+(BOOL)isCurrentGuest;

+(void)setCurrentCommunityInfo:(SDYCommunityInfo*)info;
+(SDYCommunityInfo*)currentCommunityInfo;
+(BOOL)loadCommunityInfoWithCommunityCode:(NSString*)commCode;

+ (void)logout;
@end
