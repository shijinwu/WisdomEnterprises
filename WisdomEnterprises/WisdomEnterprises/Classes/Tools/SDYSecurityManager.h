//
//  SDYSecurityManager.h
//  sdy
//
//  Created by BodeMeng on 14-9-16.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDYSecurityManager : NSObject

+(SDYSecurityManager*)defaultManager;

-(NSData*)changeStringToKey:(NSString*)stringkey;
-(NSString*)hashString:(NSString*) text;
-(NSString*)encrypt:(NSString*)text Key:(NSData*)key;
-(NSString*)decrypt:(NSString*)text Key:(NSData*)key;

-(NSString*)encrypt:(NSString*)text keyString:(NSString*)key;
-(NSString*)decrypt:(NSString*)text keyString:(NSString*)key;

-(NSString*)encode:(NSData*) data;
-(NSData*)decode:(NSString*) text;
-(NSData*) encryptString:(NSString*) inputString key: (NSData*) key;
-(NSString*) decryptString:(NSData*) input key:(NSData*) key;

@end
