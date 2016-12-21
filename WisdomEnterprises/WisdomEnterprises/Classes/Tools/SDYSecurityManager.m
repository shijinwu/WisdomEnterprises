//
//  SDYSecurityManager.m
//  sdy
//
//  Created by BodeMeng on 14-9-16.
//  Copyright (c) 2014年 Bode Smile. All rights reserved.
//

#import "SDYSecurityManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

SDYSecurityManager* securityManager;

@implementation SDYSecurityManager

+(SDYSecurityManager*)defaultManager{
  if(!securityManager){
    securityManager = [[SDYSecurityManager alloc] init];
  }
  return securityManager;
}

-(NSData*)changeStringToKey:(NSString*)stringkey{
  //NSData* pkey = [GTMBase64 encodeData:[stringkey dataUsingEncoding:NSUTF8StringEncoding]];
  NSData* pkey = [stringkey dataUsingEncoding:NSUTF8StringEncoding];
  unsigned char key[24];
  int i=0;
  for(;i<[pkey length]&&i<24;i++){
    key[i] = ((const unsigned char*)[pkey bytes])[i];
  }
  for(;i<24;i++){
    key[i] = (unsigned char)i;
  }
  
  __autoreleasing NSData * datakey = [GTMBase64 encodeData:[NSData dataWithBytes:key length:24]];
  //__autoreleasing NSString * output = [[NSString alloc] initWithData:datakey encoding:NSUTF8StringEncoding];
  return datakey;
}

char hexString[] = "0123456789abcdef";

-(NSString*)hashString:(NSString*) text{
  const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:text.length];
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(data.bytes, data.length, digest);
  NSMutableString* result = [[NSMutableString alloc] init];
  for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
    char c1 = hexString[digest[i]/16];
    char c2 = hexString[digest[i]%16];
    [result appendFormat:@"%c%c",c1,c2];
  }
  return result;  
//  NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//  base64 = [GTMBase64 encodeData:base64];
//  __autoreleasing NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//  return output;
}

-(NSString*)encrypt:(NSString*)text Key:(NSData*)key{
  return [self performDESCipher:text Key:key encryptOrDecrypt:kCCEncrypt];
}

-(NSString*)decrypt:(NSString*)text Key:(NSData*)key{
  return [self performDESCipher:text Key:key encryptOrDecrypt:kCCDecrypt];
}

-(NSString*)encrypt:(NSString*)text keyString:(NSString*)key{
  return [self encrypt:text Key:[self changeStringToKey:key]];
}

-(NSString*)decrypt:(NSString*)text keyString:(NSString*)key{
  return [self decrypt:text Key:[self changeStringToKey:key]];
}

-(NSString*)performDESCipher:(NSString*)plainText Key:(NSData*)deskey encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
  const void *vplainText;
  size_t plainTextBufferSize;
  
  if (encryptOrDecrypt == kCCDecrypt)//解密
  {
    NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
    plainTextBufferSize = [EncryptData length];
    vplainText = [EncryptData bytes];
  }
  else //加密
  {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
  }
  
  CCCryptorStatus ccStatus;
  uint8_t *bufferPtr = NULL;
  size_t bufferPtrSize = 0;
  size_t movedBytes = 0;
  
  bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
  bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
  memset((void *)bufferPtr, 0x0, bufferPtrSize);
  // memset((void *) iv, 0x0, (size_t) sizeof(iv));
  
  NSData *deskeyData = [GTMBase64 decodeData:deskey];
  const void *vkey = (const void *)[deskeyData bytes];
  
  // NSString *initVec = @"init Vec";
  //const void *vinitVec = (const void *) [initVec UTF8String];
  //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
  ccStatus = CCCrypt(encryptOrDecrypt,
                     kCCAlgorithm3DES,
                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                     vkey,
                     kCCKeySize3DES,
                     nil,
                     vplainText,
                     plainTextBufferSize,
                     (void *)bufferPtr,
                     bufferPtrSize,
                     &movedBytes);
  //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
  /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
   else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
   else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
   else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
   else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
   else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
  
  __autoreleasing NSString *result;
  
  if (encryptOrDecrypt == kCCDecrypt)
  {
    result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                           length:(NSUInteger)movedBytes]
                                   encoding:NSUTF8StringEncoding]
    ;
  }
  else
  {
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    result = [GTMBase64 stringByEncodingData:myData];
  }
  free(bufferPtr);
  
  return result;
}

-(NSData*)performDESBytes:(NSData*)data Key:(NSData*)deskey encryptOrDecrypt:(CCOperation)encryptOrDecrypt{
  const void *vplainText=[data bytes];
  size_t plainTextBufferSize=data.length;
  
  CCCryptorStatus ccStatus;
  uint8_t *bufferPtr = NULL;
  size_t bufferPtrSize = 0;
  size_t movedBytes = 0;
  
  bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
  bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
  memset((void *)bufferPtr, 0x0, bufferPtrSize);
  // memset((void *) iv, 0x0, (size_t) sizeof(iv));
  
  NSData *deskeyData = [GTMBase64 decodeData:deskey];
  const void *vkey = (const void *)[deskeyData bytes];
  
  // NSString *initVec = @"init Vec";
  //const void *vinitVec = (const void *) [initVec UTF8String];
  //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
  ccStatus = CCCrypt(encryptOrDecrypt,
                     kCCAlgorithm3DES,
                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                     vkey,
                     kCCKeySize3DES,
                     nil,
                     vplainText,
                     plainTextBufferSize,
                     (void *)bufferPtr,
                     bufferPtrSize,
                     &movedBytes);
  //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
  /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
   else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
   else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
   else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
   else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
   else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
  
  __autoreleasing NSData *result;
  
  if (encryptOrDecrypt == kCCDecrypt)
  {
    result = [NSData dataWithBytes:(const void *)bufferPtr
                            length:(NSUInteger)movedBytes];
  }
  else
  {
    result = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
  }
  free(bufferPtr);
  
  return result;
  
}
-(NSString*)encode:(NSData*) data{
  if (data) {
    NSString* re = [GTMBase64 stringByEncodingData:data ];
    return re;
  }
  return nil;
  
}

-(NSData*)decode:(NSString*) text{
  if (text) {
    return  [GTMBase64 decodeString:text ];
    
  }
  return nil;
}
-(NSData*) encryptString:(NSString*) inputString key: (NSData*) key{
  return [self performDESBytes:[inputString dataUsingEncoding:NSUTF8StringEncoding] Key:key encryptOrDecrypt:kCCEncrypt];
}
-(NSString*) decryptString:(NSData*) input key:(NSData*) key{
  NSData* decrpt =[self performDESBytes:input Key:key encryptOrDecrypt:kCCDecrypt];
  if(!decrpt) return nil;
  __autoreleasing NSString* res =[[NSString alloc] initWithData:decrpt encoding:NSUTF8StringEncoding];
  return res;
}


@end
