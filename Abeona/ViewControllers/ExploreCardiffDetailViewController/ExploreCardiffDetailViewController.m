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
        return [HelperClass getCellHeight:165 OriginalWidth:375].height;
    }else {
        return [HelperClass getCellHeight:376 OriginalWidth:375].height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PicturesTableViewCell *cell = (PicturesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PicturesTableViewCell" forIndexPath:indexPath];
        return cell;

    }else if (indexPath.row == 1) {
        
        DetailDescriptionTableViewCell *cell = (DetailDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailDescriptionCell" forIndexPath:indexPath];
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, cell.customView.frame.size.width,cell.customView.frame.size.height ) camera:camera];
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
