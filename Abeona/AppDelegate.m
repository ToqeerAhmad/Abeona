//
//  AppDelegate.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //AIzaSyDY6suhoKhvv9C6ibXBtCuVQTfluSL38AI
    

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = (id)self;
    [GMSServices provideAPIKey:@"AIzaSyBqEj7yKo2i9af_Sye87iEV36bsXOUt8a8"];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    [ModelLocator getInstance].userCoordinates = manager.location.coordinate;
    [self updateLocation];
}

- (void)updateLocation {
    
    ModelLocator *model = [ModelLocator getInstance];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation ;
    
    newLocation= [[CLLocation alloc]initWithLatitude:model.userCoordinates.latitude
                                           longitude:model.userCoordinates.longitude];
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Geocode failed with error: %@", error.localizedDescription);
                           return;
                       }
                       if (placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary =
                           placemark.addressDictionary;
                           
                           NSLog(@"%@ ", addressDictionary);
                           model.country = [addressDictionary valueForKey:@"Country"];
                       }
                   }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    NSLog(@"error::%@",error);
//    switch([error code])
//    {
//        case kCLErrorNetwork: // general, network-related error
//        {
//            [HelperClass showAlertView:@"Error" andMessage:@"Please check your network connection or that you are not in airplane mode" andView:self.window.rootViewController];
//        }
//            break;
//        case kCLErrorDenied:{
//            [HelperClass showAlertView:@"Error" andMessage:@"User has denied to use current Location" andView:self.window.rootViewController];
//        }
//            break;
//        default:
//        {
//            [HelperClass showAlertView:@"Error" andMessage:@"Please enable your location for app." andView:self.window.rootViewController];
//        }
//            break;
//    }
}


@end
