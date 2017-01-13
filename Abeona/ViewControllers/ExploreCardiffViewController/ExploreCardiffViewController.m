//
//  ExploreCardiffViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "ExploreCardiffViewController.h"

@interface ExploreCardiffViewController ()  
{
    BOOL isMapSelected;
    NSMutableArray *placesArray;
    BOOL isMapLoaded;
}
@end

@implementation ExploreCardiffViewController

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
   model = [ModelLocator getInstance];
    // Do any additional setup after loading the view.
    placesArray = [[NSMutableArray alloc] initWithArray:model.resposeArray];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCardiff"]) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ResponseModel *selectedObject = [model.resposeArray objectAtIndex:model.index];
        [self sendToDetailVC:selectedObject];
    }else {
        if (!isMapLoaded) {
            isMapLoaded = true;
            [self loadView];
        }
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.topView];
    [self.table registerNib:[UINib nibWithNibName:@"ExploreCardiffTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExploreCardiffCell"];

}

-(void)setAnnotations
{

//    [self zoomMap:0.01 andCoordiantes:coordinates];
}

#pragma mark - MAPView Delegate

- (void)loadView {
    
    
     [super loadView];
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    self.mapContainerView.delegate = self;
    for(ResponseModel *placeObject in placesArray)
    {
        CLLocationCoordinate2D position = { [placeObject.lattitude doubleValue], [placeObject.longitude    doubleValue] };
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.map = self.mapContainerView;
        marker.icon = [UIImage imageNamed:@"annotationImage"];
        
    }
    ResponseModel *placeObject = [placesArray objectAtIndex:0];
   CLLocationCoordinate2D coordinates =  CLLocationCoordinate2DMake(placeObject.lattitude.doubleValue, placeObject.longitude.doubleValue);

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                            longitude:coordinates.longitude
                                                                 zoom:15];

    
    //set the camera for the map
    self.mapContainerView.camera = camera;
    self.mapContainerView.myLocationEnabled = YES;
    
}

- (void)chnageMapMarkers {
    
    for(ResponseModel *placeObject in placesArray)
    {
        CLLocationCoordinate2D position = { [placeObject.lattitude doubleValue], [placeObject.longitude    doubleValue] };
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.map = self.mapContainerView;
        marker.icon = [UIImage imageNamed:@"annotationImage"];
        
    }

}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    for (ResponseModel *object in placesArray) {
        if (marker.position.longitude == object.longitude.doubleValue && marker.position.latitude == object.lattitude.doubleValue ) {
            MapCallOutView *customView =  [[[NSBundle mainBundle] loadNibNamed:@"MapCallOutView" owner:self options:nil] objectAtIndex:0];
            customView.lblTitle.text = [object.title stringByReplacingOccurrencesOfString:@"#038;" withString:@""];
            [customView.placeImage setImageWithURL:[NSURL URLWithString:object.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            return customView;
        }else {
            
        }
    }
    return nil;
}


-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [mapView setSelectedMarker:marker];
    return true;
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    for (ResponseModel *object in placesArray) {
        if (marker.position.longitude == object.longitude.doubleValue && marker.position.latitude == object.lattitude.doubleValue ) {
            [self sendToDetailVC:object];
        }
    }
}

- (void)sendToDetailVC:(ResponseModel *)selectedObject {
    
    ExploreCardiffDetailViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreCardiffDetailViewController"];
    detailVc.placeObject = selectedObject;
    [self.navigationController pushViewController:detailVc animated:true];

}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ResponseModel *placeObject = [placesArray objectAtIndex:indexPath.row];
    ExploreCardiffTableViewCell *cell = (ExploreCardiffTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExploreCardiffCell" forIndexPath:indexPath];
    [cell.placeImage setImageWithURL:[NSURL URLWithString:placeObject.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.lblTitle.text = [placeObject.title stringByReplacingOccurrencesOfString:@"#038;" withString:@""];
    cell.lblAttraction_type.text = placeObject.type;
    cell.lblAddress.text = placeObject.address;
    cell.lblHours.text = placeObject.hours;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self sendToDetailVC:[placesArray objectAtIndex:indexPath.row]];
}


- (IBAction)changeView:(id)sender {
    
    if (isMapSelected) {
        isMapSelected = false;
        [self.rightBarButton setImage:[UIImage imageNamed:@"listIcon"] forState:UIControlStateNormal];
        self.table.hidden = true;
        self.mapContainerView.hidden = false;
    }else {
        isMapSelected = true;
        [self.rightBarButton setImage:[UIImage imageNamed:@"mapIcon"] forState:UIControlStateNormal];
        self.table.hidden = false;
        self.mapContainerView.hidden = true;
    }
}

- (IBAction)selectCategoryForPlaces:(id)sender {
    
    placesArray = [[NSMutableArray alloc] init];
    if ([sender tag] == 0) { // ALL
        placesArray = model.resposeArray;
    }else if ([sender tag] == 1) {
        for (ResponseModel *placeObject in model.resposeArray) {
            if ([placeObject.type isEqualToString:@"Eat & Drink"]) {
                [placesArray addObject:placeObject];
            }
        }
    }else if ([sender tag] == 2) {
        for (ResponseModel *placeObject in model.resposeArray) {
            if ([placeObject.type isEqualToString:@"See & Do"]) {
                [placesArray addObject:placeObject];
            }
        }
    }else {
        for (ResponseModel *placeObject in model.resposeArray) {
            if ([placeObject.type isEqualToString:@"Shopping"]) {
                [placesArray addObject:placeObject];
            }
        }
    }
    
    [self.table reloadData];
    [self.mapContainerView clear];
    [self chnageMapMarkers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

    
    //

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
