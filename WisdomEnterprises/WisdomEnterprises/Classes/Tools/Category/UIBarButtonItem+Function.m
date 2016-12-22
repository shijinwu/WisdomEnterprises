//
//  UIBarButtonItem+Function.m
//  baisibudeqijie
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIBarButtonItem+Function.h"
#import "UIView+Function.h"
@implementation UIBarButtonItem (Function)


+(instancetype)itemWithImage:(NSString *)image selectImage:(NSString *)selectImage target:(id)target action:(SEL)action
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    
//    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];

    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    NSLog(@"image = %@",[UIImage imageNamed:image]);
    [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];

    button.size = button.currentBackgroundImage.size;
 
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
   return [[self alloc]initWithCustomView:button];

}

+(instancetype)showBackItemWithController:(UIViewController *)viewController
{
   return  [self itemWithImage:@"show_image_back_icon" selectImage:@"show_image_back_icon" target:viewController action:@selector(back)];
 
}

@end
