//
//  TSRoundButton.h
//  sdy
//
//  Created by 王俊 on 16/6/14.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSRoundButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor* borderColor;

@end
