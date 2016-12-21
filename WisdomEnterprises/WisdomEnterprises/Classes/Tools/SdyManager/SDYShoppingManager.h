//
//  SDYShoppingManager.h
//  sdy
//
//  Created by mac on 16/10/27.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SDYShoppingManager : NSObject

+(instancetype)shareManager;


-(void)getOneMoreTimeOrderInfo:(NSDictionary *)dic Controller:(UIViewController*)vc;

@end
