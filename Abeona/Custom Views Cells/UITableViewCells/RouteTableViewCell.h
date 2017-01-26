//
//  RouteTableViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leaveImageHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapHeightConstraint;

@property (nonatomic, strong) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *stopsViewHeightConstraint;


// Stops View Outlets
@property (nonatomic, strong) IBOutlet UIView *stopsView;
@property (nonatomic, strong) IBOutlet UILabel *lblDepartTime;
@property (nonatomic, strong) IBOutlet UILabel *lblDepartPlace;
@property (nonatomic, strong) IBOutlet UILabel *lblArrivalTime;
@property (nonatomic, strong) IBOutlet UILabel *lblArrivalPlace;

@property (nonatomic, strong) IBOutlet UIImageView *leaveImageView;
@property (nonatomic, strong) IBOutlet UIImageView *circleImageView;

@property (nonatomic, strong) IBOutlet UIView *halfLine;
@property (nonatomic, strong) IBOutlet UIView *fullLine;

@property (nonatomic, strong) IBOutlet UIButton *detailBtn;

@property (nonatomic, strong) IBOutlet UILabel *lblTotalTime;
@property (nonatomic, strong) IBOutlet UILabel *lblStepTime;
@property (nonatomic, strong) IBOutlet UILabel *lblHtmlText;
@property (nonatomic, strong) IBOutlet UILabel *lblAddress;
@property (nonatomic, strong) IBOutlet UIImageView *mode_Image;
@property (nonatomic, strong) IBOutlet UILabel *mode_type;

- (void)setUpCell ;

@end
