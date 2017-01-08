//
//  MyAnnotation.m
//  Mobi
//
//  Created by Salman Nasir on 10/04/2013.
//  Copyright (c) 2013 Salman Nasir. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title,subtitle,index;
@synthesize coordinate = _coordinate;


-(id)initWithLocation:(CLLocationCoordinate2D)coords title:(NSString *)atitle andSubtitle:(NSString *)aSubtitle{
    
    self = [super init];
    _coordinate = coords;
    title = atitle;
    subtitle = aSubtitle;
    
    return self;
    
}

@end