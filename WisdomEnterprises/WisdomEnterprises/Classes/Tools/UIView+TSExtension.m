//
//  UIView+TSExtension.m
//  sdy
//
//  Created by 王俊 on 15/11/29.
//  Copyright © 2015年 HPE. All rights reserved.
//

#import "UIView+TSExtension.h"

@implementation UIView (TSExtension)

- (void)alignYCenterInSuperView {
    NSLayoutConstraint* constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.superview
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0];
    [self.superview addConstraint:constraint];
}

- (void)addConstraintWithWidth:(CGFloat)width {
    NSLayoutConstraint* constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    [self.superview addConstraint:constraint];
}

- (NSLayoutConstraint*)constraintWithWidth:(CGFloat)width {
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
}

- (void)addConstraintWithHeight:(CGFloat)height {
    NSLayoutConstraint* constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [self.superview addConstraint:constraint];
}

@end
