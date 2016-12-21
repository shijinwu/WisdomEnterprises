//
//  TSPaymentMethod.h
//  sdy
//
//  Created by 王俊 on 16/3/9.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSPaymentMethodType) {
    TSPaymentMethodTypeNone = -1,
    TSPaymentMethodTypeBalance = 0,
    TSPaymentMethodTypeAlipay,
    TSPaymentMethodTypeWXPay,
    TSPaymentMethodTypeCOD, // cash on delivery
    TSPaymentMethodTypeZhongxin
};

@interface TSPaymentMethod : NSObject

@property (nonatomic, assign)   TSPaymentMethodType type;
@property (nonatomic, copy)     NSString*           title;
@property (nonatomic, copy)     NSString*           icon;
@property (nonatomic, assign)   BOOL                selected;

- (instancetype)initWithTitle:(NSString*)title
                         icon:(NSString*)icon
                     selected:(BOOL)selected
                         type:(TSPaymentMethodType)type;

+ (instancetype)paymentMethodWithTitle:(NSString*)title
                                  icon:(NSString*)icon
                              selected:(BOOL)selected
                                  type:(TSPaymentMethodType)type;

@end
