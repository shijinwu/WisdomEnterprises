//
//  UIColor+WXExtension.m
//  WXPageView(OC)
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIColor+WXExtension.h"

@implementation UIColor (WXExtension)

+(instancetype)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b Alpha:(CGFloat)alpha
{
    UIColor * color = [[UIColor alloc]initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
 
    return color;
}

+(instancetype)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha{
    
    if (hex.length < 6) {
        
        NSLog(@"参数不合法");
        
        UIColor * color = [[UIColor alloc]init];
        
        return color;
    }
   NSString *  tempHex = hex.uppercaseString;

    
    if ([tempHex hasPrefix:@"0x"]||[tempHex hasPrefix:@"##"]) {
        tempHex = [tempHex substringFromIndex:2];
    }
    if ([tempHex hasPrefix:@"#"]){
        tempHex = [tempHex substringFromIndex:1];
    }
    
    NSRange range = NSMakeRange(0, 2);
    NSString * rHex = [tempHex substringWithRange:range];
    range.location = 2;
    NSString * gHex = [tempHex substringWithRange:range];
    range.location = 4;
    NSString * bHex =  [tempHex substringWithRange:range];
    
    int r = 0; int g = 0; int b = 0;
    
    [[NSScanner scannerWithString:rHex]scanInt:&r];
    [[NSScanner scannerWithString:gHex]scanInt:&g];
    [[NSScanner scannerWithString:bHex]scanInt:&b];
    
    return  [UIColor colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b Alpha:1.0];
    
}

+(instancetype)randomColor{
    
    return  [UIColor colorWithR:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256) Alpha:1.0];
}

-(NSArray *)getRGB{
    
    const  CGFloat * components = CGColorGetComponents(self.CGColor);

    return  @[@(components[0]),@(components[1]),@(components[2])];
}

+(NSArray *)getRGBDeltaWithFristColor:(UIColor *)fristColor SecondColor:(UIColor *)secondColor{
    
    NSArray<NSNumber*>*frist =  fristColor.getRGB;
    NSArray<NSNumber*>*second = secondColor.getRGB;
 
    NSNumber * r  = @(frist[0].floatValue-second[0].floatValue);
    NSNumber * g  = @(frist[1].floatValue-second[1].floatValue);
    NSNumber * b  = @(frist[2].floatValue-second[2].floatValue);
    
    return  @[r,g,b];
    
}

@end
