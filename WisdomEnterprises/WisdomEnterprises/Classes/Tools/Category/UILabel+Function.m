//
//  UILabel+Function.m
//  EFamilyEducation
//
//  Created by mac on 16/3/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UILabel+Function.h"
#import "UIView+Function.h"
@implementation UILabel (Function)

+(instancetype)labelWithTitle:(NSString *)title
              backgroundcolor:(UIColor *)backgroundcolor
{
    UILabel * label = [[self alloc]init];
    
    label.text = title;
    
    if (backgroundcolor == nil) {
        
        backgroundcolor = [UIColor clearColor];
    }
    
    label.backgroundColor = backgroundcolor;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
    
}

+(instancetype)getTitleLabelWithTitle:(NSString *)title
                            textcolor:(UIColor *)textcolor frame:(CGRect)frame
{
    UILabel * label = [self labelWithTitle:title backgroundcolor:nil];
    
    label.frame = frame;
    
    label.font =[UIFont boldSystemFontOfSize:20];
    
    label.textColor = textcolor;
    
    return label;
    
}

//-(void)getRoundWithRadius:(CGFloat)radius
//{
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
//    
//    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) cornerRadius:radius];
//    
//    [[UIColor redColor] setFill];
//    
//    [path fill];
//    
//    CGSize textSize = [self.text sizeWithFont:self.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    
//    [self.text drawInRect:CGRectMake((self.width-textSize.width)/2, (self.height-textSize.height)/2, textSize.width, textSize.height) withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.textColor}];
//    
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    
//    self.layer.contents =(id)image.CGImage;
//    
//    
//}



@end
