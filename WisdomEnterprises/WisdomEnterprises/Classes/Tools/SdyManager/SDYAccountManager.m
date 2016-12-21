//
//  SDYAccountManager.m
//  sdy
//
//  Created by Bode Smile on 14-9-8.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYAccountManager.h"
#import "JNKeychain.h"
#import "SDYHTTPManager.h"
#import "SDYSecurityManager.h"
#import "SDYEnvironment.h"

#define Key_LastLoginAccount @"lastLoginAccount"
#define Key_AllAccount @"allAccount"

BOOL currentAccountAutoLogin;
NSString* currentAccountPhoneNumber;
SDYUserInfo* currentUser;
NSString* pushUserID;
SDYCommunityInfo* communityInfo;

@implementation SDYAccountManager

+(BOOL)isNeedWelcomeVC{
    NSNumber* lastversion = [JNKeychain loadValueForKey:Key_WelcomeVersion];
    if(!lastversion || ![lastversion isKindOfClass:[NSNumber class]])
        return YES;
    if([lastversion intValue]<[Value_WelcomeVersion intValue])
        return YES;
    return NO;
}

+(void)skipCurrentWelcomeVC{
    [JNKeychain saveValue:Value_WelcomeVersion forKey:Key_WelcomeVersion];
}

+(BOOL)currentAccountAutoLogin{
    return currentAccountAutoLogin;
}

+(void)setCurrentAccountAutoLogin:(BOOL)autoLogin{
    currentAccountAutoLogin = autoLogin;
}

+(NSString*)currentAccountPhoneNumber{
    return currentAccountPhoneNumber;
}

+(void)setCurrentAccountPhoneNumber:(NSString*)currentPhoneNumber{
    currentAccountPhoneNumber = currentPhoneNumber;
}

+(NSString*)pushUserID{
    return pushUserID;
}

+(void)setPushUserID:(NSString*)userid{
    pushUserID = userid;
}

+(NSDictionary*)lastLoginAccount
{
    return [JNKeychain loadValueForKey:Key_LastLoginAccount];
}

+(BOOL)isFirstTimeLogin:(NSString*)phoneNumber{
    //FOR TEST
    if([phoneNumber isEqualToString:TEST_USER])
        return NO;
    
    NSArray* allAccount = [self allAccount];
    
    
    if(allAccount){
        for (NSString* account in allAccount) {
            if([account isEqualToString:phoneNumber])
                return NO;
        }
    }
    return YES;
}

+(void)setIsFirstTimeLogin:(NSString*)phoneNumber firstTime:(BOOL)firstTime{
    BOOL isFirstTimeLogin = [self isFirstTimeLogin:phoneNumber];
    if (isFirstTimeLogin !=firstTime) {
        if(isFirstTimeLogin){
            NSMutableArray* allAccount = [[NSMutableArray alloc] initWithArray:[self allAccount]];
            [allAccount addObject:phoneNumber];
            [JNKeychain saveValue:allAccount forKey:Key_AllAccount];
        }
        else{
            NSMutableArray* allAccount = [[NSMutableArray alloc] initWithArray:[self allAccount]];
            if(allAccount){
                for (NSString* account in allAccount) {
                    if([account isEqualToString:phoneNumber]){
                        [allAccount removeObject:account];
                        break;
                    }
                }
            }
            [JNKeychain saveValue:allAccount forKey:Key_AllAccount];
        }
    }
}

+(void)setLastLoginAccount:(NSString*)phoneNumber pwdType:(NSString*)pwdType password:(NSString*)password autoLogin:(BOOL)autoLogin{
    if(!phoneNumber || phoneNumber.length<10 || [phoneNumber rangeOfString:@" "].length>0)
        return;
    NSDictionary* lastLogin = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phoneNumber",password,@"password",pwdType,@"pwdType",[NSNumber numberWithBool:autoLogin],@"autoLogin", nil];
    [JNKeychain saveValue:lastLogin forKey:Key_LastLoginAccount];
    if ([self isFirstTimeLogin:phoneNumber]) {
        NSMutableArray* allAccount = [[NSMutableArray alloc] initWithArray:[self allAccount]];
        [allAccount addObject:phoneNumber];
        [JNKeychain saveValue:allAccount forKey:Key_AllAccount];
    }
}

+(NSArray*)allAccount{
    return [JNKeychain loadValueForKey:Key_AllAccount];
}

+(SDYUserInfo*)currentUser
{
    return currentUser;
}

+(void)setCurrentUser:(SDYUserInfo*)user{
    currentUser = user;
}

+(NSString*)exUserID{
    return pushUserID;
}

+(NSArray*)doLoginWithErrorCode:(NSString*)phoneNumber password:(NSString*)password pwdType:(NSString*)pwdType {
    
    if ([phoneNumber isEqualToString:TEST_USER]) {
        [SDYHTTPManager setDebugMode:YES];
    }
    
    NSDictionary* data;
    
    data = [SDYHTTPManager oauth_pwdKey];
    if (!data || ![data[@"errorCode"] isEqualToString:@"00000000"]) {
        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed], data[@"errorMsg"]];
    }
    
    NSString* key = [data objectForKey:@"pwdKey"];
//    data = [SDYHTTPManager oauth_authorize:@{@"user":phoneNumber,@"pwd":[[SDYSecurityManager defaultManager] encrypt:password keyString:key],@"pwdType":pwdType}];
//    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
//        //登录用户名密码错误
//        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed],[data objectForKey:@"errorMsg"]];
//    }
//    NSString* code = [data objectForKey:@"code"];
//    data = [SDYHTTPManager oauth_accessToken:code exUserId:pushUserID];
//    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
//        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed],[data objectForKey:@"errorMsg"]];
//    }

    data = [SDYHTTPManager oauth_login:@{
                                         @"user":phoneNumber,
                                         @"pwd":[[SDYSecurityManager defaultManager] encrypt:password keyString:key],
                                         @"pwdType":pwdType,
                                         @"device":@"2",
                                         @"vsn":[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]
                                         }];
    if (!data || ![data[@"errorCode"] isEqualToString:@"00000000"]) {
        //登录用户名密码错误
        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed], data[@"errorMsg"]];
    }
    /*
     如果当前设备的版本号没有在数据库里，后台只会把IOS应用或是Android的应用的下载地址给我
     但是upind的标志位不会给我
     */
//    NSString* dataVersion = [data objectForKey:@"dataVersion"];
    NSString* newvsn = [data objectForKey:@"newvsn"];
    NSString* upInd = [data objectForKey:@"upInd"];
    if (upInd && [upInd isEqualToString:@"Y"])
    {
        return @[[NSNumber numberWithInt:SDYAccountLoginResultOldVersion],
                 [NSString stringWithFormat:@"您使用的版本太旧，需要更新到最新版本：%@",newvsn]];
    }
//    NSString* upUrl  = [data objectForKey:@"upUrl "];
    NSString* token = [data objectForKey:@"accessToken"];
    NSString* refreshToken = [data objectForKey:@"refreshToken"];
    NSArray* scope = [data objectForKey:@"scope"];
    
    SDYUserInfo* user = [[SDYUserInfo alloc] init];
    user.token = token;
    user.refreshToken = refreshToken;
    user.scope = [[NSDictionary alloc] initWithObjects:scope forKeys:scope];
    currentUser = user;
    
    data = [SDYHTTPManager api_queryUserInfo:token withInfo:@{@"userId":phoneNumber}];
    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed],[data objectForKey:@"errorMsg"]];
    }
    NSDictionary* userInfo = [data objectForKey:@"user"];
    user.userId = [userInfo objectForKey:@"userId"];
    user.payPwdSetInd = [data objectForKey:@"payPwdSetInd"];
    user.user = [[[NSDictionary alloc] initWithDictionary:[data objectForKey:@"user"]] mutableCopy];
    user.customer = [[NSDictionary alloc] initWithDictionary:[data objectForKey:@"customer"]];
    NSArray* interestInfoList = data[@"interestInfoList"];
    NSMutableArray* interestInfoListClear = [[NSMutableArray alloc] init];
    
    if ([interestInfoList count] > 0) {
        for (NSDictionary* iiInfo in interestInfoList) {
            [interestInfoListClear addObject:iiInfo[@"id"]];
        }
    }
    user.interestInfoList = interestInfoListClear;

    //额外的登录信息：比如用户地址列表等
//    data = [SDYHTTPManager api_queryAddrInfos:token withInfo:@{@"userId":phoneNumber}];
//    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
//        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed],[data objectForKey:@"errorMsg"]];
//    }
    // 替换掉未登录状态下的小区信息
    if (communityInfo) {
        communityInfo = nil;
    }
    
    [currentUser setAddrInfos:[data objectForKey:@"addrInfos"]
               andCommunities:[data objectForKey:@"communitys"]];
    
    if([currentUser.commInfos  isEqual: @{}]){
        
    NSData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"commData"];
        
     communityInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    }
    
    //开始下载用户头像
    NSString* filePath = [[SDYEnvironment environment] userIconPath:phoneNumber];
    [SDYHTTPManager file_download:token attachType:@"A" idKey:phoneNumber filePath:filePath];
    
    return @[[NSNumber numberWithInt:SDYAccountLoginResultSuccess],@""];
}

+(void)refreshUserInfo{
    NSDictionary* data;
    data = [SDYHTTPManager api_queryUserInfo:currentUser.token withInfo:@{@"userId":currentUser.userId}];
    if(data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        currentUser.user = [NSMutableDictionary dictionaryWithDictionary:data[@"user"]];
        currentUser.customer = [NSDictionary dictionaryWithDictionary:data[@"customer"]];
        NSArray* interestInfoList = data[@"interestInfoList"];
        NSMutableArray* interestInfoListClear = [[NSMutableArray alloc] init];
        if([interestInfoList count]>0){
            for (NSDictionary* iiInfo in interestInfoList) {
                [interestInfoListClear addObject:iiInfo[@"id"]];
            }
        }
        currentUser.interestInfoList = interestInfoListClear;
    }
}

+(void)adminUserInfo{
    NSDictionary* data;
    data = [SDYHTTPManager api_queryqueryEstateEmp:currentUser.token withInfo:@{@"customerId":currentUser.customer[@"customerId"]}];
    if(data && [[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        currentUser.estateEmp = [[NSDictionary alloc] initWithDictionary:[data objectForKey:@"estateEmp"]];
    }
}

+(BOOL)refreshToken{
    NSDictionary* data;
    data = [SDYHTTPManager oauth_refreshToken:[SDYAccountManager currentUser].refreshToken exUserId:pushUserID];
    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        return NO;
    }
    [SDYAccountManager currentUser].token = [data objectForKey:@"accessToken"];
    [SDYAccountManager currentUser].refreshToken = [data objectForKey:@"refreshToken"];
    [SDYAccountManager currentUser].scope = [[NSDictionary alloc] initWithObjects:[data objectForKey:@"scope"] forKeys:[data objectForKey:@"scope"]];
    return YES;
}

+(NSArray*)changePassword:(NSString*)password type:(NSString*)type{
    NSDictionary* data;
    data = [SDYHTTPManager oauth_pwdKey];
    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        return @[[NSNumber numberWithInt:SDYAccountLoginResultSeriveError],[data objectForKey:@"errorMsg"]];
    }
    NSString* key = [data objectForKey:@"pwdKey"];
    data = [SDYHTTPManager api_userPwdSet:currentUser.token withInfo:@{@"userId":currentUser.userId,@"pwdType":type,@"password":[[SDYSecurityManager defaultManager] encrypt:password keyString:key]}];
    if(!data || ![[data objectForKey:@"errorCode"] isEqualToString:@"00000000"]){
        //修改密码错误
        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed],[data objectForKey:@"errorMsg"]];
    }
    //  if([SDYAccountManager currentUser] && [SDYAccountManager currentUser].user)
    //    [SDYAccountManager currentUser].user[@"queryPwdType"] = type;
    return @[[NSNumber numberWithInt:SDYAccountLoginResultSuccess],@""];
}

+(NSArray*)changePayPassword:(NSString*)password
                 oldPassword:(NSString*)old
                  noPassword:(BOOL)nopassword
                     touchID:(BOOL)touchID {
    NSDictionary* data;
    data = [[SDYHTTPManager oauth_pwdKey] mutableCopy];
    
    if (!data || ![data[@"errorCode"] isEqualToString:@"00000000"]) {
        return @[[NSNumber numberWithInt:SDYAccountLoginResultSeriveError], data[@"errorMsg"]];
    }
    
    NSString* key = data[@"pwdKey"];
    NSString* encryptedOldPwd = [[SDYSecurityManager defaultManager] encrypt:old keyString:key];
    NSString* encryptedNewPwd;
    NSDictionary* info;
    
    if (password && password.length > 0) {
        encryptedNewPwd = [[SDYSecurityManager defaultManager] encrypt:password keyString:key];
    }
    else {
        encryptedNewPwd = encryptedOldPwd;
    }
    
    info = @{
             @"updateInd": old ? @"Y" : @"N",
             @"oldPwd": old ? encryptedOldPwd : @"",
             @"payPwdInd": nopassword ? @"Y" : @"N",
             @"password": encryptedNewPwd,
             };
    
    data = [SDYHTTPManager api_payPwdSet:currentUser.token withInfo:info];
    
    if (!data || ![data[@"errorCode"] isEqualToString:@"00000000"]) {
        //修改密码错误
        return @[[NSNumber numberWithInt:SDYAccountLoginResultFailed], data[@"errorMsg"]];
    }
    
    return @[[NSNumber numberWithInt:SDYAccountLoginResultSuccess], @""];
}

+(BOOL)isCurrentAdmin{
    return (currentUser && currentUser.scope && ([currentUser.scope objectForKey:@"C000011"] || [currentUser.scope objectForKey:@"C000012"] || [currentUser.scope objectForKey:@"C000013"] || [currentUser.scope objectForKey:@"C000018"] || [currentUser.scope objectForKey:@"C000015"] || [currentUser.scope objectForKey:@"C000004"]));
}

+(BOOL)isCurrentGuest{
    return (currentUser && [currentUser.userId isEqualToString:DEFAULT_USER]);
}

+(void)setCurrentCommunityInfo:(SDYCommunityInfo*)info{
    communityInfo = info;
}

+ (SDYCommunityInfo*)currentCommunityInfo {
    
    if (!communityInfo/* && [currentUser getDefaultCommCode] && [[currentUser getDefaultCommCode] length]>0*/){
        if (currentUser) {
            SDYCommunityInfo* defaultInfo = [currentUser getDefaultCommInfo];
            if (defaultInfo) {
                communityInfo = defaultInfo;
            }
            else {
                [self loadCommunityInfoWithCommunityCode:[currentUser getDefaultCommCode]];
            }
        }
        else {
            return nil;
        }
    }
    return communityInfo;
}

+ (BOOL)loadCommunityInfoWithCommunityCode:(NSString*)commCode {
    if (!commCode || [commCode isEqualToString:@""]) {
        return NO;
    }
    if(!communityInfo){
        communityInfo = [[SDYCommunityInfo alloc] init];
    }
    return [communityInfo loadWithCommunityCode:commCode];
}

+ (void)logout {
    currentUser = nil;
    communityInfo = nil;
}

@end
