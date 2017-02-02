
//
//  RouteDetailsViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "RouteDetailsViewController.h"

@interface RouteDetailsViewController ()
{
    NSMutableArray *stepsArray;
    NSIndexPath *selectedIndex;
    int lblY;
    BOOL isShowDetail;
    BOOL isSHowMapCell;
    int tag;
    GMSMapView *mapView;
    NSArray *_styles;
    NSArray *_lengths;
    NSArray *_polys;
    double _pos, _step;
    GMSCameraPosition *camera;
    ModelLocator *model;
    NSDate *startDate;

}
@end

@implementation RouteDetailsViewController

@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [tableview registerNib:[UINib nibWithNibName:@"RouteTableViewCell" bundle:nil] forCellReuseIdentifier:@"routeDetailCell"];
    [tableview registerNib:[UINib nibWithNibName:@"RouteStopsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
     [tableview registerNib:[UINib nibWithNibName:@"RouteMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"RouteMapTableViewCell"];
    
    self.lblTopSuggestion.text = [NSString stringWithFormat:@"Leave %@, arrive %@",[HelperClass getDate:self.departDate withFormat:@"HH:mm EEEE dd MMMM"], [HelperClass getDate:self.arrivalDate withFormat:@"HH:mm"]];
    
//    int yourSection = 0;
//    int lastRow = (int)[self.tableview numberOfRowsInSection:yourSection] - 1;
//   
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow-1 inSection:0];
//   // [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    //[self.tableview scrollToRowAtIndexPath:0 atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    int lastRow = 0;
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableview reloadData];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    model = [ModelLocator getInstance];
    stepsArray = [NSMutableArray new];
  
}

- (IBAction)showStopsView:(id)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RouteTableViewCell *stopsCell = (RouteTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    
    NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
    
    if ([mode_type isEqualToString:@"TRANSIT"]) {
        isSHowMapCell = false;
        [self showHideViewsForTransitCell:stopsCell andIndexPath:indexPath];
        if (isShowDetail) {
            isShowDetail = false;
        }else {
            isShowDetail = true;
        }
        [tableview reloadData];
    }else {
        isShowDetail = false;
        [self showHideViewsForTransitCell:stopsCell andIndexPath:indexPath];
        if (isSHowMapCell) {
            isSHowMapCell = false;
        }else {
            isSHowMapCell = true;
        }
        [tableview reloadData];
    }
    selectedIndex = indexPath;
    [self showHideViewsForTransitCell:stopsCell andIndexPath:indexPath];
    [tableview reloadData];
}

- (IBAction)showMapView:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RouteTableViewCell *routeCell = (RouteTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    if (isSHowMapCell) {
        isSHowMapCell = false;
    }else {
        isSHowMapCell = true;
    }
    selectedIndex = indexPath;
    [self showHideViewsForTransitCell:routeCell andIndexPath:indexPath];
    [tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isDriving) {
        return model.drivingSteps.count;
    }else {
        return model.transitSteps.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (_isDriving) {
        return 165;
    }else {
        if (model.legsDrivingDict) {
            if (isShowDetail && indexPath == selectedIndex) {
                return 210;
            }else if (isSHowMapCell && indexPath == selectedIndex) {
                return 400;
            }else {
                return 185;
            }
        }else {
            // if from QPX
            if (isShowDetail && indexPath == selectedIndex) {
                return 240;
            }else if (isSHowMapCell && indexPath == selectedIndex) {
                return 400;
            }else {
                if (indexPath.row == 0) {
                     return 175;
                }else {
                    return 145;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_isDriving) {
        return [self setUpCellForDriving:indexPath];
    }else {
        return [self setUpCellForTransit:indexPath];
    }

}

- (RouteTableViewCell *)setUpCellForDriving:(NSIndexPath *)indexPath {
    
    RouteTableViewCell *cell = (RouteTableViewCell *)[tableview dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];

    cell.detailBtn.hidden = true;
    cell.detailBtn.tag = indexPath.row;
    cell.mapHeightConstraint.constant = 0;
    cell.stopsViewHeightConstraint.constant = 0;
    cell.stopsView.hidden = true;
    cell.mapView.hidden = true;

    if (indexPath.row == 0) {
        
        cell.halfLine.hidden = false;
        cell.leaveImageView.hidden = false;
        
    }else {
        cell.fullLine.hidden = false;
        cell.circleImageView.hidden = false;
        cell.leaveImageHeightConstraint.constant = 0;
        cell.labelTopConstraint.constant = -2;
    }
    cell.mode_Image.image = [UIImage imageNamed:@"car_icon"];
    cell.mode_type.text = @"Driving";

    [self setValueForSteps:indexPath andCell:cell];
    
    return cell;
}

- (RouteTableViewCell *)setUpCellForTransit:(NSIndexPath *)indexPath {
    
    RouteTableViewCell *cell = (RouteTableViewCell *)[tableview dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
   
    cell.detailBtn.tag = indexPath.row;
    
    NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
    
    if ([mode_type isEqualToString:@"TRANSIT"]) {
       
        NSString *vehiclename = [HelperClass stringByStrippingHTML:[[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"vehicle"] valueForKey:@"name"]];
        
        if ([vehiclename isEqualToString:@"Bus"]) {
            cell.mode_Image.image = [UIImage imageNamed:@"bus_Icon"];

        }else {
            cell.mode_Image.image = [UIImage imageNamed:@"train_icon"];

        }
        [cell.detailBtn addTarget:self action:@selector(showStopsView:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.mode_type.text = vehiclename;
        NSString *noOfStops = [HelperClass stringByStrippingHTML:[NSString stringWithFormat:@"%@",[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"num_stops"]]];
        [cell.detailBtn setTitle:[NSString stringWithFormat:@"%@ stops",noOfStops] forState:UIControlStateNormal];
        cell.lblArrivalTime.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"arrival_time"] valueForKey:@"text"]];
        cell.lblArrivalPlace.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"]];
        cell.lblDepartTime.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_time"] valueForKey:@"text"]];
        cell.lblDepartPlace.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"]];

    }else {
        
        [cell.detailBtn setTitle:[NSString stringWithFormat:@"Detail"] forState:UIControlStateNormal];
        [cell.detailBtn addTarget:self action:@selector(showStopsView:) forControlEvents:UIControlEventTouchUpInside];
        cell.mode_Image.image = [UIImage imageNamed:@"walking_icon"];
        cell.mode_type.text = @"Walking";

        id lattitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"start_location"] valueForKey:@"lat"];
        id longitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"start_location"] valueForKey:@"lng"];
        
        id endLatitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"end_location"] valueForKey:@"lat"];
        id endLongitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"end_location"] valueForKey:@"lng"];
        
        CLLocation *loction = [[CLLocation alloc] initWithLatitude:[lattitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *loction1 = [[CLLocation alloc] initWithLatitude:[endLatitude doubleValue]  longitude:[endLongitude doubleValue]];

        NSString *polyline = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"polyline"] valueForKey:@"points"];
    
        [self loadView:cell andLocation:loction andLocation:loction1 andPolyline:polyline];
        
    }

    [self showHideViewsForTransitCell:cell andIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        cell.halfLine.hidden = false;
        cell.leaveImageView.hidden = false;
        
    }else {
        cell.fullLine.hidden = false;
        cell.circleImageView.hidden = false;
        cell.leaveImageHeightConstraint.constant = 0;
        cell.labelTopConstraint.constant = -2;
    }
    [self setValueForSteps:indexPath andCell:cell];
    return cell;
}

- (void)showHideViewsForTransitCell:(RouteTableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath {
   
    if (isSHowMapCell && selectedIndex == indexPath) {
        cell.stopsViewHeightConstraint.constant = 0;
        cell.stopsView.hidden = true;
        cell.mapHeightConstraint.constant = 235;
        cell.mapView.hidden = false;

    }else if (isShowDetail && selectedIndex == indexPath) {
        cell.stopsViewHeightConstraint.constant = 45;
        cell.stopsView.hidden = false;
        cell.mapHeightConstraint.constant = 0;
        cell.mapView.hidden = true;
    }else {
        cell.mapHeightConstraint.constant = 0;
        cell.stopsViewHeightConstraint.constant = 0;
        cell.stopsView.hidden = true;
        cell.mapView.hidden = true;
    }
}

- (NSDate *)setTime:(NSString *)time {
    
    time = [time stringByReplacingOccurrencesOfString:@" mins" withString:@""];
    time = [time stringByReplacingOccurrencesOfString:@" min" withString:@""];
    time = [time stringByReplacingOccurrencesOfString:@" hours" withString:@""];
    time = [time stringByReplacingOccurrencesOfString:@" hour" withString:@""];
    
    NSArray *array = [time componentsSeparatedByString:@" "];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    if (array.count > 1) {
        [offsetComponents setHour:[[array objectAtIndex:0] intValue]];
        [offsetComponents setMinute:[[array objectAtIndex:1] intValue]];

    }else {
        [offsetComponents setMinute:[[array objectAtIndex:0] intValue]];
    }
    return [gregorian dateByAddingComponents:offsetComponents toDate:startDate options:0];
}

- (void)setValueForSteps:(NSIndexPath *)indexPath andCell:(RouteTableViewCell *)cell
{
    if(self.isDriving)
    {
        
        if(indexPath.row +1 < model.drivingSteps.count)
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            
            cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row+1] objectForKey:@"html_instructions"]];
            
            NSString *time = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
            cell.lblStepTime.text = time;
           
            if (indexPath.row == 0) {
                cell.lblTotalTime.text = [HelperClass getDate:self.departDate withFormat:@"HH:mm"];
            }else {
                
                startDate = self.departDate;
                for (int index = 0; index < indexPath.row; index++) {
                    NSString *time = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:index] objectForKey:@"duration"] objectForKey:@"text"]];
                    startDate = [self setTime:time];
                }
                cell.lblTotalTime.text = [HelperClass getDate:startDate withFormat:@"HH:mm"];
            }
        }
        else
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            NSString *time = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
            cell.lblStepTime.text = time;
            startDate = self.departDate;
            for (int index = 0; index < indexPath.row; index++) {
                NSString *time = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:index] objectForKey:@"duration"] objectForKey:@"text"]];
                startDate = [self setTime:time];
            }
            cell.lblTotalTime.text = [HelperClass getDate:startDate withFormat:@"HH:mm"];
        }
    }
    
    else
    {
        
        if(indexPath.row +1 < model.transitSteps.count)
        {
           
           // NSLog(@"%@", model.transitSteps);
            if (indexPath.row == 0)
            {
                NSLog(@"%ld",(long)indexPath.row);
                NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
                NSLog(@"%@",mode_type);
               //NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"travel_mode"]];
                cell.lblAddress.text = [self stringByStrippingHTML:[model.legsTransitDict valueForKey:@"start_address"]];
                cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]];
                NSLog(@"%@",[self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]]);

            }
            else
            {
                NSLog(@"%ld",(long)indexPath.row);
                
               
                NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"travel_mode"]];
                if ([mode_type isEqualToString:@"TRANSIT"])
                {
                    NSLog(@"%@",[self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]]);
                    NSLog(@"%@",[self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"html_instructions"]]);
                    NSLog(@"%@",mode_type);
                    cell.lblAddress.text = [self stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"]];
                    cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]];
                }
                else
                {
               
                    NSLog(@"%@",[self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"html_instructions"]]);
                    NSLog(@"%@",[self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]]);
                    NSString *str = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row-1] valueForKey:@"html_instructions"]];
                    str = [str stringByReplacingOccurrencesOfString:@"Walk To"
                                                         withString:@""];
                    cell.lblAddress.text = str;
                    cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]];
                
                }
            }

            
            NSString *time = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"duration"] valueForKey:@"text"]];
            cell.lblStepTime.text = time;
           
            if (indexPath.row == 0)
            {
                cell.lblTotalTime.text = [HelperClass getDate:self.departDate withFormat:@"HH:mm"];
            }
            else
            {
                startDate = self.departDate;

                for (int index = 0; index < indexPath.row; index++) {
                    NSString *time = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:index] valueForKey:@"duration"] valueForKey:@"text"]];
                    startDate = [self setTime:time];
                }
                cell.lblTotalTime.text = [HelperClass getDate:startDate withFormat:@"HH:mm"];
            }
        }
        else
        {
            NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];

            if ([mode_type isEqualToString:@"TRANSIT"]) {
                cell.lblAddress.text = [self stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"]];
                cell.lblHtmlText.text = [self stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"]];
            }
            else
            {
                /*
                cell.lblAddress.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"html_instructions"]];
                if(indexPath.row +1 == model.transitSteps.count) {
                   cell.lblHtmlText.text = [self stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row+1] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"]];
                }else {
                    cell.lblHtmlText.text = [self stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"]];
                }
                 
                 */
            
            }
            NSString *time = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"duration"] valueForKey:@"text"]];
            cell.lblStepTime.text = time;
           
            startDate = self.departDate;
            
            for (int index = 0; index < indexPath.row; index++) {
                NSString *time = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:index] valueForKey:@"duration"] valueForKey:@"text"]];
                startDate = [self setTime:time];
            }
            cell.lblTotalTime.text = [HelperClass getDate:startDate withFormat:@"HH:mm"];
        }
    }
}

-(NSString *)stringByStrippingHTML:(NSString *)str {
    
//    str = [str stringByReplacingOccurrencesOfString:@"Walk To"
//                                         withString:@""];
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}




- (void)loadView:(RouteTableViewCell *)cell andLocation:(CLLocation *)startLocation andLocation:(CLLocation *)endLocation andPolyline:(NSString *)polyline {
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, [HelperClass getCellHeight:235 OriginalWidth:375].height) camera:camera];
    
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:startLocation.coordinate coordinate:endLocation.coordinate];
    [mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    
    mapView.userInteractionEnabled = true;
    [cell.mapView addSubview:mapView];
    
    // Creates a marker in the center of the map.
    
    
    GMSMarker *marker = [[GMSMarker alloc]init];
    marker.position = startLocation.coordinate;
    marker.map = mapView;
    
    GMSMarker *marker1 = [[GMSMarker alloc]init];
    marker1.position = endLocation.coordinate;
    marker1.map = mapView;
    
    UIColor *color = [UIColor colorWithRed:30.0/255.0 green:179.0/255.0 blue:252.0/255.0 alpha:1.0];
    [self createDashedLine:startLocation.coordinate andNext:endLocation.coordinate andColor:color andEncodedPath:polyline];

    
}


- (void)createDashedLine:(CLLocationCoordinate2D )thisPoint andNext:(CLLocationCoordinate2D )nextPoint andColor:(UIColor *)colour andEncodedPath:(NSString *)encodedPath
{
    
    double difLat = nextPoint.latitude - thisPoint.latitude;
    double difLng = nextPoint.longitude - thisPoint.longitude;
    double scale = camera.zoom * 2;
    double divLat = difLat / scale;
    double divLng = difLng / scale;
    CLLocationCoordinate2D tmpOrig= thisPoint;
    
    GMSMutablePath *singleLinePath = [GMSMutablePath path];
    
    for(int i = 0 ; i < scale ; i ++){
        CLLocationCoordinate2D tmpOri = tmpOrig;
        if(i > 0){
            tmpOri = CLLocationCoordinate2DMake(tmpOrig.latitude + (divLat * 0.25f),
                                                tmpOrig.longitude + (divLng * 0.25f));
        }
        [singleLinePath addCoordinate:tmpOri];
        [singleLinePath addCoordinate:
         CLLocationCoordinate2DMake(tmpOrig.latitude + (divLat * 1.0f),
                                    tmpOrig.longitude + (divLng * 1.0f))];
        
        
        tmpOri = CLLocationCoordinate2DMake(tmpOrig.latitude + (divLat * 1.0f),
                                            tmpOrig.longitude + (divLng * 1.0f));
        
    }
    
    GMSPolyline *polyline ;
    polyline = [GMSPolyline polylineWithPath:[GMSPath pathFromEncodedPath:encodedPath]];
    polyline.geodesic = NO;
    polyline.strokeWidth = 5.f;
    polyline.strokeColor = colour;
    polyline.map = mapView;
    
    //Setup line style and draw
    _lengths = @[@([singleLinePath lengthOfKind:kGMSLengthGeodesic] / 100)];
    _polys = @[polyline];
    [self setupStyleWithColour:colour];
    [self tick];
}

- (void)tick {
    //Create steps for polyline(dotted polylines)
    for (GMSPolyline *poly in _polys) {
        poly.spans =
        GMSStyleSpans(poly.path, _styles, _lengths, kGMSLengthGeodesic);
    }
    _pos -= _step;
}

-(void)setupStyleWithColour:(UIColor *)color{
    
    GMSStrokeStyle *gradColor = [GMSStrokeStyle gradientFromColor:color toColor:color];
    
    _styles = @[
                gradColor,
                [GMSStrokeStyle solidColor:[UIColor colorWithWhite:0 alpha:0]],
                ];
    _step = 500;
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
