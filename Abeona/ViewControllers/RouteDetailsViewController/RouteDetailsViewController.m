
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
    if (indexPath.row != 0) {
        return 165;
    }else {
        return 175;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        if (indexPath.row == 0) {
            
            RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showMapCell:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;

            cell.circleImageView.hidden = true;
            cell.fullLine.hidden = true;
            cell.halfLine.hidden = false;
            cell.leaveImageView.hidden = false;
            cell.alertView.hidden = true;
             return cell;
            
        }else {
            
            RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
            [cell.detailBtn addTarget:self action:@selector(showMapCell:) forControlEvents:UIControlEventTouchUpInside];
            cell.detailBtn.tag = indexPath.row;

            cell.leaveImageHeightConstraint.constant = 0;
            cell.labelTopConstraint.constant = -2;
            cell.circleImageView.hidden = false;
            cell.fullLine.hidden = false;
            cell.halfLine.hidden = true;
            cell.leaveImageView.hidden = true;
            cell.alertView.hidden = false;
            return cell;
            
        }
    
    
}

- (void)addlabels:(RouteTableViewCell *)clickedCell {
   
//    lblY = clickedCell.detailBtn.frame.origin.y + clickedCell.detailBtn.frame.size.height + 5;
//    int lblX = clickedCell.detailBtn.frame.origin.x;
//    for (int index = 0; index < stopsArray.count; index++) {
//        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX,lblY, 200, 17)];
//        lbl.text = [NSString stringWithFormat:@"%@",[stopsArray objectAtIndex:index]];
//        lbl.font = [UIFont systemFontOfSize:12];
//        [clickedCell addSubview:lbl];
//        lblY = lblY+19;
//    }
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
    
    
    CLLocation *loction = [[CLLocation alloc] initWithLatitude:51.5033 longitude:-0.1195];
    CLLocation *loction1 = [[CLLocation alloc] initWithLatitude:51.4782  longitude:-3.1826];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, [HelperClass getCellHeight:235 OriginalWidth:375].height) camera:camera];
    
    
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:loction.coordinate coordinate:loction1.coordinate];
    [mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    
    mapView.userInteractionEnabled = true;
    [cell.mapView addSubview:mapView];
    
    // Creates a marker in the center of the map.
    
    
    GMSMarker *marker=[[GMSMarker alloc]init];
    marker.position=loction.coordinate;
    marker.map=mapView;
    
    GMSMarker *marker1=[[GMSMarker alloc]init];
    marker1.position=loction1.coordinate;
    marker1.map=mapView;
    
    
    
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
