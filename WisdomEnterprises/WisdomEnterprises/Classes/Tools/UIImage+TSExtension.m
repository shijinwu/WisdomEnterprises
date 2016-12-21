//
//  UIImage+TSExtension.m
//  sdy
//
//  Created by 王俊 on 16/5/20.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "UIImage+TSExtension.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (TSExtension)

- (UIImage *)scaledImageToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)compressedImage {
    CGSize originalSize = self.size;
    CGRect boundingRect = CGRectMake(0, 0, 500, 500);
    CGRect newRect = AVMakeRectWithAspectRatioInsideRect(originalSize, boundingRect);
    
    return [self scaledImageToSize:newRect.size];
}

@end
