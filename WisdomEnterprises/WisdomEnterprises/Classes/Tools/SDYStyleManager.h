//
//  SDYStyleManager.h
//  sdy
//
//  Created by Bode Smile on 14-9-4.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SDYViewController;
@class SDYTableViewController;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define SDYColorClear ([UIColor colorWithWhite:1 alpha:0])
#define SDYColorMain UIColorFromRGB(0x4794FF)
#define SDYColorWhite UIColorFromRGB(0xFFFFFF)
#define SDYColorRed UIColorFromRGB(0xD64A4B)
#define SDYColorBlack UIColorFromRGB(0x000000)
#define SDYColorLightBlue UIColorFromRGB(0xD3E5F4)
#define SDYColorGreen UIColorFromRGB(0x4AD64B)

#define SDYColorGrayTableViewBack UIColorFromRGB(0xEEEEEE)
#define SDYColorGrayListBack UIColorFromRGB(0xEFEFEF)
#define SDYColorGrayButton UIColorFromRGB(0xAFAFAF)
#define SDYColorDeepGrayButton UIColorFromRGB(0x808080)

#define SDYColorBorderActive UIColorFromRGB(0x1EAFEC)
#define SDYColorBorderInactive UIColorFromRGB(0xBCBCBC)

#define TSColorShopping UIColorFromRGB(0x00BCD4)

@interface SDYStyleManager : NSObject

//控件风格化
+ (void)decorateButton:(UIButton*)button withColor:(UIColor*)color;
+ (void)decorateSegmentedControl:(UISegmentedControl*)seg normalColor:(UIColor*)color selectColor:(UIColor*)selcolor isChangeBackGroundColor:(BOOL)isChange;
+ (void)decorateTextField:(UITextField*)textField isActive:(BOOL)isActive;
+ (void)decorateTextView:(UITextView*)textView;
+(void)decorateLabel:(UILabel*)label isSelected:(BOOL)isSelected;
+(void)decorateAppStyle:(UIView*)view withSubViews:(BOOL)isSubViews;
+(void)decorateAPPTableviewStyle:(UITableView*)tableView;

//同类型界面风格化
+ (void)decorateLoginView:(UIView*)view inVC:(SDYViewController*)vc;
+ (void)decorateVerifyView:(UIView*)view inVC:(SDYViewController*)vc;
+ (void)decorateTableView:(UIView*)view inVC:(UIViewController*)vc;

//图标风格化
+ (void)decorateUserIconImageView:(UIImageView*)view withUser:(NSString*)phoneNumber;

@end
