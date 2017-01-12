//
//  ExploreCardiffDetailViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//



#import "ExploreCardiffDetailViewController.h"


@interface ExploreCardiffDetailViewController ()  <GMSMapViewDelegate>

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
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    CLLocationCoordinate2D coordinates =  CLLocationCoordinate2DMake(placeObject.lattitude.doubleValue, placeObject.longitude.doubleValue);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinates.latitude
                                                            longitude:coordinates.longitude
                                                                 zoom:15];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, cell.customView.frame.size.width,cell.customView.frame.size.height ) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.userInteractionEnabled = false;
    mapView.myLocationEnabled = YES;
    [cell.customView addSubview:mapView];
    
    // Creates a marker in the center of the map.
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
