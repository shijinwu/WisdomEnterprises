//
//  TSRechargeCollectionDecorationView.m
//  sdy
//
//  Created by 王俊 on 16/7/15.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSRechargeCollectionDecorationView.h"

@implementation TSRechargeCollectionDecorationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
