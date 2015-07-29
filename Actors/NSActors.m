//
//  NSActors.m
//  
//
//  Created by Sergey Zenchenko on 7/29/15.
//
//

#import "NSActors.h"
#import "Actors-Swift.h"

@implementation NSActors

- (instancetype)init
{
    self = [super init];
    if (self) {
        ObjcX *objc = [[ObjcX alloc] init];
        
        int len = [objc get:@"qwdqd"];
        
        Payload *p = [objc payload:@"qwdqd"];
        
        Payload *p2 = [[Payload alloc] init:@"qwd"];
    }
    return self;
}

@end
