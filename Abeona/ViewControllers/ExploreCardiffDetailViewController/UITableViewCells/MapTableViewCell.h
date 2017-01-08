//
//  MapTableViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 09/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet MKMapView *mapview;

@end
