//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXPromise.h"

typedef void (^DTVoidMessageBlock)(id message);
typedef RXPromise *(^DTFutureMessageBlock)(id message);
typedef id (^DTResultMessageBlock)(id message);

static NSString *DTActorsErrorDomain = @"drimtrip.actors.error";
static NSString *DTActorsErrorMessageKey = @"DTActorsErrorMessageKey";