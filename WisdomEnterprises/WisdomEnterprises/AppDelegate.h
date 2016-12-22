//
//  AppDelegate.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "EaseUI.h"
@protocol PaymentDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIViewController *homeViewController;
@property (weak, nonatomic) UIViewController<PaymentDelegate>* toBePaidViewController;


@property (strong,nonatomic)MainViewController * mainController;

@end

@protocol PaymentDelegate <NSObject>

- (void)didFinishPayment;

@end
