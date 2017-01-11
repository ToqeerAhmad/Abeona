//
//  RouteDetailsViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface RouteDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableview;

@end
