//
//  DTSessionStorage.h
//  Actors
//
//  Created by Anastasiya Gorban on 8/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session;

@protocol DTSessionProvider

- (Session *)session;

@end

@interface DTSessionStorage : NSObject <DTSessionProvider>

@property (nonatomic, strong) Session *session;

- (void)clear;

@end
