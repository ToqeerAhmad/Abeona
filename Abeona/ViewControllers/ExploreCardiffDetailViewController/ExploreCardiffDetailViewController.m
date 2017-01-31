//
//  ExploreCardiffDetailViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//



#import "ExploreCardiffDetailViewController.h"


@interface ExploreCardiffDetailViewController ()  <GMSMapViewDelegate>
{
    ModelLocator *model;
    GMSMapView *mapView;
    NSArray *_styles;
    NSArray *_lengths;
    NSArray *_polys;
    double _pos, _step;
    GMSCameraPosition *camera;

}
@end

@implementation ExploreCardiffDetailViewController

@synthesize placeObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.table registerNib:[UINib nibWithNibName:@"PicturesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PicturesTableViewCell"];
    [self.table registerNib:[UINib nibWithNibName:@"DetailDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailDescriptionCell"];
    [self.table registerNib:[UINib nibWithNibName:@"MapTableViewCell" bundle:nil] forCellReuseIdentifier:@"MapTableViewCell"];

}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [HelperClass getCellHeight:365 OriginalWidth:375].height;
    }else if (indexPath.row == 1) {
        return [HelperClass getCellHeight:250 OriginalWidth:375].height;
    }else {
        return [HelperClass getCellHeight:376 OriginalWidth:375].height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PicturesTableViewCell *cell = (PicturesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PicturesTableViewCell" forIndexPath:indexPath];
        cell.placeObject = placeObject;
        [cell setUpCell];
        return cell;

    }else if (indexPath.row == 1) {
        
        DetailDescriptionTableViewCell *cell = (DetailDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailDescriptionCell" forIndexPath:indexPath];
        
        NSString *refinedDescription = [placeObject.content stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        refinedDescription = [refinedDescription stringByReplacingOccurrencesOfString:@"#8217;s" withString:@""];
        refinedDescription = [refinedDescription stringByReplacingOccurrencesOfString:@"#038;" withString:@""];
        refinedDescription = [refinedDescription stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        cell.txtcontent.text = refinedDescription;
        return cell;
        
    }else {
        
        MapTableViewCell *cell = (MapTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MapTableViewCell" forIndexPath:indexPath];
        [self loadView:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadView:(MapTableViewCell *)cell {
    
    model = [ModelLocator getInstance];
    
    CLLocation *loction = [[CLLocation alloc] initWithLatitude:model.userCoordinates.latitude longitude:model.userCoordinates.longitude];
    CLLocation *loction1 = [[CLLocation alloc] initWithLatitude:placeObject.lattitude.doubleValue  longitude:placeObject.longitude.doubleValue];

    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-34, [HelperClass getCellHeight:315 OriginalWidth:375].height) camera:camera];
    
    
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:loction.coordinate coordinate:loction1.coordinate];
    [mapView moveCamera:[GMSCameraUpdate fitBounds:bounds]];

    
    mapView.userInteractionEnabled = true;
    [cell.customView addSubview:mapView];
    
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
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
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
