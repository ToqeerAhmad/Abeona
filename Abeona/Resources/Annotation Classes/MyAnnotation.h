//
//  MyAnnotation.h
//  Mobi
//
//  Created by Salman Nasir on 10/04/2013.
//  Copyright (c) 2013 Salman Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	_coordinate;
	NSString*				title;
	NSString*				subtitle;
    NSString*				index;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic, copy)		NSString*				index;

-(id)initWithLocation:(CLLocationCoordinate2D)coords title:(NSString*)atitle andSubtitle:(NSString*)aSubtitle;
@end
