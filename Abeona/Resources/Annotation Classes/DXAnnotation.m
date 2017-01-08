//
//  DXAnnotation.m
//  Gravel
//
//  Created by Salman Nasir on 29/10/2015.
//  Copyright © 2015 RAC Application. All rights reserved.
//

#import "DXAnnotation.h"

@implementation DXAnnotation

@synthesize title,subtitle,tagDX,detailModel;
@synthesize coordinate = _coordinate;

-(id)initWithLocation:(CLLocationCoordinate2D)coords andTag:(int)tagDXAnn andModel:(AnnotationModel *)ssModel{
    
    self = [super init];
    _coordinate = coords;
    tagDX = tagDXAnn;
    detailModel = ssModel;
    
    return self;
    
}

-(id)initWithLocation:(CLLocationCoordinate2D)coords andTag:(int)tagDXAnn {
    
    self = [super init];
    _coordinate = coords;
    tagDX = tagDXAnn;
    
    return self;
}


@end
