//
//  UIViewController+Function.h
//  EFamilyEducation
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Function)

@property (nonatomic,copy)void(^saveInfo)();

-(void)setSaveInfo:(void (^)())saveInfo;

@end
