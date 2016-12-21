//
//  TSRoundButton.m
//  sdy
//
//  Created by 王俊 on 16/6/14.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSRoundButton.h"

@implementation TSRoundButton

- (void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = _cornerRadius;
    
    if (_borderWidth) {
        self.layer.borderColor = _borderColor.CGColor;
        self.layer.borderWidth = _borderWidth;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
