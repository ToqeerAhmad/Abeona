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
    
    NSDate *drivingDepartureDate;
    NSDate *drivingArrivalDate;
    
    NSDate *transitDepartureDate;
    NSDate *transitArrivalDate;
    
    BOOL isFlight;
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
    [routesOptionstableView registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"RoutesOptionsCell"];
    if (model.legsTransitDict) {
        [self getTransitObjects];
       
    }if (model.legsDrivingDict) {
         [self getDrivingObjects];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)getTransitObjects {
    
    transit_duration = [HelperClass stringByStrippingHTML:[[model.legsTransitDict valueForKey:@"duration"] valueForKey:@"text"]];
    transit_arrival_time = [HelperClass stringByStrippingHTML:[[model.legsTransitDict valueForKey:@"arrival_time"] valueForKey:@"text"]];
    transit_departure_time = [HelperClass stringByStrippingHTML:[[model.legsTransitDict valueForKey:@"departure_time"] valueForKey:@"text"]];
    
    transit_duration = [self removeHourMinsString:transit_duration];
    transit_departure_time = [NSString stringWithFormat:@"2017-03-06 %@",[self removeHourMinsString:transit_departure_time]];
    transit_arrival_time = [NSString stringWithFormat:@"2017-03-06 %@",[self removeHourMinsString:transit_arrival_time]];
    
    NSString *removedhmTime = [transit_duration stringByReplacingOccurrencesOfString:@"h" withString:@""];
    removedhmTime = [removedhmTime stringByReplacingOccurrencesOfString:@"m" withString:@""];
    NSArray *array = [removedhmTime componentsSeparatedByString:@" "];
    
    transitArrivalDate = [HelperClass getDate:@"2017-03-06 13:00" withColonFormat:@"YYYY-dd-MM HH:mm"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    if (array.count == 1) {
        [offsetComponents setMinute:-[[array objectAtIndex:0] intValue]];
    }else {
        [offsetComponents setHour:-[[array objectAtIndex:0] intValue]];
        [offsetComponents setMinute:-[[array objectAtIndex:1] intValue]];
    }
    transitDepartureDate = [gregorian dateByAddingComponents:offsetComponents toDate:transitArrivalDate options:0];
    
    transit_departure_time = [HelperClass getDate:transitDepartureDate withFormat:@"HH:mm"];
    transit_arrival_time = [HelperClass getDate:transitArrivalDate withFormat:@"HH:mm"];
    
    for (NSDictionary *step in model.transitSteps) {
        NSString *travel_mode = [step valueForKey:@"travel_mode"];
        if ([travel_mode isEqualToString:@"TRANSIT"]) {
            model.transit_type = [HelperClass stringByStrippingHTML:[[[[step valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"vehicle"] valueForKey:@"name"]];
            NSLog(@"%@",model.transit_type);
            return;
        }
    }
}

- (NSDate *)parseDate:(NSString *)inStrDate format:(NSString *)inFormat {
    
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:inFormat];
    NSDate* dateOutput = [dtFormatter dateFromString:inStrDate];
    return dateOutput;
}

- (void)getDrivingObjects {
    
    driving_duration = [HelperClass stringByStrippingHTML:[[model.legsDrivingDict valueForKey:@"duration"] valueForKey:@"text"]];
    driving_arrival_time = [HelperClass stringByStrippingHTML:[[model.legsDrivingDict valueForKey:@"arrival_time"] valueForKey:@"text"]];
    driving_departure_time = [HelperClass stringByStrippingHTML:[[model.legsDrivingDict valueForKey:@"departure_time"] valueForKey:@"text"]];
    
    driving_departure_time = [self removeHourMinsString:driving_departure_time];
    driving_arrival_time =  [self removeHourMinsString:driving_arrival_time];
    driving_duration = [self removeHourMinsString:driving_duration];
    
    
    NSString *removedhmTime = [driving_duration stringByReplacingOccurrencesOfString:@"h" withString:@""];
    removedhmTime = [removedhmTime stringByReplacingOccurrencesOfString:@"m" withString:@""];
    NSArray *array = [removedhmTime componentsSeparatedByString:@" "];
    
    drivingArrivalDate = [HelperClass getDate:@"2017-03-06 13:00" withColonFormat:@"YYYY-dd-MM HH:mm"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    if (array.count == 1) {
        [offsetComponents setMinute:-[[array objectAtIndex:0] intValue]];
    }else {
        [offsetComponents setHour:-[[array objectAtIndex:0] intValue]];
        [offsetComponents setMinute:-[[array objectAtIndex:1] intValue]];
    }
    drivingDepartureDate = [gregorian dateByAddingComponents:offsetComponents toDate:drivingArrivalDate options:0];
    
    driving_departure_time = [HelperClass getDate:drivingDepartureDate withFormat:@"HH:mm"];
    driving_arrival_time = [HelperClass getDate:drivingArrivalDate withFormat:@"HH:mm"];

    
    
}

- (NSString *)removeHourMinsString:(NSString *)string {
    
   NSString *hour_string = [[NSString stringWithFormat:@"%@",string] stringByReplacingOccurrencesOfString:@" hours" withString:@"h"];
   hour_string = [hour_string stringByReplacingOccurrencesOfString:@" hour" withString:@"h"];
    
   NSString *mitns_string = [hour_string stringByReplacingOccurrencesOfString:@" mins" withString:@"m"];

    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@")" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    mitns_string = [mitns_string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    mitns_string = [mitns_string stringByReplacingOccurrencesOfString:@"    " withString:@""];


    return mitns_string;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if (model.tripOptions.count > 0)
//        return 2;
//    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (model.tripOptions.count > 0) {
        if (indexPath.row == 0) {
            return  [self configureCellForQPX:indexPath];
        }else {
            return  [self configureCellForDrivingAndTransit:indexPath];
        }
    }else {
        return  [self configureCellForDrivingAndTransit:indexPath];
    }
}

- (OptionsTableViewCell *)configureCellForQPX:(NSIndexPath *)indexPath {
   
    OptionsTableViewCell *cell = (OptionsTableViewCell *)[self.routesOptionstableView dequeueReusableCellWithIdentifier:@"RoutesOptionsCell" forIndexPath:indexPath];

    cell.lblRouteType.text = @"Flight";
    isFlight = true;
    //NSArray *pricingArray = [[model.tripOptions objectAtIndex:indexPath.row] valueForKey:@"pricing"];
   
    NSArray *sliceArray = [[model.tripOptions objectAtIndex:indexPath.row] valueForKey:@"slice"];
    NSDictionary *legObject = [[[[[sliceArray objectAtIndex:0] valueForKey:@"segment"] objectAtIndex:0] valueForKey:@"leg"] objectAtIndex:0];
    
    
    
    NSDate *flightDepartDate = [self stripDateFromQPXDate:[legObject valueForKey:@"departureTime"]];
    NSDate *flightArrivalDate = [self stripDateFromQPXDate:[legObject valueForKey:@"arrivalTime"]];
    
    NSMutableString *time = [self timeLeftSinceDate:flightDepartDate andArrivalDate:flightArrivalDate];
    cell.lblTime.text = [NSMutableString stringWithString:time];

    NSString *departTime = [HelperClass getDate:flightDepartDate withFormat:@"HH:mm"];
    NSString *arrivalTime = [HelperClass getDate:flightArrivalDate withFormat:@"HH:mm"];
    
    cell.lblArrive_DepartTime.text = [NSString stringWithFormat:@"(leave %@, arrive %@)",departTime,arrivalTime];
    
    [cell.imagesCollectionView registerNib:[UINib nibWithNibName:@"ModeTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    cell.imagesCollectionView.tag = indexPath.row;
    cell.imagesCollectionView.delegate = self;
    cell.imagesCollectionView.dataSource = (id)self;

    
    return cell;
}


- (OptionsTableViewCell *)configureCellForDrivingAndTransit:(NSIndexPath *)indexPath {
    
    OptionsTableViewCell *cell = (OptionsTableViewCell *)[self.routesOptionstableView dequeueReusableCellWithIdentifier:@"RoutesOptionsCell" forIndexPath:indexPath];
    
    if (model.legsDrivingDict) {
        if (indexPath.row == 0) {
            cell.lblRouteType.text = [NSString stringWithFormat:@"Supporter %@",model.transit_type];
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
    }else {
        
        cell.lblRouteType.text = [NSString stringWithFormat:@"Supporter %@",model.transit_type];
        cell.lblTime.text = [NSString stringWithFormat:@"%@",transit_duration];
        if (![transit_departure_time isEqualToString:@"<null>"]) {
            cell.lblArrive_DepartTime.text = [NSString stringWithFormat:@"(leave %@, arrive %@)",transit_departure_time, transit_arrival_time];
        }
    }
    
    [cell.imagesCollectionView registerNib:[UINib nibWithNibName:@"ModeTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    cell.imagesCollectionView.tag = indexPath.row;
    cell.imagesCollectionView.delegate = self;
    cell.imagesCollectionView.dataSource = (id)self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RouteDetailsViewController *detailVC = [self. storyboard instantiateViewControllerWithIdentifier:@"RouteDetailsViewController"];
    if (!isFlight) {
        if (model.legsDrivingDict) {
            if (indexPath.row == 0) {
                detailVC.isDriving = false;
                detailVC.departDate = transitDepartureDate;
                detailVC.arrivalDate = transitArrivalDate;
            }else {
                detailVC.isDriving = true;
                detailVC.departDate = drivingDepartureDate;
                detailVC.arrivalDate = drivingArrivalDate;
            }
        }else {
            detailVC.isDriving = false;
            detailVC.departDate = transitDepartureDate;
            detailVC.arrivalDate = transitArrivalDate;
            
        }
        [self.navigationController pushViewController:detailVC animated:true];
    }else {
        if (indexPath.row != 0) {
            detailVC.isDriving = false;
            detailVC.departDate = transitDepartureDate;
            detailVC.arrivalDate = transitArrivalDate;
            [self.navigationController pushViewController:detailVC animated:true];
        }
    }
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isFlight) {
        return 1;
    }else {
        if (collectionView.tag == 0) {
            return model.transitSteps.count;
        }else {
            return 1;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(37, 34);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ModeTypeCollectionViewCell *imageCell = (ModeTypeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    if (collectionView.tag == 0) {
       
        if (isFlight) {
            imageCell.modeTypeImageView.image = [UIImage imageNamed:@"flight_icon"];
        }else {
            NSString *mode_type = [HelperClass stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
            if ([mode_type isEqualToString:@"TRANSIT"]) {
                imageCell.modeTypeImageView.image = [UIImage imageNamed:@"train_icon"];
            }else if ([mode_type isEqualToString:@"Bus"]) {
                imageCell.modeTypeImageView.image = [UIImage imageNamed:@"bus_Icon"];
            }else {
                imageCell.modeTypeImageView.image = [UIImage imageNamed:@"walking_icon"];
            }
        }
    }else {
        
        NSString *mode_type = [HelperClass stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
        if ([mode_type isEqualToString:@"Bus"]) {
            imageCell.modeTypeImageView.image = [UIImage imageNamed:@"bus_Icon"];
        }else {
            imageCell.modeTypeImageView.image = [UIImage imageNamed:@"bus_Icon"];
        }
        
    }
    return imageCell;
    
}


// Helper Functions


- (NSDate *)stripDateFromQPXDate:(NSString *)dateStr {
    
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    
    NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
    
    dateStr = [NSString stringWithFormat:@"%@ %@",[dateArray objectAtIndex:0],[dateArray objectAtIndex:1]];
    
    NSDate *date = [self parseDate:dateStr  format:@"yyyy-MM-dd HH:mm"];
    
    return date;
}

- (NSMutableString *)timeLeftSinceDate:(NSDate *)departDate andArrivalDate:(NSDate *)arrivalDate{
    
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    
    
    NSInteger seconds = [arrivalDate timeIntervalSinceDate:departDate];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Days ", (long)days]];
    }
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ldh ", (long)hours]];
    }
    
    if(minutes) {
        [timeLeft appendString: [NSString stringWithFormat: @"%ldm",(long)minutes]];
    }
    
    
    return timeLeft;
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
