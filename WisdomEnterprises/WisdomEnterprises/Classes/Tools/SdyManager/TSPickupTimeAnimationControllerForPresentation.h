//
//  TSPickupTimeAnimationControllerForPresentation.h
//  sdy
//
//  Created by 王俊 on 16/7/8.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@interface TSPickupTimeAnimationControllerForPresentation : NSObject
<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIViewController* presentingController;

@end
