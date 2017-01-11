//
//  ExploreCardiffViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "ExploreCardiffViewController.h"

@interface ExploreCardiffViewController ()  <GMSMapViewDelegate>
{
    BOOL isMapSelected;
}
@end

@implementation ExploreCardiffViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.table registerNib:[UINib nibWithNibName:@"ExploreCardiffTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExploreCardiffCell"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isCardiff"]) {
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiff"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ExploreCardiffDetailViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreCardiffDetailViewController"];
        [self.navigationController pushViewController:detailVc animated:false];
    }else {
        [self loadView];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)setAnnotations
{

//    [self zoomMap:0.01 andCoordiantes:coordinates];
}

#pragma mark - MAPView Delegate

- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) camera:camera];
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.icon = [UIImage imageNamed:@"annotationImage"];
    marker.map = mapView;
    marker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
     MapCallOutView *customView =  [[[NSBundle mainBundle] loadNibNamed:@"MapCallOutView" owner:self options:nil] objectAtIndex:0];
    [customView.viewDetailBtn addTarget:self action:@selector(callMe:) forControlEvents:UIControlEventTouchUpInside];
    return customView;
}


-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [mapView setSelectedMarker:marker];
    return true;
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    ExploreCardiffDetailViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreCardiffDetailViewController"];
    [self.navigationController pushViewController:detailVc animated:true];

}




#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExploreCardiffTableViewCell *cell = (ExploreCardiffTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExploreCardiffCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self callMe:nil];
}


- (IBAction)changeView:(id)sender {
    
    if (isMapSelected) {
        isMapSelected = false;
        [self.rightBarButton setImage:[UIImage imageNamed:@"listIcon"] forState:UIControlStateNormal];
        self.table.hidden = true;
    }else {
        isMapSelected = true;
        [self.rightBarButton setImage:[UIImage imageNamed:@"mapIcon"] forState:UIControlStateNormal];
        self.table.hidden = false;
    }
}



- (void)callMe:(UIButton *)sender {
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
