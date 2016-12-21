//
//  TSPaymentMethod.m
//  sdy
//
//  Created by 王俊 on 16/3/9.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSPaymentMethod.h"

@implementation TSPaymentMethod

- (instancetype)initWithTitle:(NSString*)title icon:(NSString*)icon selected:(BOOL)selected type:(TSPaymentMethodType)type
{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
        self.selected = selected;
        self.type = type;
    }
    return self;
}

+ (instancetype)paymentMethodWithTitle:(NSString*)title icon:(NSString*)icon selected:(BOOL)selected type:(TSPaymentMethodType)type
{
    TSPaymentMethod* paymentMethod = [[TSPaymentMethod alloc] initWithTitle:title icon:icon selected:selected type:type];
    return paymentMethod;
}

@end
