//
//  SDYViewController.m
//  sdy
//
//  Created by Bode Smile on 14-9-4.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYViewController.h"
#import "MBProgressHUD.h"

@interface SDYViewController (){
    UITextField* activeField;
}

@end

@implementation SDYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self.view isKindOfClass:[UIScrollView class]]){
        self.scrollView = (UIScrollView*)self.view;
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height-NAVBAR_HEIGHT)];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    else
        self.scrollView = nil;
    activeField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // register for keyboard notifications
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:IOS7?@"  ":@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if (self.scrollView) {
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(keyboardWasShown:)
                       name:UIKeyboardWillShowNotification
                     object:nil];
        
        [center addObserver:self
                   selector:@selector(keyboardWillBeHidden:)
                       name:UIKeyboardWillHideNotification
                     object:nil];
    }
    
    // 记录某个页面访问的开始
    [self mobStatPageViewStart];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // unregister for keyboard notifications while not visible.
    if (self.scrollView) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
    
    // 记录某个页面访问的结束
    [self mobStatPageViewEnd];
}

#pragma mark move Textfield when keyboard will show

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //  if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //    [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    //  }
    [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    //  [SDYStyleManager decorateTextField:textField isActive:NO];
}

- (BOOL)textFieldShouldReturn:(id)sender {
    [sender resignFirstResponder];
    return YES;
}

//#pragma mark MBProgressHUD
//-(void)showProgressHUD:(NSString*)title whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
//  [self.view endEditing:YES];
//  MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
//  [self.navigationController.view addSubview:HUD];
//  HUD.dimBackground = YES;
//  HUD.opacity = 0;
//  UIImageView* loadingView = [[UIImageView alloc] init];
//  [loadingView setAnimationImages:@[[UIImage imageNamed:@"yu000.png"],[UIImage imageNamed:@"yu001.png"],[UIImage imageNamed:@"yu002.png"],[UIImage imageNamed:@"yu003.png"],[UIImage imageNamed:@"yu004.png"],[UIImage imageNamed:@"yu005.png"],[UIImage imageNamed:@"yu006.png"],[UIImage imageNamed:@"yu007.png"],[UIImage imageNamed:@"yu008.png"]]];
//  [loadingView setFrame:CGRectMake(0, 0, 320/2, 568.88/2)];
//  [loadingView setAnimationRepeatCount:0];
//  [loadingView setAnimationDuration:0.8];
//  [loadingView startAnimating];
//  HUD.customView = loadingView;
//  HUD.mode = MBProgressHUDModeCustomView;
//  HUD.labelText = title;
//  [HUD showAnimated:YES whileExecutingBlock:block completionBlock:^{
//    [HUD removeFromSuperview];
//    completion();
//  }];
//}


@end
