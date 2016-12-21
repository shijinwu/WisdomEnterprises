//
//  SplashViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()<UINavigationControllerDelegate, UIAlertViewDelegate>


@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(toLoginVC) userInfo:nil repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(toLoginVC) userInfo:nil repeats:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)toLoginVC
{
    NSDictionary* lastLoginAccount = [SDYAccountManager lastLoginAccount];
    if (lastLoginAccount && [lastLoginAccount[@"autoLogin"] boolValue]) {
        //do auto login
        __block NSArray* resultArray;
        __block SDYAccountLoginResult result;
        __block NSString* message;
        [self showProgressHUD:@"登录中" whileExecutingBlock:^{
            resultArray = [SDYAccountManager doLoginWithErrorCode:[lastLoginAccount objectForKey:@"phoneNumber"]
                                                         password:[lastLoginAccount objectForKey:@"password"]
                                                          pwdType:[lastLoginAccount objectForKey:@"pwdType"]];
            result = [resultArray[0] intValue];
            message = resultArray[1];
        } completionBlock:^{
            if (result == SDYAccountLoginResultSuccess) {
                [SDYAccountManager setCurrentAccountPhoneNumber:[lastLoginAccount objectForKey:@"phoneNumber"]];
                [SDYAccountManager setLastLoginAccount:[lastLoginAccount objectForKey:@"phoneNumber"]
                                               pwdType:[lastLoginAccount objectForKey:@"pwdType"]
                                              password:[lastLoginAccount objectForKey:@"password"]
                                             autoLogin:YES];
                //                [self showProgressHUD:@"正在更新配置" whileExecutingBlock:^{
                //                    [[SDYEnvironment environment] initAll];
                //                } completionBlock:^{
                [self performSegueWithIdentifier:@"S_ToHomepageVC" sender:self];
                //                }];
            }
            else if (result == SDYAccountLoginResultOldVersion) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:message delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //                [self guestLogin];
                [self performSegueWithIdentifier:@"S_ToHomepageVC" sender:self];
            }
        }];
    }
    else
    {
        //        [self guestLogin];
        [self performSegueWithIdentifier:@"S_ToHomepageVC" sender:self];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/tang-gang-zhi-hui-she-qu/id1071360206?mt=8"]];
}



@end
