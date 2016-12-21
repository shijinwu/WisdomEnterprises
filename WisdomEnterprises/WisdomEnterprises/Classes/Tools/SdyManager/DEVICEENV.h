//
//  DEVICEENV.h
//  sdy
//
//  Created by Bode Smile on 14-9-5.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#define ALPHA_TEST//不能提交
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height >=1136) : NO)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)

#define NAVBAR_HEIGHT (IOS7?64:44)
#define PHONE  (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#define LANDSCAPE (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#define _CHECK_NIL(x) ((x)?(x):@"")
#define _CLIP_STRING(str,len) (((NSString*)str).length>(len)?[(str) substringToIndex:len]:(str))

typedef void(^completion_with_array)(NSArray*) ;