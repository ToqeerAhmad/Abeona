//
//  ExploreCardiffDetailViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ExploreCardiffDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
typedef enum
{
    WeekdaySunday = 1,
    WeekdayMonday,
    WeekdayTuesday,
    WeekdayWednesday,
    WeekdayThursday,
    WeekdayFriday,
    WeekdaySaturday
} Weekday;
@property (nonatomic, weak) IBOutlet UITableView *table;


@end
