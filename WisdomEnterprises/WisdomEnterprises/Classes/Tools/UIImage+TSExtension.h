//
//  UIImage+TSExtension.h
//  sdy
//
//  Created by 王俊 on 16/5/20.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TSExtension)

- (UIImage *)scaledImageToSize:(CGSize)newSize;
- (UIImage *)compressedImage;

@end
