//
//  SDYShoppingCartManager.h
//  sdy
//
//  Created by Bode Smile on 14/11/3.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDYShoppingCartManager : NSObject

// 是否是再来一单
@property (nonatomic,assign)BOOL oneMoreTime;

+(SDYShoppingCartManager*)shoppingCart;
//获得带规格的GoodsCode
+(NSString*)getGoodsCode:(NSDictionary*)goods withGoodsProp:(NSDictionary*)goodsProp;

@property (strong, nonatomic) NSMutableDictionary* merchantList; //merchantCode:merchant
@property (strong, nonatomic) NSMutableDictionary* goodsList; //goodsCode:{@"goods":goods,@"goodsDiscountList":goodsDiscountList,@"merchantCode":merchantCode,@"Count":count}
@property (strong, nonatomic) NSString* type;

//清空购物车
-(void)clearCart:(NSString*)type;
//重置购物车，并载入之前的商品
-(void)resetCart:(NSString*)type;
//返回购物车容量
//-(int)add:(NSDictionary*)goods withGoodsDiscountList:(NSArray*)goodsDiscountList  GoodsProp:(NSDictionary*)goodsProp inMerchant:(NSDictionary*)merchant;
-(int)add:(NSDictionary*)goods withGoodsDiscountList:(NSArray*)goodsDiscountList GoodsProp:(NSDictionary*)goodsProp inMerchant:(NSDictionary*)merchant freightAmt:(NSString*)freightAmt freeFreightAmt:(NSString *)freeFreightAmt deliverySet:(NSDictionary *)deliverySet;

//判断是否商品在购物车
-(BOOL)isGoodsInCart:(NSString*)goodsCode;
//返回购物车中商品的不同口味
-(NSArray *)goodsInCart:(NSString *)goodsCode;
//返回商品的数量
-(int)quantityGoodsInCart:(NSString *)goodsCode;
//返回一个我在一个商家选择的商品的总数量
-(int)quantityGoodsInAllInCart;
//根据加减按钮修改商品数量
-(int)changeGoods:(NSString*)goodsCode count:(int)dx;
//根据数量输入框修改商品数量
-(int)changeTextFieldGoods:(NSString*)goodsCode count:(int)dx;
//选中商品或商铺
-(void)selectGoods:(NSString*)goodsCode selected:(BOOL)selected;
-(void)selectMerchant:(NSString*)merchantCode selected:(BOOL)selected;
-(BOOL)isGoodsSelected:(NSString*)goodsCode;
-(BOOL)isMerchantSelected:(NSString*)merchantCode;
//删除一个商品
-(BOOL)remove:(NSString*)goodsCode;
//删除一个商家，以及所有包含的商品
-(BOOL)removeMerchant:(NSString*)merchantCode;
//获得店家对应的所有商品
-(NSArray*)allGoodsInMerchant:(NSString*)merchantCode;
//获得一个商品组所有选中的总价和总个数
+(NSDictionary*)countGoods:(NSArray*)goods;

//返回已选择过商品的商家和商品，用于生成订单
-(NSArray*)allSelectedMerchantList;
-(NSArray*)allSelectedGoodsInMerchant:(NSString*)merchantCode;
-(NSArray*)allSelectedGoodsList;
//删除所有已选的商品，在生成订单后使用
-(BOOL)removeAllSelectedGoods;

-(void)saveCart:(NSString*)cartName;
-(BOOL)loadCart:(NSString*)cartName;
//添加洗衣数量和leibie
-(int)add:(NSDictionary*)goods inMerchant:(NSDictionary*)merchant;

@end
