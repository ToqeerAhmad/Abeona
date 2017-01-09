//
//  ExploreCardiffViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "ExploreCardiffViewController.h"
#import <MapKit/MapKit.h>

@interface ExploreCardiffViewController () 
{
    BOOL isMapSelected;
}
@end

@implementation ExploreCardiffViewController

@synthesize map,customView;

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
        [self setAnnotations];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)setAnnotations
{
    map.delegate = self;
//    [map setUserTrackingMode:MKUserTrackingModeFollow];
    [map setMapType:MKMapTypeStandard];
    [map setZoomEnabled:YES];
    [map setScrollEnabled:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.554606, 74.357158);
    
    DXAnnotation *annotation1 = [[DXAnnotation alloc] initWithLocation:coordinate andTag:0];
    [map addAnnotation:annotation1];
    [map setRegion:MKCoordinateRegionMakeWithDistance(annotation1.coordinate, 10000, 10000)];

//    [self zoomMap:0.01 andCoordiantes:coordinates];
}

#pragma mark - MAPView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[DXAnnotation class]]) {
        
        UIImageView *pinView = nil;
        
        DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
        if (!annotationView) {
            pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"annotationImage"]];
            customView = [[[NSBundle mainBundle] loadNibNamed:@"MapCallOutView" owner:self options:nil] firstObject];
            [customView.viewDetailBtn addTarget:self action:@selector(callMe:) forControlEvents:UIControlEventTouchUpInside];
            DXAnnotation *anotation = annotation;
            customView.viewDetailBtn.tag = anotation.tagDX;
            annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:NSStringFromClass([DXAnnotationView class])
                                                                  pinView:pinView
                                                              calloutView:customView
                                                                 settings:[DXAnnotationSettings defaultSettings]];
        }else {
            
            //Changing PinView's image to test the recycle
            pinView = (UIImageView *)annotationView.pinView;
            pinView.image = [UIImage imageNamed:@"annotationImage"];
        }
        
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([view isKindOfClass:[DXAnnotationView class]]) {
        [((DXAnnotationView *)view)hideCalloutView];
        view.layer.zPosition = -1;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view isKindOfClass:[DXAnnotationView class]]) {
        [((DXAnnotationView *)view)showCalloutView];
        view.layer.zPosition = 0;
    }
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
    ExploreCardiffDetailViewController *detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreCardiffDetailViewController"];
    [self.navigationController pushViewController:detailVc animated:true];
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
