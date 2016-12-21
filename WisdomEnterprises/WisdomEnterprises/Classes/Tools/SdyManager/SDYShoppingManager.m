//
//  SDYShoppingManager.m
//  sdy
//
//  Created by mac on 16/10/27.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "SDYShoppingManager.h"
#import "UIViewController+SDYPublicViewController.h"
#import "Reachability.h"
#import "SDYHTTPManager.h"
#import "SDYAccountManager.h"
#import "SDYShoppingCartManager.h"
#import "MBProgressHUD.h"
@interface SDYShoppingManager ()
{
 NSMutableDictionary* sizeList;
 NSMutableDictionary* sizeListSelected;
 NSArray * goodsPropList;
}



@end

@implementation SDYShoppingManager

+(instancetype)shareManager
{
    static SDYShoppingManager * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SDYShoppingManager alloc]init];
    });
    return manager;
}

-(void)getOneMoreTimeOrderInfo:(NSDictionary *)dic Controller:(UIViewController*)vc
{
    
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:@"没有网络连接，请检查设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    [SDYShoppingCartManager shoppingCart].oneMoreTime = YES;
    // 商品列表
    NSArray * goodsList = dic[@"goodsList"];
    
    NSDictionary * deliverySetDic = dic[@"deliverySet"];
    
    
    NSArray  * goodsDiscountListArray = dic[@"goodsDiscountList"];
    
    
    NSArray * orderGoodsBeanList = dic[@"orderGoodsBeanList"];
    
    
    static int j = 0;
    
    
    for (int i = 0; i < goodsList.count; i++) {
    
        __block NSString * memo = @"";
        __block  NSString * freeFreightAmtMoney = @"";
        __block  NSString * freightAmtMoney = @"";
        
         NSArray *   goodsDiscountList;
     
        // 商品
        NSDictionary * goods = goodsList[i];
        
        // 商品折扣列表
        if (goodsDiscountListArray.count > 0)
        {
            goodsDiscountList = goodsDiscountListArray[i];
        }else
        {
            goodsDiscountList = @[];
        }
        
       
        
       NSDictionary * goodsPropDic =  orderGoodsBeanList[i];
   
        // PropList
        if (goodsPropDic[@"goodsProp"]) {
            
            goodsPropList = @[goodsPropDic[@"goodsProp"]];
        }
        else
        {
            goodsPropList = @[];
        }

        // 商品编号
        NSString * goodsCode =goods[@"goodsCode"];
        
        NSMutableDictionary * goodsInfo = [NSMutableDictionary dictionary];
        
        [goodsInfo setObject:goodsList[i] forKey:@"goods"];
        
        [goodsInfo setObject:dic[@"merchant"] forKey:@"merchant"];
     
       
        NSLog(@"document =%@ ",NSHomeDirectory());
        
     
           
            if (deliverySetDic)
            {
                NSDictionary *dic1 = deliverySetDic[@"deliverySet"];
                freightAmtMoney = _CHECK_NIL(dic1[@"freightAmt"]);
                freeFreightAmtMoney = _CHECK_NIL(dic1[@"freeFreightAmt"]);
                memo = _CHECK_NIL(dic1[@"memo"]);
      
                NSMutableArray*tempArray=[goodsPropList mutableCopy];
                [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSDictionary *a = (NSDictionary *)obj1;
                    NSDictionary *b = (NSDictionary *)obj2;
                    
                    CGFloat aNum = [a[@"goodsPrice"] floatValue];
                    CGFloat bNum = [b[@"goodsPrice"] floatValue];
                    
                    if (aNum > bNum) {
                        return NSOrderedDescending;
                    }
                    else if (aNum < bNum){
                        return NSOrderedAscending;
                    }
                    else {
                        return NSOrderedSame;
                    }
                }];

                
                goodsPropList=[tempArray mutableCopy];
                
                if (goodsPropList.count>0)
                {
                    NSMutableArray* goodsColorList = [[NSMutableArray alloc] init];
                    NSMutableArray* goodsSpecList = [[NSMutableArray alloc] init];
                    NSMutableArray* goodsTasteList = [[NSMutableArray alloc] init];
                
                    [goodsPropList enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull goodsProp, NSUInteger idx, BOOL * _Nonnull stop) {
                        id goodsColor = goodsProp[@"goodsColor"];
                        id goodsSpec = goodsProp[@"goodsSpec"];
                        id goodsTaste = goodsProp[@"goodsTaste"];
                        
                        if (goodsColor)
                        {
                            if (![goodsColorList containsObject:goodsColor])
                            {
                                [goodsColorList addObject:goodsColor];
                            }
                        }
                        if(goodsProp[@"goodsSpec"])
                        {
                            if (![goodsSpecList containsObject:goodsSpec])
                            {
                                [goodsSpecList addObject:goodsSpec];
                            }
                        }
                        
                        if(goodsProp[@"goodsTaste"])
                        {
                            if (![goodsTasteList containsObject:goodsTaste])
                            {
                                [goodsTasteList addObject:goodsTaste];
                            }
                        }
                    }];
                    
                    if(goodsColorList.count>1){
                        sizeList[@"goodsColor"] = goodsColorList;
                        sizeListSelected[@"goodsColor"] = @0;
                    }
                    if(goodsSpecList.count>1){
                        sizeList[@"goodsSpec"] = goodsSpecList ;
                        sizeListSelected[@"goodsSpec"] = @0;
                    }
                    if(goodsTasteList.count>1){
                        sizeList[@"goodsTaste"] = goodsTasteList ;
                        sizeListSelected[@"goodsTaste"] = @0;
                    }
                }

                int count = [dic[@"orderGoodsBeanList"][i][@"orderGoods"][@"goodsCount"] intValue];
                
                
                if (count < [goodsList[i][@"goodsCount"] intValue]) {
                    
                   NSDictionary* currentProp = [self getGoodsProp];
                    
                    // 原来购物车中商品的数量
                    int quantity = 0;
                  
                    if ([[SDYShoppingCartManager shoppingCart]isGoodsInCart:goodsList[i][@"goodsCode"]]) {
                      
                     quantity = [[SDYShoppingCartManager shoppingCart] quantityGoodsInCart:goodsCode];
                        
                    }
        
                     [[SDYShoppingCartManager shoppingCart] add:goodsList[i] withGoodsDiscountList:goodsDiscountList GoodsProp:currentProp inMerchant:dic[@"merchant"] freightAmt:freightAmtMoney freeFreightAmt:freeFreightAmtMoney deliverySet:dic1];
                    
                    [[SDYShoppingCartManager shoppingCart]changeGoods:goodsCode count:(count)];
                    
                    
                    if (i == (goodsList.count-1)) {
                       
                       [SDYShoppingCartManager shoppingCart].oneMoreTime = NO;
                     
                            MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                            HUD.mode = MBProgressHUDModeText;
                            HUD.labelText = @"添加到购物车成功";
                            [HUD hide:YES afterDelay:2];
                      
                        
                      
                    }
                    
                }
                else
                {
                    
                    j++;
                    
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"商品库存不足" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                
                
                
                
            }

    

 
        
    }
    
}

/**
 * 获取当前规格
 */
- (NSDictionary*)getGoodsProp {
    if (sizeList.count > 0) {
        NSString* goodsColor = sizeList[@"goodsColor"]?sizeList[@"goodsColor"][[sizeListSelected[@"goodsColor"] integerValue]]:nil;
        NSString* goodsSpec = sizeList[@"goodsSpec"]?sizeList[@"goodsSpec"][[sizeListSelected[@"goodsSpec"] integerValue]]:nil;
        NSString* goodsTaste = sizeList[@"goodsTaste"]?sizeList[@"goodsTaste"][[sizeListSelected[@"goodsTaste"] integerValue]]:nil;
        for (NSDictionary* goodsProp in goodsPropList)
        {
            if (!goodsColor || [goodsColor isEqualToString:goodsProp[@"goodsColor"]])
            {
                if (!goodsSpec || [goodsSpec isEqualToString:goodsProp[@"goodsSpec"]])
                {
                    if (!goodsTaste || [goodsTaste isEqualToString:goodsProp[@"goodsTaste"]])
                    {
                        return goodsProp;
                    }
                }
            }
        }
    }
    return nil;
}

@end
