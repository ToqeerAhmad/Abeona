//
//  GetRoutesViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "GetRoutesViewController.h"

@interface GetRoutesViewController ()
{
    MBProgressHUD *progressBar;
    ModelLocator *model;
    
    NSString *transit_duration;
    NSString *transit_arrival_time;
    NSString *transit_departure_time;
    
    NSString *driving_duration;
    NSString *driving_arrival_time;
    NSString *driving_departure_time;
}
@end

@implementation GetRoutesViewController

@synthesize routesOptionstableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editJourney.layer.cornerRadius = 3.0;
    self.editJourney.layer.masksToBounds = true;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    model = [ModelLocator getInstance];
    [self updateLocation];
    [self getTransitObjects];
    [self getDrivingObjects];
    [routesOptionstableView registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoutesOptionsCell"];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)getTransitObjects {
    
    transit_duration = [[model.legsTransitDict valueForKey:@"duration"] valueForKey:@"text"];
    transit_arrival_time = [HelperClass checkforNullvalue:[[model.legsTransitDict valueForKey:@"arrival_time"] valueForKey:@"text"]];
    transit_departure_time = [HelperClass checkforNullvalue: [[model.legsTransitDict valueForKey:@"departure_time"] valueForKey:@"text"]];
    
    transit_duration = [self removeHourMinsString:transit_duration];
    transit_departure_time = [self removeHourMinsString:transit_departure_time];
    transit_arrival_time = [self removeHourMinsString:transit_arrival_time];
}

- (void)getDrivingObjects {
    
    driving_duration = [[model.legsDrivingDict valueForKey:@"duration"] valueForKey:@"text"];
    driving_arrival_time = [HelperClass checkforNullvalue:[[model.legsTransitDict valueForKey:@"arrival_time"] valueForKey:@"text"]];
    driving_departure_time = [HelperClass checkforNullvalue:[[model.legsTransitDict valueForKey:@"departure_time"] valueForKey:@"text"]];
    
    driving_departure_time = [self removeHourMinsString:driving_departure_time];
    driving_arrival_time =  [self removeHourMinsString:driving_arrival_time];
    driving_duration = [self removeHourMinsString:driving_duration];
    
    
}

- (NSString *)removeHourMinsString:(NSString *)string {
    
   NSString *hour_string = [[NSString stringWithFormat:@"%@",string] stringByReplacingOccurrencesOfString:@"hours" withString:@"h"];
   NSString *mitns_string = [hour_string stringByReplacingOccurrencesOfString:@"mins" withString:@"m"];

    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@")" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    mitns_string = [mitns_string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"    " withString:@""];


    return mitns_string;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OptionsTableViewCell *cell = (OptionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RoutesOptionsCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lblRouteType.text = @"Supporter Train";
        cell.lblTime.text = [NSString stringWithFormat:@"%@",transit_duration];
        if (![transit_departure_time isEqualToString:@"<null>"]) {
            cell.lblArrive_DepartTime.text = [NSString stringWithFormat:@"(leave %@, arrive %@)",transit_departure_time, transit_arrival_time];
        }
    }else {
        cell.lblRouteType.text = @"Driving";
        cell.lblTime.text = [NSString stringWithFormat:@"%@",driving_duration];
        if (![driving_departure_time isEqualToString:@"<null>"]) {
            cell.lblArrive_DepartTime.text = [NSString stringWithFormat:@"(leave %@, arrive %@)",driving_departure_time, driving_arrival_time];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RouteDetailsViewController *detailVC = [self. storyboard instantiateViewControllerWithIdentifier:@"RouteDetailsViewController"];
    if (indexPath.row == 0) {
        detailVC.isDriving = false;
    }else {
        detailVC.isDriving = true;
    }
    [self.navigationController pushViewController:detailVC animated:true];
}

- (void)updateLocation {
    
    self.lblCurrentAddress.text = @"";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation ;
    
    newLocation= [[CLLocation alloc]initWithLatitude:model.userCoordinates.latitude
                                           longitude:model.userCoordinates.longitude];
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Geocode failed with error: %@", error.localizedDescription);
                           return;
                       }
                       if (placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary =
                           placemark.addressDictionary;
                           
                           self.lblCurrentAddress.text = [[addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                           
                       }
                   }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
