//
//  TSPhotoCollectionViewFlowLayout.m
//  sdy
//
//  Created by 王俊 on 16/6/24.
//  Copyright © 2016年 HPE. All rights reserved.
//

#import "TSPhotoCollectionViewFlowLayout.h"

@interface TSPhotoCollectionViewFlowLayout ()
{
    UICollectionViewLayoutAttributes * _decorationAttributes;
}

@end

@implementation TSPhotoCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup {
    UINib* nib = [UINib nibWithNibName:@"TSPhotoTitleLabel" bundle:nil];
    [self registerNib:nib forDecorationViewOfKind:@"title"];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    if (sections > 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        UICollectionViewLayoutAttributes *itemAttributes;
        CGRect decorationFrame;
        
        _decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"title" withIndexPath:indexPath];
        decorationFrame = _decorationAttributes.frame;
        itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        decorationFrame.origin.x = 25;
        decorationFrame.origin.y = itemAttributes.frame.origin.y;
        _decorationAttributes.frame = decorationFrame;
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray* group = [NSMutableArray arrayWithArray:array];
    
    if (CGRectIntersectsRect(rect, _decorationAttributes.frame)) {
        [group addObject:_decorationAttributes];
    }
    
    return group;
}

//- (UICollectionViewLayoutAttributes * _Nullable)layoutAttributesForDecorationViewOfKind:(NSString * _Nonnull)decorationViewKind
//                                                                            atIndexPath:(NSIndexPath * _Nonnull)indexPath {
//    NSLog(@"xxx");
//    return _decorationAttributes;
//}

@end
