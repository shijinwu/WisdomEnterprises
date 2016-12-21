//
//  BODEJSON.m
//  sdy
//
//  Created by BodeMeng on 15/4/10.
//  Copyright (c) 2015年 Bode Smile. All rights reserved.
//

#import "BODEJSON.h"
#import <Foundation/NSJSONSerialization.h>

@implementation NSArray (BODEJSONSerializing)

- (NSString*)toJSONString
{
  NSError* error = nil;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  
  if (error != nil) {
    NSLog(@"NSArray JSONString error: %@", [error localizedDescription]);
    return nil;
  } else {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
}

@end

@implementation NSDictionary (BODEJSONSerializing)

- (NSString*)toJSONString
{
  NSError* error = nil;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  
  if (error != nil) {
    NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
    return nil;
  } else {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
}

@end

@implementation NSString (BODEJSONSerializing)

- (id)toJSONObject
{
  NSError* error = nil;
  id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
  
  if (error != nil) {
    NSLog(@"NSString JSONObject error: %@", [error localizedDescription]);
  }
  
  return object;
}

@end

