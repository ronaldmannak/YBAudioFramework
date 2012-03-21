//
//  YBAudioException.h
//  YBAudioUnit
//
//  Created by Martijn Thé on 3/20/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YBAudioThrowIfErr(err) { YBAudioThrow(err, __PRETTY_FUNCTION__, __LINE__); }

void YBAudioThrow(OSStatus errCode, const char *functionInfo, int lineNumber);

const char* YBAudioGetErrorStringFromOSStatus(OSStatus error);