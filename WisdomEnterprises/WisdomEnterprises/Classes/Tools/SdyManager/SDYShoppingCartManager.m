//
//  SDYShoppingCartManager.m
//  sdy
//
//  Created by Bode Smile on 14/11/3.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYShoppingCartManager.h"

@implementation SDYShoppingCartManager

+(SDYShoppingCartManager*)shoppingCart{
    static SDYShoppingCartManager* shoppingCart;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shoppingCart = [[SDYShoppingCartManager alloc] init];
    });
    return shoppingCart;
}

+(NSString*)getGoodsCode:(NSDictionary*)goods withGoodsProp:(NSDictionary*)goodsProp{
    if(goodsProp){
        return [NSString stringWithFormat:@"%@_%@",goods[@"goodsCode"],goodsProp[@"goodsPropId"]];
    }
    return goods[@"goodsCode"];
}

-(id)init{
    if (self = [super init]){
        self.merchantList = [[NSMutableDictionary alloc] init];
        self.goodsList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)clearCart:(NSString*)type{
    [self.merchantList removeAllObjects];
    [self.goodsList removeAllObjects];
    self.type = type;
}

-(void)resetCart:(NSString*)type{
    [self clearCart:type];
    [self loadCart:type];
}

- (int)add:(NSDictionary*)goods withGoodsDiscountList:(NSArray*)goodsDiscountList GoodsProp:(NSDictionary*)goodsProp inMerchant:(NSDictionary*)merchant freightAmt:(NSString*)freightAmt freeFreightAmt:(NSString *)freeFreightAmt deliverySet:(NSDictionary *)deliverySet{
    if(!merchant || !goods)
        return -1;
    if(!self.merchantList[merchant[@"merchantCode"]]){
        self.merchantList[merchant[@"merchantCode"]] = merchant;
    }
    if(!goodsDiscountList){
        goodsDiscountList = @[];
    }
    
    NSNumber * isOneMoreTime = [NSNumber numberWithBool:!self.oneMoreTime];
    
    NSString* goodsCode = [SDYShoppingCartManager getGoodsCode:goods withGoodsProp:goodsProp];
    if(!self.goodsList[goodsCode]){
        NSMutableDictionary* goodsInfo = [@{@"goods":goods,@"goodsDiscountList":goodsDiscountList,@"merchantCode":merchant[@"merchantCode"],@"Count":isOneMoreTime,@"Selected":@YES,@"freightAmt":freightAmt,@"freeFreightAmt":freeFreightAmt} mutableCopy];
        if(goodsProp){
            goodsInfo[@"goodsProp"] = goodsProp;
        }
        if(deliverySet){
            goodsInfo[@"deliverySet"] = deliverySet;
        }
        self.goodsList[goodsCode] = goodsInfo;
    }
    [self saveCart:self.type];
    return (int)[self.goodsList count];
}

//添加洗衣数量和leibie
- (int)add:(NSDictionary*)goods inMerchant:(NSDictionary*)merchant
{
    if(!goods)
        return -1;
    if(!self.merchantList[goods[@"merchantCode"]]){
        self.merchantList[merchant[@"merchantCode"]] = merchant;
    }
    if(!self.goodsList[goods[@"goodsCode"]])
    {
        NSMutableDictionary* goodsInfo = [@{@"goods":goods,@"merchantCode":merchant[@"merchantCode"],@"Count":@1,@"Selected":@YES} mutableCopy];
        
        self.goodsList[goods[@"goodsCode"]] = goodsInfo;
    }
    [self saveCart:self.type];
    
    return (int)[self.goodsList count];
}

-(BOOL)isGoodsInCart:(NSString*)goodsCode{
    if(!goodsCode || !self.goodsList[goodsCode])
        return NO;
    return YES;
}
-(NSArray *)goodsInCart:(NSString *)goodsCode
{
    NSMutableArray *goodsInCartArray=[[NSMutableArray alloc]init];
    NSArray *array=[self.goodsList allKeys];
    for (int i=0; i<array.count; i++)
    {
        NSArray *goodCodeArray=[array[i] componentsSeparatedByString:@"_"];
        if ([goodsCode isEqualToString:goodCodeArray[0]])
        {
            if (self.goodsList[array[i]][@"goodsProp"])
            {
                [goodsInCartArray addObject:self.goodsList[array[i]]];
            }
        }
    }
    
    return goodsInCartArray;
}

//返回某一个商品的数量
-(int)quantityGoodsInCart:(NSString *)goodsCode
{
    NSDictionary *dic= self.goodsList[goodsCode];
    return [dic[@"Count"] intValue];
}

-(int)quantityGoodsInAllInCart
{
    int quantity=0;
    NSArray *array=[self.goodsList allKeys];
    if (array.count>0)
    {
        
        for (int i=0; i<array.count;i++)
        {
            NSDictionary *dic= self.goodsList[array[i]];
            quantity+=[dic[@"Count"] intValue];
        }
        
    }
    return quantity;
    
}
// 再来一单改变数量
-(void)oneMoreTimechangeGoods:(NSString *)goodsCode count:(int)dx
{
    int quantity = 0;
    
    if ([[SDYShoppingCartManager shoppingCart] quantityGoodsInCart:goodsCode]) {
        
        quantity = [[SDYShoppingCartManager shoppingCart] quantityGoodsInCart:goodsCode];
    }
    
    if(!goodsCode || !self.goodsList[goodsCode])
    {
        
    }
    
    NSMutableDictionary* goodsInfo =[NSMutableDictionary dictionaryWithDictionary: self.goodsList[goodsCode]];
    int newCount;
    newCount = [goodsInfo[@"Count"] intValue]+dx;
    newCount = newCount<=0?1:newCount;
    goodsInfo[@"Count"] = [NSNumber numberWithInt:newCount];
    [self.goodsList setObject:goodsInfo forKey:goodsCode];
    [self saveCart:self.type];
    
    
}

-(int)changeGoods:(NSString*)goodsCode count:(int)dx{
    if(!goodsCode || !self.goodsList[goodsCode])
        return 0;
    NSMutableDictionary* goodsInfo =[NSMutableDictionary dictionaryWithDictionary: self.goodsList[goodsCode]];
    int newCount;
    newCount = [goodsInfo[@"Count"] intValue]+dx;
    newCount = newCount<=0?1:newCount;
    goodsInfo[@"Count"] = [NSNumber numberWithInt:newCount];
    [self.goodsList setObject:goodsInfo forKey:goodsCode];
    [self saveCart:self.type];
    return newCount;
}
-(int)changeTextFieldGoods:(NSString*)goodsCode count:(int)dx{
    if(!goodsCode || !self.goodsList[goodsCode])
        return 0;
    NSMutableDictionary* goodsInfo = [NSMutableDictionary dictionaryWithDictionary:self.goodsList[goodsCode]];
    goodsInfo[@"Count"] = [NSNumber numberWithInt:dx];
    [self.goodsList setObject:goodsInfo forKey:goodsCode];
    [self saveCart:self.type];
    return dx;
}
-(void)selectGoods:(NSString*)goodsCode selected:(BOOL)selected{
    NSMutableDictionary* goodsInfo = self.goodsList[goodsCode];
    goodsInfo[@"Selected"] = [NSNumber numberWithBool:selected];
    [self saveCart:self.type];
}
-(void)selectMerchant:(NSString*)merchantCode selected:(BOOL)selected{
    NSArray* goods = [self allGoodsInMerchant:merchantCode];
    for (NSDictionary* goodsInfo in goods) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            [self selectGoods:[SDYShoppingCartManager getGoodsCode:goodsInfo[@"goods"] withGoodsProp:goodsInfo[@"goodsProp"]] selected:selected];
        }
    }
}
-(BOOL)isGoodsSelected:(NSString*)goodsCode{
    NSMutableDictionary* goodsInfo = self.goodsList[goodsCode];
    BOOL Selected = [goodsInfo[@"Selected"] boolValue];
    return Selected;
}
-(BOOL)isMerchantSelected:(NSString*)merchantCode{
    NSArray* goods = [self allGoodsInMerchant:merchantCode];
    for (NSDictionary* goodsInfo in goods) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            if(![self isGoodsSelected:[SDYShoppingCartManager getGoodsCode:goodsInfo[@"goods"] withGoodsProp:goodsInfo[@"goodsProp"]]])
                return NO;
        }
    }
    return YES;
}

-(BOOL)remove:(NSString*)goodsCode{
    if(!goodsCode || !self.goodsList[goodsCode])
        return NO;
    NSString* merchantCode = self.goodsList[goodsCode][@"merchantCode"];
    [self.goodsList removeObjectForKey:goodsCode];
    NSArray* goods = [self allGoodsInMerchant:merchantCode];
    if(!goods || [goods count]==0){
        [self.merchantList removeObjectForKey:merchantCode];
    }
    [self saveCart:self.type];
    return YES;
}

-(BOOL)removeMerchant:(NSString*)merchantCode{
    if(!merchantCode || !self.merchantList[merchantCode])
        return NO;
    NSArray* goods = [self allGoodsInMerchant:merchantCode];
    for (NSDictionary* goodsInfo in goods) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            [self.goodsList removeObjectForKey:[SDYShoppingCartManager getGoodsCode:goodsInfo[@"goods"] withGoodsProp:goodsInfo[@"goodsProp"]]];
        }
    }
    [self.merchantList removeObjectForKey:merchantCode];
    [self saveCart:self.type];
    return YES;
}

-(NSArray*)allGoodsInMerchant:(NSString*)merchantCode{
    __autoreleasing NSMutableArray* goods = [@[] mutableCopy];
    for (NSDictionary* goodsInfo in [self.goodsList allValues]) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            [goods addObject:goodsInfo];
        }
    }
    return goods;
}

+(NSDictionary*)countGoods:(NSArray*)goods{
    double totalPrice = 0;
    int itemCount = 0;
    double packagePrice=0;
    for (NSDictionary* goodsInfo in goods) {
        BOOL selected = [goodsInfo[@"Selected"] boolValue];
        if(selected){
            NSDictionary* goods = goodsInfo[@"goods"];
            NSDictionary* goodsProp = goodsInfo[@"goodsProp"];
            NSNumber* count = goodsInfo[@"Count"];
            if (goodsProp) {
                totalPrice+= [goodsProp[@"goodsPrice"] doubleValue]*[count intValue];
            }
            else
            {
                totalPrice+= [goods[@"goodsCost"] doubleValue]*[count intValue];
            }
            if (goods[@"packCharge"])
            {
                totalPrice+=[goods[@"packCharge"] doubleValue]*[count intValue];
                packagePrice+=[goods[@"packCharge"] doubleValue]*[count intValue];
            }
            itemCount += [count intValue];
        }
    }
    __autoreleasing NSDictionary* result = @{@"totalPrice":[NSNumber numberWithDouble:totalPrice],@"itemCount":[NSNumber numberWithInt:itemCount],@"packageMoney":[NSNumber numberWithDouble:packagePrice]};
    return result;
}

-(BOOL)isMerchantHasAnySelected:(NSString*)merchantCode{
    NSArray* goods = [self allGoodsInMerchant:merchantCode];
    for (NSDictionary* goodsInfo in goods) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            if([self isGoodsSelected:[SDYShoppingCartManager getGoodsCode:goodsInfo[@"goods"] withGoodsProp:goodsInfo[@"goodsProp"]]])
                return YES;
        }
    }
    return NO;
}

-(NSArray*)allSelectedMerchantList{
    __autoreleasing NSMutableArray* selectedMerchantList = [@[] mutableCopy];
    for (NSString* merchantCode in self.merchantList.allKeys) {
        if([self isMerchantHasAnySelected:merchantCode]){
            [selectedMerchantList addObject:merchantCode];
        }
    }
    return selectedMerchantList;
}

-(NSArray*)allSelectedGoodsInMerchant:(NSString*)merchantCode{
    __autoreleasing NSMutableArray* goods = [@[] mutableCopy];
    for (NSDictionary* goodsInfo in [self.goodsList allValues]) {
        if([goodsInfo[@"goods"][@"merchantCode"] isEqualToString:merchantCode]){
            if([goodsInfo[@"Selected"] boolValue]){
                [goods addObject:goodsInfo];
            }
        }
    }
    return goods;
}

-(NSArray*)allSelectedGoodsList{
    __autoreleasing NSMutableArray* goods = [@[] mutableCopy];
    for (NSDictionary* goodsInfo in [self.goodsList allValues]) {
        if([goodsInfo[@"Selected"] boolValue]){
            [goods addObject:goodsInfo];
        }
    }
    return goods;
}

-(BOOL)removeAllSelectedGoods{
    for (NSString* goodsCode in [self.goodsList allKeys]) {
        NSDictionary* goodsInfo  = self.goodsList[goodsCode];
        if([goodsInfo[@"Selected"] boolValue]){
            [self remove:goodsCode];
        }
    }
    return YES;
}

-(void)saveCart:(NSString*)cartName
{
    NSDictionary* cartSaved = @{@"merchantList":self.merchantList,@"goodsList":self.goodsList,@"type":self.type};
    //[JNKeychain saveValue:cartSaved forKey:[NSString stringWithFormat:@"CART_%@",cartName]];
    
    [[NSUserDefaults standardUserDefaults] setObject:cartSaved forKey:[NSString stringWithFormat:@"CART_%@",cartName]];
}

-(BOOL)loadCart:(NSString*)cartName
{
    //NSDictionary* cartLoaded = [JNKeychain loadValueForKey:[NSString stringWithFormat:@"CART_%@",cartName]];
    NSDictionary* cartLoaded = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"CART_%@",cartName]];
    // NSLog(@"%@",cartLoaded);
    if(cartLoaded)
    {
        self.merchantList = [cartLoaded[@"merchantList"] mutableCopy];
        
        // 下面加载goods list时注意，后面购物车选择商品时，可能会修改深处的节点，所以必须将内部的字典也变成mutable
        NSDictionary* goodsList = cartLoaded[@"goodsList"];
        self.goodsList = [NSMutableDictionary dictionary];
        
        [goodsList enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            self.goodsList[key] = [obj mutableCopy];
        }];
        
        self.type = cartLoaded[@"type"];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
