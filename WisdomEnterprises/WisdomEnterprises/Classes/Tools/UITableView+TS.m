//
//  UITableView+TS.m
//  sdy
//
//  Created by 王俊 on 16/7/2.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "UITableView+TS.h"

@implementation UITableView (TS)

- (NSIndexPath*)indexPathForView:(UIView*)view {
    CGPoint origin = [view convertPoint:CGPointZero toView:self];
    NSIndexPath* indexPath = [self indexPathForRowAtPoint:origin];
    return indexPath;
}

@end
