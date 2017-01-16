
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
    NSMutableArray *stopsArray;
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

    
    stopsArray = [[NSMutableArray alloc] initWithObjects:@"StockPort[SPT]",@"Wilmslow[WML]",@"Crewe[CRE]",@"Nantwich[NAN]",@"Wem[WEM]",@"Ludlow[LUD]", nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && isSHowMapCell) {
        return 418;
    }else if (indexPath.row != 0 && isShowDetail) {
        return 379;
    }else {
        return 175;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (isSHowMapCell) {
            RouteMapTableViewCell *cell = (RouteMapTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RouteMapTableViewCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showMapCell:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;
            if (indexPath.row != 0) {
                cell.circleImageView.hidden = false;
                cell.fullLine.hidden = false;
                cell.halfLine.hidden = true;
                cell.leaveImageView.hidden = true;
                cell.leaveImageHeightConstraint.constant = 0;
                cell.labelTopConstraint.constant = -2;
                cell.mapView.hidden = false;
            }
            [self loadView:cell];
            return cell;

        }else {
            RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showMapCell:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;
            if (indexPath.row != 0) {
                cell.circleImageView.hidden = false;
                cell.fullLine.hidden = false;
                cell.halfLine.hidden = true;
                cell.leaveImageView.hidden = true;
                cell.leaveImageHeightConstraint.constant = 0;
                cell.labelTopConstraint.constant = -2;
                cell.alertView.hidden = false;
            }
            return cell;

        }

    }else {
        
        if (isShowDetail) {
            RouteStopsTableViewCell * cell = (RouteStopsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;
            if (indexPath.row != 0) {
                cell.circleImageView.hidden = false;
                cell.fullLine.hidden = false;
                cell.halfLine.hidden = true;
                cell.leaveImageView.hidden = true;
                cell.leaveImageHeightConstraint.constant = 0;
                cell.labelTopConstraint.constant = -2;
                cell.alertView.hidden = false;
            }
            return cell;

        }else {
            RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;
            if (indexPath.row != 0) {
                cell.circleImageView.hidden = false;
                cell.fullLine.hidden = false;
                cell.halfLine.hidden = true;
                cell.leaveImageView.hidden = true;
                cell.leaveImageHeightConstraint.constant = 0;
                cell.labelTopConstraint.constant = -2;
                cell.alertView.hidden = false;
            }
            return cell;

        }
    }
}

- (void)addlabels:(RouteTableViewCell *)clickedCell {
   
    lblY = clickedCell.detailBtn.frame.origin.y + clickedCell.detailBtn.frame.size.height + 5;
    int lblX = clickedCell.detailBtn.frame.origin.x;
    for (int index = 0; index < stopsArray.count; index++) {
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX,lblY, 200, 17)];
        lbl.text = [NSString stringWithFormat:@"%@",[stopsArray objectAtIndex:index]];
        lbl.font = [UIFont systemFontOfSize:12];
        [clickedCell addSubview:lbl];
        lblY = lblY+19;
    }
//    lblY = lblY + cell.alertView.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)showDetail:(id)sender {
   
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//    RouteTableViewCell *routeCell = (RouteTableViewCell *)[tableview cellForRowAtIndexPath:indexPath];

    tag = (int)[sender tag];
    isShowDetail =! isShowDetail;
//    if (isShowDetail) {
////        [self addlabels:routeCell];
//    }else {
//        
//    }
    [tableview reloadData];
}

- (IBAction)showMapCell:(id)sender {
    isSHowMapCell =! isSHowMapCell;
    [tableview reloadData];
}


- (void)loadView:(RouteMapTableViewCell *)cell {
    
    ModelLocator *model = [ModelLocator getInstance];
    
    CLLocation *loction = [[CLLocation alloc] initWithLatitude:model.userCoordinates.latitude longitude:model.userCoordinates.longitude];
    CLLocation *loction1 = [[CLLocation alloc] initWithLatitude:51.4794846  longitude:-3.1829101];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, [HelperClass getCellHeight:235 OriginalWidth:375].height) camera:camera];
    
    
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:loction.coordinate coordinate:loction1.coordinate];
    [mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    
    mapView.userInteractionEnabled = false;
    [cell.mapView addSubview:mapView];
    
    // Creates a marker in the center of the map.
    
    
    
    [self drawPathFrom:loction toDestination:loction1];
    
    GMSMarker *marker=[[GMSMarker alloc]init];
    marker.position=loction.coordinate;
    marker.map=mapView;
    
    GMSMarker *marker1=[[GMSMarker alloc]init];
    marker1.position=loction1.coordinate;
    marker1.map=mapView;
    
    
    
}


-(void)drawPathFrom:(CLLocation*)source toDestination:(CLLocation*)destination{
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", source.coordinate.latitude,  source.coordinate.longitude, destination.coordinate.latitude,  destination.coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Url: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(!connectionError){
            NSDictionary *result        = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *routes             = [result objectForKey:@"routes"];
            NSDictionary *firstRoute    = [routes objectAtIndex:0];
            NSString *encodedPath       = [firstRoute[@"overview_polyline"] objectForKey:@"points"];
            UIColor *color = [UIColor colorWithRed:30.0/255.0 green:179.0/255.0 blue:252.0/255.0 alpha:1.0];
            [self createDashedLine:source.coordinate andNext:destination.coordinate andColor:color andEncodedPath:encodedPath];
        }
    }];
    
}

- (void) createDashedLine:(CLLocationCoordinate2D )thisPoint andNext:(CLLocationCoordinate2D )nextPoint andColor:(UIColor *)colour andEncodedPath:(NSString *)encodedPath
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
    _step = 50000;
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
