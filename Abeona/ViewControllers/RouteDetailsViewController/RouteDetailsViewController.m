
//
//  RouteDetailsViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "RouteDetailsViewController.h"

@interface RouteDetailsViewController ()

@end

@implementation RouteDetailsViewController

@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [tableview registerNib:[UINib nibWithNibName:@"RouteTableViewCell" bundle:nil] forCellReuseIdentifier:@"routeDetailCell"];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RouteTableViewCell *cell = (RouteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"routeDetailCell" forIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
