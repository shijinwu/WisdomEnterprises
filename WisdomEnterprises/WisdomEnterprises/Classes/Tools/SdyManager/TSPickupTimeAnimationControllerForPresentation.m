//
//  TSPickupTimeAnimationControllerForPresentation.m
//  sdy
//
//  Created by 王俊 on 16/7/8.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSPickupTimeAnimationControllerForPresentation.h"

@interface TSPickupTimeAnimationControllerForPresentation ()
{
    UIButton* _backView;
}

@end

@implementation TSPickupTimeAnimationControllerForPresentation

// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView* inView = [transitionContext containerView];
    UIView* toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    CGRect inViewBounds = inView.bounds;
    CGSize inViewSize = inView.bounds.size;
    CGSize toViewSize = toView.bounds.size;
    
    _backView = [[UIButton alloc] initWithFrame:inViewBounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    
    [inView addSubview:_backView];
    [inView addSubview:toView];
    
    toView.frame = CGRectMake(0, inViewSize.height, inViewSize.width, toViewSize.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.5;
        toView.frame = CGRectMake(0, inViewSize.height - toViewSize.height, inViewSize.width, toViewSize.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
