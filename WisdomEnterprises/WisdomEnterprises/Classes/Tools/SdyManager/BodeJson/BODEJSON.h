//
//  BODEJSON.h
//  sdy
//
//  Created by BodeMeng on 15/4/10.
//  Copyright (c) 2015年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BODEJSONSerializing)
- (NSString*)toJSONString;
@end

@interface NSDictionary (BODEJSONSerializing)
- (NSString*)toJSONString;
@end

@interface NSString (BODEJSONSerializing)
- (id)toJSONObject;
@end
