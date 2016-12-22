//
//  EditNormalInfoController.h
//  EFamilyEducation
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNormalInfoController : UIViewController


@property (nonatomic,copy)void(^saveString)(NSString *string);

@property (nonatomic,copy)void(^saveInfo)();

@end
