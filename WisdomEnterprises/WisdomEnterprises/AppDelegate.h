//
//  AppDelegate.h
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIViewController *homeViewController;
@property (weak, nonatomic) UIViewController<PaymentDelegate>* toBePaidViewController;

@end

@protocol PaymentDelegate <NSObject>

- (void)didFinishPayment;

@end
