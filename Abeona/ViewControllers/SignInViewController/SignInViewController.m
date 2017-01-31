//
//  SignInViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pushToHomeScreen:(id)sender {
    
    
    if (![_emailTextField.text isEqualToString:@""]) {
        if ([HelperClass isValidEmail:_emailTextField.text]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:_emailTextField.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            HomeViewController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [self.navigationController pushViewController:homeVc animated:true];
        }else {
            [HelperClass showAlertView:@"Alert" andMessage:@"Please enter a valid email address."];
        }
    }else {
        [HelperClass showAlertView:@"Alert" andMessage:@"Please enter your email."];
    }
    
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
