//
//  TSWashingBasketManager.m
//  sdy
//
//  Created by 王俊 on 16/7/7.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSWashingBasketManager.h"

@implementation TSWashingBasketManager

+ (TSWashingBasketManager*)manager {
    static TSWashingBasketManager* shoppingCart;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shoppingCart = [[TSWashingBasketManager alloc] init];
    });
    return shoppingCart;
}

- (id)init {
    if (self = [super init]) {
        self.goodsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)loadBasket
{
    NSArray* cartLoaded = [[NSUserDefaults standardUserDefaults] objectForKey:@"WashingBasket"];

    if (cartLoaded)
    {
        self.goodsList = [[NSMutableArray alloc] init];
        
        for (NSDictionary* goods  in cartLoaded) {
            [self.goodsList addObject:[goods mutableCopy]];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)saveBasket
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.goodsList forKey:@"WashingBasket"];
    [userDefaults synchronize];
}

- (int)addGoods:(NSDictionary*)newGoods
{
    if (!newGoods)
        return -1;

    for (NSDictionary* goods in self.goodsList) {
        NSDictionary* innerGoods = goods[@"goods"];
        if ([innerGoods[@"goodsCode"] isEqualToString:newGoods[@"goodsCode"]]) {
            return TSWashingBasketManagerErrorExist;
        }
    }
    
    NSMutableDictionary* goodsInfo = [@{@"goods":newGoods,@"merchantCode":newGoods[@"merchantCode"],@"Count":@1,@"Selected":@YES} mutableCopy];
    
    [self.goodsList addObject:goodsInfo];
    
    [self saveBasket];
    
    return (int)[self.goodsList count];
}

- (int)changeGoods:(NSMutableDictionary*)goods addCount:(int)dx {
    if (!goods || ![self.goodsList containsObject:goods])
        return 0;
    
    int newCount;
    newCount = [goods[@"Count"] intValue]+dx;
    newCount = newCount<=0?1:newCount;
    goods[@"Count"] = [NSNumber numberWithInt:newCount];
    [self saveBasket];
    return newCount;
}

- (NSUInteger)changeGoods:(NSMutableDictionary*)goods count:(NSUInteger)newCount {
    if (!goods || ![self.goodsList containsObject:goods])
        return 0;
    
    goods[@"Count"] = @(newCount);
    [self saveBasket];
    
    return newCount;
}

- (BOOL)removeGoods:(NSMutableDictionary*)goods {
    if (!goods || ![self.goodsList containsObject:goods])
        return NO;
    
    [self.goodsList removeObject:goods];
    [self saveBasket];
    
    return YES;
}

- (void)removeAllGoods {
    [self.goodsList removeAllObjects];
    [self saveBasket];
}

/**
 * 总金额
 */
- (float)amount {
    float amount = 0;
    
    for (NSDictionary* goods in self.goodsList) {
        NSNumber* count = goods[@"Count"];
        NSDictionary* innerGoods = goods[@"goods"];
        NSNumber* goodsCost = innerGoods[@"goodsCost"];
        
        amount += goodsCost.floatValue * count.intValue;
    }
    
    return amount;
}

/**
 * 总件数
 */
- (int)countQtyOfAllItems {
    int countItems = 0;
    
    for (NSDictionary* goods in self.goodsList) {
        NSNumber* count = goods[@"Count"];
        
        countItems += count.intValue;
    }
    
    return countItems;
}

@end
