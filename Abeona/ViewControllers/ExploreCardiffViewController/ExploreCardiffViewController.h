//
//  ExploreCardiffViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ExploreCardiffViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property(nonatomic,strong) MapCallOutView *customView;

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIButton *rightBarButton;

@end
