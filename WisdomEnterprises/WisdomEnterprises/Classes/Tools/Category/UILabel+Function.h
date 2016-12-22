//
//  UILabel+Function.h
//  EFamilyEducation
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Function)

+(instancetype)labelWithTitle:(NSString *)title backgroundcolor:(UIColor *)backgroundcolor;

+(instancetype)getTitleLabelWithTitle:(NSString *)title textcolor:(UIColor *)textcolor frame:(CGRect)frame;

-(void)getRoundWithRadius:(CGFloat)radius;

@end
