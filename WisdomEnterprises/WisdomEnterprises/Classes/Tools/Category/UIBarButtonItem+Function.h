//
//  UIBarButtonItem+Function.h
//  baisibudeqijie
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Function)

+(instancetype)itemWithImage:(NSString *)image selectImage:(NSString *)selectImage target:(id)target action:(SEL)action;


+(instancetype)showBackItemWithController:(UIViewController *)viewController;



@end
