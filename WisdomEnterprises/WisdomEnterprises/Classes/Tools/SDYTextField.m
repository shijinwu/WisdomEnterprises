//
//  SDYTextField.m
//  sdy
//
//  Created by Bode Smile on 14-9-5.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYTextField.h"

#define verticalPadding 0
#define horizontalPadding 10

@implementation SDYTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
  return CGRectMake(bounds.origin.x + self.leftView.frame.size.width + horizontalPadding, bounds.origin.y + verticalPadding, bounds.size.width - horizontalPadding*2-self.leftView.frame.size.width-self.rightView.frame.size.width, bounds.size.height - verticalPadding*2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [self textRectForBounds:bounds];
}


@end
