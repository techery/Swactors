//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorConstants.h"

@protocol DTActorHandler;

@interface DTBaseOperation : NSOperation
- (void)finish;
@end

@interface DTActorOperation : DTBaseOperation

@property(nonatomic, readonly) RXPromise *promise;

- (instancetype)initWithMessage:(id)message handler:(id<DTActorHandler>)handler;

@end
