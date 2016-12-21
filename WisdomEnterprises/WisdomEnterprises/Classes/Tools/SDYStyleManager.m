//
//  SDYStyleManager.m
//  sdy
//
//  Created by Bode Smile on 14-9-4.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYStyleManager.h"
#import "DEVICEENV.h"
#import "SDYViewController.h"
#import "SDYTableViewController.h"
#import "UIButton+UIButton_BackgroundColorWithState.h"
#import "SDYTextField.h"
#import "SDYEnvironment.h"
#import "MJRefresh.h"
#import "TSTextView.h"

@implementation SDYStyleManager

+(void)decorateButton:(UIButton*)button withColor:(UIColor*)color{
  button.layer.cornerRadius = 2;
  button.layer.masksToBounds = YES;
  [button setBackgroundColor:color forState:UIControlStateNormal];
  [button setBackgroundColor:nil];
}

+(void)decorateSegmentedControl:(UISegmentedControl*)seg normalColor:(UIColor*)color selectColor:(UIColor*)selcolor isChangeBackGroundColor:(BOOL)isChange
{
  [seg setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              color, NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:14],NSFontAttributeName,
                                              nil] forState:UIControlStateNormal];
    
   
  [seg setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              selcolor, NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:14],NSFontAttributeName,
                                              nil] forState:UIControlStateSelected];
    if (isChange)
    {
        seg.tintColor=SDYColorMain;
    }
    
}
+(void)decorateAPPTableviewStyle:(UITableView*)tableView
{
    /**
     *  集成刷新控件
     */
   
    MJRefreshNormalHeader* header = (MJRefreshNormalHeader*)tableView.mj_header;
    [header setTitle:@"下拉可以刷新了" forState:MJRefreshStateIdle];
    [header setTitle:@"松开马上刷新了" forState:MJRefreshStatePulling];
    [header setTitle:@"智郡智慧社区正在努力帮你刷新中" forState:MJRefreshStateRefreshing];
    
    MJRefreshAutoNormalFooter* footer = (MJRefreshAutoNormalFooter*)tableView.mj_footer;
    [footer setTitle:@"上拉可以加载更多数据了" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开马上加载更多数据了" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"智郡智慧社区正在帮你努力加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
//        tableView.headerPullToRefreshText = @"下拉可以刷新了";
//        tableView.headerReleaseToRefreshText = @"松开马上刷新了";
//        tableView.headerRefreshingText = @"智郡智慧社区正在努力帮你刷新中";
//        tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
//        tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
//        tableView.footerRefreshingText = @"智郡智慧社区正在帮你努力加载中";
}

+ (void)decorateAppStyle:(UIView*)view withSubViews:(BOOL)isSubViews
{
//  if([view isKindOfClass:[UIButton class]])
//  {
//    UIButton* button = (UIButton*)view;
//    if(button.backgroundColor!=nil)
//    {
//      button.layer.cornerRadius = 2;
//      button.layer.masksToBounds = YES;
//      [button setBackgroundColor:button.backgroundColor forState:UIControlStateNormal];
//      [button setBackgroundColor:nil];
//    }
//    else
//    {
//      [button setTitleColor:SDYColorMain forState:UIControlStateNormal];
//    }
//  }
    if([view isKindOfClass:[SDYTextField class]])
    {
        SDYTextField* button = (SDYTextField*)view;
        [SDYStyleManager decorateTextField:button isActive:NO];
    }
    
    if ([view isKindOfClass:[TSTextView class]]) {
        [self decorateTextView:(TSTextView*)view];
    }
    
    if(isSubViews)
    {
        for (UIView* sview in view.subviews)
        {
            [SDYStyleManager decorateAppStyle:sview withSubViews:isSubViews];
        }
    }
}

+ (void)decorateTextField:(UITextField*)textField isActive:(BOOL)isActive
{
  if([textField isKindOfClass:[SDYTextField class]])
  {
    textField.layer.masksToBounds = YES;
      
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius = 4;
      
      textField.layer.shadowRadius = 0;
      textField.layer.shadowOpacity = 0;
      textField.layer.borderColor = [SDYColorBorderInactive CGColor];
  }
}

+ (void)decorateTextView:(UITextView*)textView
{
    if([textView isKindOfClass:[TSTextView class]])
    {
        textView.layer.masksToBounds = YES;
        textView.layer.borderWidth = 0.5;
        textView.layer.cornerRadius = 4;
        textView.layer.borderColor = [SDYColorBorderInactive CGColor];
    }
}

+(void)decorateLabel:(UILabel*)label isSelected:(BOOL)isSelected
{
  if([label isKindOfClass:[UILabel class]])
  {
    label.layer.masksToBounds = NO;
    label.layer.shadowOffset = CGSizeMake(0,0);
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 2;
    label.backgroundColor = SDYColorWhite;
    
    if(isSelected)
    {
      [label.layer setShadowColor:[SDYColorRed CGColor]];
      label.layer.shadowRadius = 2;
      label.layer.shadowOpacity = 0.8;
      label.layer.borderColor = [SDYColorRed CGColor];
      label.textColor = SDYColorRed;
    }
    else
    {
      label.layer.shadowRadius = 0;
      label.layer.shadowOpacity = 0;
      label.layer.borderColor = [SDYColorGrayButton CGColor];
      label.textColor = SDYColorDeepGrayButton;
    }
  }
}

+(void)addTextFieldDelegate:(UIView*)view inVC:(id)vc withSubViews:(BOOL)isSubViews{
  for (UIView* sview in view.subviews)
  {
    if([sview isKindOfClass:[UITextField class]])
    {
      UITextField* textField = (UITextField*)sview;
      [textField setDelegate:vc];
    }
    if(isSubViews)
    {
      [SDYStyleManager addTextFieldDelegate:sview inVC:vc withSubViews:isSubViews];
    }
  }
}

+(void)decorateLoginView:(UIView*)view inVC:(SDYViewController*)vc{
  [view.superview setBackgroundColor:SDYColorGrayListBack];
  [view setBackgroundColor:SDYColorWhite];
  [view setFrame:CGRectMake(view.frame.origin.x, (view.superview.frame.size.height-NAVBAR_HEIGHT-view.frame.size.height)/2, view.frame.size.width, view.frame.size.height)];
  view.layer.cornerRadius = 6;
  view.layer.masksToBounds = NO;
  view.layer.shadowOffset = CGSizeMake(2,2);
  view.layer.shadowRadius = 2;
  view.layer.shadowOpacity = 0.5;
  [SDYStyleManager decorateAppStyle:view withSubViews:YES];
  
  [SDYStyleManager addTextFieldDelegate:view inVC:vc withSubViews:NO];
}

+(void)decorateVerifyView:(UIView*)view inVC:(SDYViewController*)vc{
  [view.superview setBackgroundColor:SDYColorWhite];
  [view setBackgroundColor:SDYColorWhite];
  if(view.frame.size.height<view.superview.frame.size.height-NAVBAR_HEIGHT){
    [view setFrame:CGRectMake(view.frame.origin.x, (view.superview.frame.size.height-NAVBAR_HEIGHT-view.frame.size.height)/2, view.frame.size.width, view.frame.size.height)];
  }
  else{
    [view setFrame:CGRectMake(view.frame.origin.x, 0, view.frame.size.width, view.frame.size.height)];
    UIView* superview = view.superview;
    if([superview isKindOfClass:[UIScrollView class]]){
      UIScrollView* scrollview = (UIScrollView*)superview;
      [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width, view.frame.size.height)];
      [scrollview setShowsVerticalScrollIndicator:YES];
    }
  }
  [SDYStyleManager decorateAppStyle:view withSubViews:YES];
  
  [SDYStyleManager addTextFieldDelegate:view inVC:vc withSubViews:YES];
}

+(void)decorateTableView:(UIView*)view inVC:(UIViewController*)vc
{
//  [view setBackgroundColor:SDYColorGrayTableViewBack];
  [SDYStyleManager decorateAppStyle:view withSubViews:YES];
  [SDYStyleManager addTextFieldDelegate:view inVC:vc withSubViews:YES];
}


+(void)decorateUserIconImageView:(UIImageView*)view withUser:(NSString*)phoneNumber{
  view.layer.cornerRadius = view.frame.size.height /2;
  view.layer.masksToBounds = YES;
  view.layer.borderWidth = 2;
  view.layer.borderColor = [SDYColorWhite CGColor];
  
  NSString* filePath = [[SDYEnvironment environment] userIconPath:phoneNumber];
  UIImage* faceIcon;
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    faceIcon = [[UIImage alloc] initWithContentsOfFile:filePath];
  }
  
  if(!faceIcon){
    faceIcon = [UIImage imageNamed:@"user"];
  }
  [view setImage:faceIcon];
}


@end
