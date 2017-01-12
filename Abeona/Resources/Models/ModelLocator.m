//
//  ModelLocator.m
//  Bark'n'Borrow
//
//  Created by Fahad Khan on 4/27/15.
//  Copyright (c) 2015 Rac. All rights reserved.
//

#import "ModelLocator.h"

static ModelLocator *instance = nil;

@implementation ModelLocator
//@synthesize url;
+(ModelLocator*) getInstance{
    
    @synchronized(self)
    {
        if (!instance)
        {
            instance=[[self alloc] init];
            return instance;
        }
    }
    
    return instance;
}

+(id)alloc
{
    @synchronized([ModelLocator class])
    {
        NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton.");
        instance = [super alloc];
        return instance;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {

    }
    return self;
}



@end
