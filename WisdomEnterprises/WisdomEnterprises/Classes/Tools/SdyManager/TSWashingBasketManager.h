//
//  TSWashingBasketManager.h
//  sdy
//
//  Created by 王俊 on 16/7/7.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSWashingBasketManagerError) {
    TSWashingBasketManagerErrorExist = -100,// 物品已经存在于洗衣篮中
    TSWashingBasketManagerErrorUnknown,
};

@interface TSWashingBasketManager : NSObject

@property (strong, nonatomic) NSMutableArray<NSMutableDictionary*>* goodsList;

+ (TSWashingBasketManager*)manager;

- (BOOL)loadBasket;
- (void)saveBasket;
- (int)addGoods:(NSDictionary*)newGoods;
- (int)changeGoods:(NSMutableDictionary*)goods addCount:(int)dx;
- (NSUInteger)changeGoods:(NSMutableDictionary*)goods count:(NSUInteger)newCount;
- (BOOL)removeGoods:(NSMutableDictionary*)goods;
- (void)removeAllGoods;

/**
 * 总金额
 */
- (float)amount;

/**
 * 总件数
 */
- (int)countQtyOfAllItems;

@end
