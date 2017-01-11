//
//  ExploreCardiffViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ExploreCardiffViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, weak) IBOutlet UIButton *rightBarButton;

@end
