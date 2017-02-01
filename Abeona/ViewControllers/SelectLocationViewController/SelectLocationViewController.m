//
//  SelectLocationViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 06/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "SelectLocationViewController.h"

@interface SelectLocationViewController ()
{
    MBProgressHUD *progressBar;
    ModelLocator *model;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintofGetRoutesBtn;

@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [ModelLocator getInstance];
    // Do any additional setup after loading the view.
    _bottomConstraintofGetRoutesBtn.constant = 30;
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiffDetail"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (IBAction)GetRoutes:(id)sender {
    
    if ([model.country isEqualToString:@"United Kingdom"]) {
        [self drawPathFrom:@"DRIVING"];
    }else {
        [self getAirportCodeFromLatLong];
    }
}

- (void)getAirportCodeFromLatLong {
    
    NSMutableDictionary *dict;
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://iatageo.com/getCode/%f/%f",model.userCoordinates.latitude , model.userCoordinates.longitude];
    
    [service SendRequestForData:dict andServiceURL:baseUrl andServiceReturnType:@"AirportCode"];

}

- (void)getdataFromQPX {
    
    
    NSDictionary *paramDict = [[NSDictionary alloc]initWithObjectsAndKeys:model.code,@"origin",
                               @"CWL",@"destination",
                               @"2017-06-03",@"date",nil];
    NSMutableArray *sliceArray = [NSMutableArray array];
    [sliceArray addObject:paramDict];
    
    NSDictionary *adultCountDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"adultCount",nil];
    NSDictionary *dictparm = [[NSDictionary alloc]initWithObjectsAndKeys:sliceArray,@"slice",
                              adultCountDict,@"passengers",
                              @"20",@"solutions",nil];
    NSDictionary *actuallParmeeters = [[NSDictionary alloc]initWithObjectsAndKeys:dictparm,@"request", nil];
    NSLog(@"%@", actuallParmeeters);
    
    
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDBrEtOB7k5kKT2Vop_kwH69bIeCbLFH34"];
    [service getDataFromQPX:actuallParmeeters andServiceURL:url andServiceReturnType:@"QPX"];
}




-(void)drawPathFrom:(NSString *)mode {
    
    NSMutableDictionary *dict;
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=%@&sensor=true",model.userCoordinates.latitude , model.userCoordinates.longitude , 51.478209, -3.182634, mode];
    
    [service SendRequestForData:dict andServiceURL:baseUrl andServiceReturnType:mode];
    
}

-(void) webServiceStart {
    progressBar=[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:NO];
    progressBar.labelText=@"Please Wait...";
    [progressBar show:YES];
}


/////// in case error occured in web service

-(void) webServiceError:(NSString *)errorType {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:errorType preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
    [alertController addAction:cancel];
//    [alertController addAction:retry];
    [progressBar hide:YES];
}

-(void)drawPathFromAirportCardiff:(NSString *)mode {
    
    NSMutableDictionary *dict;
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=%@&sensor=true",51.3985 , -3.3395 , 51.478209, -3.182634, mode];
    
    [service SendRequestForData:dict andServiceURL:baseUrl andServiceReturnType:mode];
    
}


// successful web service call end //////////
-(void) webServiceEnd:(id)returnObject andResponseType:(id)responseType {
    
    [progressBar hide:YES];
    if ([responseType isEqualToString:@"AirportCode"]) {
        [self getdataFromQPX];
    }else if ([responseType isEqualToString:@"QPX"]) {
        
        [self drawPathFromAirportCardiff:@"transit"];
        
    }else if ([responseType isEqualToString:@"DRIVING"]) {
        
        [self drawPathFrom:@"transit"];
        
    }else if ([responseType isEqualToString:@"transit"]) {
        
        GetRoutesViewController *routesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GetRoutesViewController"];
        [self.navigationController pushViewController:routesVC animated:true];
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
