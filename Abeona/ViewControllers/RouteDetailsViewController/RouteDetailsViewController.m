
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

    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    model = [ModelLocator getInstance];

    stepsArray = [NSMutableArray new];
  
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
        if (isShowDetail && indexPath == selectedIndex) {
            return 240;
        }else if (isSHowMapCell && indexPath == selectedIndex) {
            return 430;
        }else {
            return 180;
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
        cell.alertView.hidden = false;
        cell.leaveImageHeightConstraint.constant = 0;
        cell.labelTopConstraint.constant = -2;
    }
    cell.mode_Image.image = [UIImage imageNamed:@"bus_Icon"];
    cell.mode_type.text = @"Driving";

    [self setValueForSteps:indexPath andCell:cell];
    
    return cell;
}

- (RouteTableViewCell *)setUpCellForTransit:(NSIndexPath *)indexPath {
    
    RouteTableViewCell *cell = (RouteTableViewCell *)[tableview dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
    cell.detailBtn.tag = indexPath.row;
    
    NSString *mode_type = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"travel_mode"]];
    
    if ([mode_type isEqualToString:@"TRANSIT"]) {
       
        cell.mode_Image.image = [UIImage imageNamed:@"train_icon"];
        cell.mode_type.text = [HelperClass stringByStrippingHTML:[[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"vehicle"] valueForKey:@"name"]];
        [cell.detailBtn addTarget:self action:@selector(showStopsView:) forControlEvents:UIControlEventTouchUpInside];
        NSString *noOfStops = [HelperClass stringByStrippingHTML:[NSString stringWithFormat:@"%@",[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"num_stops"]]];
        [cell.detailBtn setTitle:[NSString stringWithFormat:@"%@ stops",noOfStops] forState:UIControlStateNormal];
        cell.lblArrivalTime.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"arrival_time"] valueForKey:@"text"]];
        cell.lblArrivalPlace.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"]];
        cell.lblDepartTime.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_time"] valueForKey:@"text"]];
        cell.lblDepartPlace.text = [HelperClass stringByStrippingHTML:[[[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"]];
    }else {
        
        cell.mode_Image.image = [UIImage imageNamed:@"walking_icon"];
        cell.mode_type.text = @"Walking";

        id lattitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"start_location"] valueForKey:@"lat"];
        id longitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"start_location"] valueForKey:@"lng"];
        
        id endLatitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"end_location"] valueForKey:@"lat"];
        id endLongitude = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"end_location"] valueForKey:@"lng"];
        
        CLLocation *loction = [[CLLocation alloc] initWithLatitude:[lattitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *loction1 = [[CLLocation alloc] initWithLatitude:[endLatitude doubleValue]  longitude:[endLongitude doubleValue]];

        NSString *polyline = [[[model.transitSteps objectAtIndex:indexPath.row] valueForKey:@"polyline"] valueForKey:@"points"];
        UIColor *color = [UIColor colorWithRed:30.0/255.0 green:179.0/255.0 blue:252.0/255.0 alpha:1.0];
        
        [self loadView:cell andLocation:loction andLocation:loction1];
        [self createDashedLine:loction.coordinate andNext:loction1.coordinate andColor:color andEncodedPath:polyline];
        
        [cell.detailBtn addTarget:self action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
    }

    if (isSHowMapCell) {
        cell.stopsViewHeightConstraint.constant = 0;
        cell.stopsView.hidden = true;
    }else if (isShowDetail) {
        cell.mapHeightConstraint.constant = 0;
        cell.mapView.hidden = true;
    }else {
        cell.mapHeightConstraint.constant = 0;
        cell.stopsViewHeightConstraint.constant = 0;
        cell.stopsView.hidden = true;
        cell.mapView.hidden = true;
    }
    if (indexPath.row == 0) {
        
        cell.halfLine.hidden = false;
        cell.leaveImageView.hidden = false;
        
    }else {
        cell.fullLine.hidden = false;
        cell.circleImageView.hidden = false;
        cell.alertView.hidden = false;
        cell.leaveImageHeightConstraint.constant = 0;
        cell.labelTopConstraint.constant = -2;
    }
    [self setValueForSteps:indexPath andCell:cell];
    return cell;
}

- (void)setValueForSteps:(NSIndexPath *)indexPath andCell:(RouteTableViewCell *)cell
{
    if(self.isDriving)
    {
        
        if(indexPath.row +1 < model.drivingSteps.count)
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            
            cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row+1] objectForKey:@"html_instructions"]];
            
            cell.lblStepTime.text = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
            
        }
        else
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            cell.lblStepTime.text = [self stringByStrippingHTML:[[[model.drivingSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
        }
    }
    
    else
    {
        
        if(indexPath.row +1 < model.transitSteps.count)
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            cell.lblHtmlText.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row+1] objectForKey:@"html_instructions"]];
            
            cell.lblStepTime.text = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
            
        }
        else
        {
            cell.lblAddress.text = [self stringByStrippingHTML:[[model.transitSteps objectAtIndex:indexPath.row] objectForKey:@"html_instructions"]];
            
            cell.lblStepTime.text = [self stringByStrippingHTML:[[[model.transitSteps objectAtIndex:indexPath.row] objectForKey:@"duration"] objectForKey:@"text"]];
        }
    }
}

-(NSString *)stringByStrippingHTML:(NSString *)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)showStopsView:(id)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RouteTableViewCell *stopsCell = (RouteTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    isShowDetail =! isShowDetail;
    isSHowMapCell = false;
    selectedIndex = indexPath;
    if (isShowDetail) {
        stopsCell.stopsView.hidden = false;
        stopsCell.stopsViewHeightConstraint.constant = 45;
    }else {
        stopsCell.stopsView.hidden = true;
        stopsCell.stopsViewHeightConstraint.constant = 0;
    }
    [tableview reloadData];
}

- (IBAction)showMapView:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    RouteTableViewCell *routeCell = (RouteTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];
    isSHowMapCell =! isSHowMapCell;
    isShowDetail = false;
    selectedIndex = indexPath;
    if (isSHowMapCell) {
        routeCell.mapHeightConstraint.constant = 235;
        routeCell.mapView.hidden = false;
    }else {
        routeCell.mapHeightConstraint.constant = 0;
        routeCell.mapView.hidden = true;
    }
    [tableview reloadData];
}


- (void)loadView:(RouteTableViewCell *)cell andLocation:(CLLocation *)startLocation andLocation:(CLLocation *)endLocation {
    
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
