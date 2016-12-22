//
//  SelectedImage.h
//  EFamilyEducation
//
//  Created by mac on 16/3/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SelectedImage : NSObject

@property (nonatomic,copy)NSString * url;

@property (nonatomic,strong)UIImage * image;

@property (nonatomic,strong)UIImageView * imageView;

@end
