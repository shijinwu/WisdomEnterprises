//
//  UIViewController+SDYPublicViewController.m
//  sdy
//
//  Created by Bode Smile on 14-9-23.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "UIViewController+SDYPublicViewController.h"
#import "AppDelegate.h"
//#import "SDYSelectorViewController.h"
//#import "SDYRemarkViewController.h"
//#import "SDYTableViewEditerViewController.h"
//#import "SDYPaymentConfirmViewController.h"
#import "MBProgressHUD.h"
//#import "SDYSelectDistributionTimeViewController.h"
//#import "BaiduMobStat.h"
//#import "SDYAppDelegate.h"
@implementation UIViewController(SDYPublicViewController)


-(BOOL)checkIsTextFieldEmpty:(UITextField*)textfield showMessage:(BOOL)message title:(NSString*)title{
    if(!textfield || !textfield.text || textfield.text.length==0){
        if(message){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空值",title] message:@"请重新输入后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        return YES;
    }
    return NO;
}

- (BOOL)checkIsTextFieldEmpty:(UITextField*)textfield title:(NSString*)title {
    if(!textfield || !textfield.text || textfield.text.length==0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空值",title] message:@"请重新输入后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return NO;
}

-(BOOL)checkIsTextEmpty:(NSString*)text showMessage:(BOOL)message title:(NSString*)title{
    if(!text || text.length==0){
        if(message){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空值",title] message:@"请重新输入后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        return YES;
    }
    return NO;
}

-(BOOL)checkIsNumberEmpty:(NSNumber*)number showMessage:(BOOL)message title:(NSString*)title{
    if(!number){
        if(message){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不能为空值",title] message:@"请重新输入后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        return YES;
    }
    return NO;
}

#pragma mark Back To Homepage

-(void)backToHomepage{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
    if(delegate.homeViewController)
        [navController popToViewController:delegate.homeViewController animated:YES];
    else
        [navController popToRootViewControllerAnimated:YES];
}

-(void)backToPrePaidVC{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
    NSArray* vcs = [navController viewControllers];
    if(delegate.toBePaidViewController && [vcs containsObject:delegate.toBePaidViewController]){
        if([delegate.toBePaidViewController respondsToSelector:@selector(didFinishPayment)]){
            [delegate.toBePaidViewController didFinishPayment];
        }
        [navController popToViewController:delegate.toBePaidViewController animated:YES];
    }
    else
        [navController popToViewController:delegate.homeViewController animated:YES];
}

#pragma mark Public VC

-(void)toPublicSelectorVC:(NSString*)title list:(NSArray*)list multiSelector:(BOOL)multi address:(BOOL)isaddress completionBlock:(completion_with_array)completion{
    [self toPublicSelectorVC:title list:list multiSelector:multi address:isaddress doNotPop:NO completionBlock:completion];
}

-(void)toPublicSelectorVC:(NSString*)title list:(NSArray*)list multiSelector:(BOOL)multi address:(BOOL)isaddress doNotPop:(BOOL)notPop completionBlock:(completion_with_array)completion{
//    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"PublicSelector" bundle:nil];
//    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
//    SDYSelectorViewController* nextVC = (SDYSelectorViewController*)[storyBoard instantiateInitialViewController];
//    [nextVC setTitleString:title];
//    [nextVC setListArray:list];
//    [nextVC setMultiSelector:multi];
//    [nextVC setDoNotPop:notPop];
//    [nextVC setIsaddress:isaddress];
//    [nextVC setCompletion:completion];
//    [navController pushViewController:nextVC animated:YES];
}

-(void)toPublicRemarkVC:(NSString*)title completionBlock:(completion_with_array)completion{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"PublicRemark" bundle:nil];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
//    SDYRemarkViewController* nextVC = (SDYRemarkViewController*)[storyBoard instantiateInitialViewController];
//    [nextVC setTitleString:title];
//    [nextVC setCompletion:completion];
//    [navController pushViewController:nextVC animated:YES];
}

/**
 * 选择配送时间
 */
- (void)toPublicRemarkVC1:(NSString*)title deliveryIntervalTime:(NSDictionary *)deliveryIntervalTime type:(NSString *)type completionBlock:(completion_with_array)completion{
//    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"publicSelectTime" bundle:nil];
//    
//    SDYSelectDistributionTimeViewController* nextVC = [storyBoard instantiateInitialViewController];
//    [nextVC setTitleString:title];
//    [nextVC setDeliveryIntervalTimeDic:deliveryIntervalTime];
//    [nextVC setType:type];
//    [nextVC setCompletion:completion];
//    
//    if ([nextVC respondsToSelector:@selector(popoverPresentationController)]) {
//        if (self.view.bounds.size.width > 320) {
//            nextVC.preferredContentSize = CGSizeMake(337, 292);
//        } else {
//            nextVC.preferredContentSize = CGSizeMake(290, 292);
//        }
//        
//        nextVC.modalPresentationStyle = UIModalPresentationPopover;
//        
//        UIPopoverPresentationController* presentationCtrl = nextVC.popoverPresentationController;
//        presentationCtrl.sourceView = self.view;
//        //    presentationCtrl.sourceRect = CGRectMake(0, 0, 337, 292);
//        presentationCtrl.delegate = self;
//    }
//    
//    [self presentViewController:nextVC animated:YES completion:^{
//        //
//    }];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;//不适配
}

//设置接下来的视图控制器内容
-(void)toPublicEditorVC:(NSString*)title list:(NSArray*)list tips:(NSString*)tips completionBlock:(completion_with_array)completion{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"PublicEditor" bundle:nil];
//    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
//    SDYTableViewEditerViewController* nextVC = (SDYTableViewEditerViewController*)[storyBoard instantiateInitialViewController];//实例初始化视图控制器
//    [nextVC setTitleString:title];
//    [nextVC setListArray:list];
//    [nextVC setTipsString:tips];
//    [nextVC setCompletion:completion];
//    [navController pushViewController:nextVC animated:YES];
}

-(void)toPaymentProcess:(NSDictionary*)order alreadySetTobePaid:(BOOL)alreadySetTobePaid{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Payment" bundle:nil];
//    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    if(!alreadySetTobePaid){
//        delegate.toBePaidViewController = self;
//    }
//    UINavigationController* navController = (UINavigationController*)delegate.window.rootViewController;
//    SDYPaymentConfirmViewController* paymentVC = [storyBoard instantiateInitialViewController];
//    [paymentVC setValue:order forKey:@"orderInfo"];
//    [navController pushViewController:paymentVC animated:YES];
}

-(void)toPaymentProcess:(NSDictionary*)order{
    [self toPaymentProcess:order alreadySetTobePaid:NO];
    
}

#pragma mark MBProgressHUD
- (void)showProgressHUD:(NSString*)title
    whileExecutingBlock:(dispatch_block_t)block
        completionBlock:(void (^)())completion {
    
    [self showProgressHUD:title animation:YES whileExecutingBlock:block completionBlock:completion];
}

- (void)showProgressHUD:(NSString*)title
              animation:(BOOL)isAnimation
    whileExecutingBlock:(dispatch_block_t)block
        completionBlock:(void (^)())completion {
    
    [self.view endEditing:YES];
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.navigationController.view addSubview:HUD];
    
   AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    if (isAnimation) {
        HUD.minSize = CGSizeMake(delegate.window.frame.size.width/2, delegate.window.frame.size.width/2);
        HUD.margin = 5;
        
        //        UIImageView* loadingView = [[UIImageView alloc] init];
        //        NSMutableArray* imageList = [@[] mutableCopy];
        //        for (int i=1; i<49; i++) {
        //            [imageList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yu_%04d.png",i]]];
        //        }
        //        [loadingView setAnimationImages:imageList];
        //        [loadingView setFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.width/2)];
        //        [loadingView setContentMode:UIViewContentModeScaleAspectFill];
        //        [loadingView setAnimationRepeatCount:0];
        //        [loadingView setAnimationDuration:2.0];
        //        [loadingView startAnimating];
        //        HUD.customView = loadingView;
        //        HUD.mode = MBProgressHUDModeCustomView;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.labelText = title;
        HUD.dimBackground = NO;
        //        HUD.opacity = 0;
        HUD.minShowTime = 0.25;
        HUD.graceTime = 0.3;
    }
    else{
        HUD.minSize = CGSizeMake(delegate.window.frame.size.width, delegate.window.frame.size.height);
        HUD.margin = 5;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.dimBackground = YES;
        //        HUD.opacity = 0.1;
        HUD.minShowTime = 0.15;
        HUD.graceTime = 0.2;
    }
    
    [HUD showAnimated:YES whileExecutingBlock:block completionBlock:^{
        if ([HUD.customView isKindOfClass:[UIImageView class]]) {
            UIImageView* loadingImage = (UIImageView*)HUD.customView;
            if (loadingImage.isAnimating) {
                [loadingImage stopAnimating];
            }
        }
        [HUD removeFromSuperview];
        completion();
    }];
}

- (void)showMessage:(NSString*)message {
    
    [self.view endEditing:YES];
    //    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //    [self.navigationController.view addSubview:HUD];
    //
    //    SDYAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    //
    //    HUD.minSize = CGSizeMake(delegate.window.frame.size.width, delegate.window.frame.size.height);
    //    HUD.margin = 5;
    //    HUD.mode = MBProgressHUDModeText;
    //    HUD.dimBackground = YES;
    //    //        HUD.opacity = 0.1;
    //    HUD.minShowTime = 0.15;
    //    HUD.graceTime = 0.2;
    //
    //    [HUD show:YES];
    //    [HUD hide:YES afterDelay:2];
    MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = message;
    [HUD hide:YES afterDelay:2];
}

#pragma mark - Baidu mobile stats

- (void)mobStatPageViewStart {
    NSString* cName;
    if (self.title) {
        cName = self.title;
    }
    else {
        cName = NSStringFromClass([self class]);
    }
    //    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
//    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)mobStatPageViewEnd {
    NSString* cName;
    if (self.title) {
        cName = self.title;
    }
    else {
        cName = NSStringFromClass([self class]);
    }
    //    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
   // [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

@end
