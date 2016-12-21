//
//  TSRechargeCollectionViewLayout.m
//  sdy
//
//  Created by 王俊 on 16/7/15.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSRechargeCollectionViewLayout.h"
#import "TSRechargeCollectionDecorationView.h"

static NSString* const CellBackground = @"CellBackground";

@interface TSRechargeCollectionViewLayout ()
{
    NSMutableArray* _attributesGroup;
}

@end

@implementation TSRechargeCollectionViewLayout

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerDecorationView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerDecorationView];
    }
    return self;
}

- (void)registerDecorationView {
    [self registerClass:[TSRechargeCollectionDecorationView class] forDecorationViewOfKind:CellBackground];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    _attributesGroup = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    NSIndexPath* indexPathOfDecoration = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *decorationAttributes, *lastAttributes;
    
    decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:CellBackground withIndexPath:indexPathOfDecoration];
    lastAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:items-1 inSection:0]];
    
    CGFloat y = 0;
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = CGRectGetMaxY(lastAttributes.frame) + 18;
    decorationAttributes.frame = CGRectMake(0, y, width, height);
    decorationAttributes.zIndex = -1;
    
    [_attributesGroup addObject:decorationAttributes];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray* group = [NSMutableArray arrayWithArray:array];
    
    for (UICollectionViewLayoutAttributes* attributes in _attributesGroup) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [group addObject:attributes];
        }
    }
    
    return group;
}

@end
