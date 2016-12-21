//
//  UIView+TSExtension.h
//  sdy
//
//  Created by 王俊 on 15/11/29.
//  Copyright © 2015年 HPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TSExtension)

- (void)alignYCenterInSuperView;
- (void)addConstraintWithWidth:(CGFloat)width;
- (void)addConstraintWithHeight:(CGFloat)height;
- (NSLayoutConstraint*)constraintWithWidth:(CGFloat)width;

@end
