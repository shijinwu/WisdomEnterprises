//
//  SDYViewController.h
//  sdy
//
//  Created by Bode Smile on 14-9-4.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDYTextField.h"
#import "SDYStyleManager.h"
#import "DEVICEENV.h"
#import "SDYEnvironment.h"
#import "UIViewController+SDYPublicViewController.h"
#import "SDYHTTPManager.h"
#import "SDYAccountManager.h"

@interface SDYViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

//-(void)showProgressHUD:(NSString*)title whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion;

@end
