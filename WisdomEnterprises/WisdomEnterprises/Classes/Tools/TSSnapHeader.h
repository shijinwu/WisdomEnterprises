//
//  TSSnapHeader.h
//  sdy
//
//  Created by 王俊 on 16/1/14.
//  Copyright © 2016年 HPE. All rights reserved.
//

#ifndef TSSnapHeader_h
#define TSSnapHeader_h

typedef enum : NSUInteger {
    TSSnapStatusUploaded,
    TSSnapStatusAccepted,
    TSSnapStatusProcessing,
    TSSnapStatusProcessOK,
    TSSnapStatusProcessFailed,
    TSSnapStatusRevoked,
} TSSnapStatus;

#endif /* TSSnapHeader_h */
