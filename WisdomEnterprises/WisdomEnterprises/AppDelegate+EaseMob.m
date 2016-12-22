/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegate+EaseMob.h"
#import "WXNavigationViewController.h"


#import "LoginViewController.h"
#import "ChatDemoHelper.h"
#import "MBProgressHUD.h"
#import "EaseUI.h"
#import "EMCommonDefs.h"
/**
 *  本类中做了EaseMob初始化和推送等操作
 */

@implementation AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
              apnsCertName:(NSString *)apnsCertName
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                    didFinishLaunchingWithOptions:launchOptions
                                           appkey:appkey
                                     apnsCertName:apnsCertName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [ChatDemoHelper shareHelper];
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    if (isAutoLogin){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
     WXNavigationViewController*navigationController = nil;
    if (loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
       // [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        if (self.mainController == nil) {
            self.mainController = [[MainViewController alloc] init];
            navigationController = [[WXNavigationViewController alloc] initWithRootViewController:self.mainController];
        }else{
            navigationController  = (WXNavigationViewController *)self.mainController.navigationController;
        }
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处
       // [self initParse];
        
        [ChatDemoHelper shareHelper].mainVC = self.mainController;
        
        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
        [[ChatDemoHelper shareHelper] asyncPushOptions];
    }
    else{//登陆失败加载登陆页面控制器
        if (self.mainController) {
            [self.mainController.navigationController popToRootViewControllerAnimated:NO];
        }
        self.mainController = nil;
        [ChatDemoHelper shareHelper].mainVC = nil;
        
        
        UIStoryboard * s = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        
        LoginViewController *loginController =[s instantiateInitialViewController];
        navigationController = [[WXNavigationViewController alloc] initWithRootViewController:loginController];
       // [self clearParse];
    }
    
    //设置7.0以下的导航栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
                                                 forBarMetrics:UIBarMetricsDefault];
        [navigationController.navigationBar.layer setMasksToBounds:YES];
    }
    
    navigationController.navigationBar.accessibilityIdentifier = @"navigationbar";
    self.window.rootViewController = navigationController;
}

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}

//-(BOOL)isSpecifyServer{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    
//    NSNumber *specifyServer = [ud objectForKey:@"identifier_enable"];
//    if ([specifyServer boolValue]) {
//        NSString *apnsCertName = nil;
//#if DEBUG
//        apnsCertName = @"chatdemoui_dev";
//#else
//        apnsCertName = @"chatdemoui";
//#endif
//        NSString *appkey = [ud stringForKey:@"identifier_appkey"];
//        if (!appkey)
//        {
//            appkey = @"easemob-demo#no1";
//            [ud setObject:appkey forKey:@"identifier_appkey"];
//        }
//        NSString *imServer = [ud stringForKey:@"identifier_imserver"];
//        if (!imServer)
//        {
//            imServer = @"120.26.12.158";
//            [ud setObject:imServer forKey:@"identifier_imserver"];
//        }
//        NSString *imPort = [ud stringForKey:@"identifier_import"];
//        if (!imPort)
//        {
//            imPort = @"6717";
//            [ud setObject:imPort forKey:@"identifier_import"];
//        }
//        NSString *restServer = [ud stringForKey:@"identifier_restserver"];
//        if (!restServer)
//        {
//            restServer = @"42.121.255.137";
//            [ud setObject:restServer forKey:@"identifier_restserver"];
//        }
//        [ud synchronize];
//        
//        EMOptions *options = [EMOptions optionsWithAppkey:appkey];
//        if (![ud boolForKey:@"enable_dns"])
//        {
//            options.enableDnsConfig = NO;
//            options.chatPort = [[ud stringForKey:@"identifier_import"] intValue];
//            options.chatServer = [ud stringForKey:@"identifier_imserver"];
//            options.restServer = [ud stringForKey:@"identifier_restserver"];
//        }
//        //    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
//        options.apnsCertName = @"chatdemoui_dev";
//        options.enableConsoleLog = YES;
//        
//        [[EMClient sharedClient] initializeSDKWithOptions:options];
//        return YES;
//    }
//    
//    return NO;
//}
//

@end
