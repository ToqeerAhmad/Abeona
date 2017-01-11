
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
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, cell.mapView.frame.size.width,cell.mapView.frame.size.height ) camera:camera];
    mapView.myLocationEnabled = YES;
    [cell.mapView addSubview:mapView];
    
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
