//
//  MapPolyLine.h
//  Thoubk
//
//  Created by Nouman Tariq on 10/21/16.
//  Copyright © 2016 ilsainteractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetPolyLineArray <NSObject>
@optional
 - (void)getPolylineArray:(NSMutableArray*)polyLineArray;

@end

@interface MapPolyLine : NSObject
@property (nonatomic, weak) id<GetPolyLineArray> delegate;
-(void)routes:(double)sourceLat sourceLong:(double)sourceLong destLat:(double)destLat destLong:(double)destLong;
@end
