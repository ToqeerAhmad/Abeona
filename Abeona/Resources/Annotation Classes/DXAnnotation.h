//
//  DXAnnotation.h
//  Gravel
//
//  Created by Salman Nasir on 29/10/2015.
//  Copyright © 2015 RAC Application. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DXAnnotation : NSObject <MKAnnotation>{
    
    CLLocationCoordinate2D	_coordinate;
    NSString*				title;
    NSString*				subtitle;
    int                     tagDX;
    AnnotationModel     *detailModel;
    
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic)		int			tagDX;
@property (strong, nonatomic) AnnotationModel     *detailModel;
-(id)initWithLocation:(CLLocationCoordinate2D)coords andTag:(int)tagDXAnn andModel:(AnnotationModel *)ssModel;
-(id)initWithLocation:(CLLocationCoordinate2D)coords andTag:(int)tagDXAnn;


@end
