//
//  UIColor+WXExtension.h
//  WXPageView(OC)
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WXExtension)

+(instancetype)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b Alpha:(CGFloat)alpha;

+(instancetype)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

+(instancetype)randomColor;


-(NSArray *)getRGB;

+(NSArray *)getRGBDeltaWithFristColor:(UIColor *)fristColor SecondColor:(UIColor *)secondColor;

@end
