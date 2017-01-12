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
    MBProgressHUD *progressBar;
}
@end

@implementation ExploreCardiffViewController

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
   model = [ModelLocator getInstance];
    // Do any additional setup after loading the view.

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
//        [self getDataFromAPI];
       
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:14];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapContainerView;
    
    //set the camera for the map
    self.mapContainerView.camera = camera;
    
    self.mapContainerView.myLocationEnabled = YES;
    
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
        self.mapContainerView.hidden = false;
    }else {
        isMapSelected = true;
        [self.rightBarButton setImage:[UIImage imageNamed:@"mapIcon"] forState:UIControlStateNormal];
        self.table.hidden = false;
        self.mapContainerView.hidden = true;
    }
}



- (void)callMe:(UIButton *)sender {
    
}
    
#pragma mark - Web API
    
- (void)getDataFromAPI {
    
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [service SendRequestForData:params andServiceURL:@"https://www.projectabeona.com/wp-json/wp/v2/pages/?parent=6" andServiceReturnType:@""];
    
}



-(void) webServiceStart
{
    progressBar=[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:NO];
    progressBar.labelText=@"Please Wait...";
    [progressBar show:YES];
}


/////// in case error occured in web service

-(void) webServiceError:(NSString *)errorType
{
    [HelperClass showAlertView:@"Alert" andMessage:errorType andView:self];
    [progressBar hide:YES];
}


// successful web service call end //////////

-(void) webServiceEnd
{
    
    [progressBar hide:YES];
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
