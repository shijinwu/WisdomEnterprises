//
//  UIViewController+SDYPublicViewController.h
//  sdy
//
//  Created by Bode Smile on 14-9-23.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDYStyleManager.h"
#import "DEVICEENV.h"

#define DO_NOT_OPEN_NOW {UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"该功能尚未开放" message:@"该功能尚未全部完成，会在后续的版本中提供！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; [alert show];return;}

@interface UIViewController (SDYPublicViewController)

-(BOOL)checkIsTextFieldEmpty:(UITextField*)textfield showMessage:(BOOL)message title:(NSString*)title;
/**
 * 有弹出消息
 */
- (BOOL)checkIsTextFieldEmpty:(UITextField*)textfield title:(NSString*)title;
-(BOOL)checkIsTextEmpty:(NSString*)text showMessage:(BOOL)message title:(NSString*)title;
-(BOOL)checkIsNumberEmpty:(NSNumber*)number showMessage:(BOOL)message title:(NSString*)title;

-(void)backToHomepage;
-(void)backToPrePaidVC;

-(void)toPublicSelectorVC:(NSString*)title list:(NSArray*)list multiSelector:(BOOL)multi address:(BOOL)isaddress completionBlock:(completion_with_array)completion;
-(void)toPublicSelectorVC:(NSString*)title list:(NSArray*)list multiSelector:(BOOL)multi address:(BOOL)isaddress doNotPop:(BOOL)notPop completionBlock:(completion_with_array)completion;
-(void)toPublicRemarkVC:(NSString*)title completionBlock:(completion_with_array)completion;
-(void)toPublicRemarkVC1:(NSString*)title deliveryIntervalTime:(NSDictionary *)deliveryIntervalTime type:(NSString *)type completionBlock:(completion_with_array)completion;
////Array[Array[Dictory[title,defautVal,style(0-no title 1-left title)]]...]
-(void)toPublicEditorVC:(NSString*)title list:(NSArray*)list tips:(NSString*)tips completionBlock:(completion_with_array)completion;
-(void)toPaymentProcess:(NSDictionary*)order;
-(void)toPaymentProcess:(NSDictionary*)order alreadySetTobePaid:(BOOL)alreadySetTobePaid;
- (void)showProgressHUD:(NSString*)title
    whileExecutingBlock:(dispatch_block_t)block
        completionBlock:(void (^)())completion;
- (void)showMessage:(NSString*)message;

/**
 *  记录某个页面访问的开始
 */
- (void)mobStatPageViewStart;

/**
 *  记录某个页面访问的结束，与mobStatPageViewStart配对使用
 */
- (void)mobStatPageViewEnd;

@end
