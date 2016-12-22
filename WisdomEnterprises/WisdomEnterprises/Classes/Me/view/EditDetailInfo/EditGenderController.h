//
//  EditGenderController.h
//  EFamilyEducation
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGenderController : UIViewController

@property (nonatomic,copy)void(^saveGenderString)();

@property (nonatomic,copy)void(^saveInfo)();

@end
