//
//  DTInvocation.h
//  Actors
//
//  Created by Anastasiya Gorban on 8/18/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTInvocation : NSObject

@property (nonatomic, readonly) id message;
@property (nonatomic, readonly) id caller;
@property (nonatomic, readonly) DTInvocation *parent;

@property (nonatomic, strong) NSDate *started;
@property (nonatomic, strong) NSDate *finished;

- (instancetype)initWithMessage:(id)message caller:(nullable id)caller;
+ (instancetype)invocationWithMessage:(id)message caller:(nullable id)caller;

- (void)start;
- (void)finish;

@end

NS_ASSUME_NONNULL_END