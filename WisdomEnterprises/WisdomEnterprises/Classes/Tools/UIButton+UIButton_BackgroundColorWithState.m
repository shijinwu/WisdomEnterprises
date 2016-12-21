//
//  UIButton+UIButton_BackgroundColorWithState.m
//  sdy
//
//  Created by Bode Smile on 14-9-6.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "UIButton+UIButton_BackgroundColorWithState.h"

@implementation UIButton (UIButton_BackgroundColorWithState)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
  UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
  colorView.backgroundColor = color;
  
  UIGraphicsBeginImageContext(colorView.bounds.size);
  [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  [self setBackgroundImage:colorImage forState:state];
}

@end
