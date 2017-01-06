//
//  PlanJourneyViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "PlanJourneyViewController.h"

@interface PlanJourneyViewController ()

@end

@implementation PlanJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (IBAction)pushToSelectLocation:(id)sender {
    
    SelectLocationViewController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectLocationViewController"];
    [self.navigationController pushViewController:homeVc animated:true];
    
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
