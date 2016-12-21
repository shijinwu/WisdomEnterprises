//
//  SDYTableViewController.m
//  sdy
//
//  Created by Bode Smile on 14-9-6.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYTableViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface SDYTableViewController (){
    UITextField* activeField;
}

@end

@implementation SDYTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activeField = nil;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // register for keyboard notifications
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc]
                                            initWithTitle:IOS7?@"  ":@"返回"
                                            style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
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
    {
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
    
    if(!IOS8){
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //  if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //    [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    //  }
    [self.tableView scrollRectToVisible:activeField.frame animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //  self.tableView.contentInset = contentInsets;
    //self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    for (UIView* view in textField.superview.subviews) {
        if([view isKindOfClass:[UITextField class]]){
            UITextField* otherField = (UITextField*)view;
            if(otherField != textField)
                [SDYStyleManager decorateTextField:otherField isActive:NO];
            else
                [SDYStyleManager decorateTextField:textField isActive:YES];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    [SDYStyleManager decorateTextField:textField isActive:NO];
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
//  HUD.labelText = title;
//  [HUD showAnimated:YES whileExecutingBlock:block completionBlock:^{
//    [HUD removeFromSuperview];
//    completion();
//  }];
//}

#pragma mark - header and footer view

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
//  [headerView setBackgroundColor:SDYColorGrayTableViewBack];
//  return headerView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
//  [footerView setBackgroundColor:SDYColorGrayTableViewBack];
//  return footerView;
//}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//  // Return the number of sections.
//  return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//  // Return the number of rows in the section.
//  return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
