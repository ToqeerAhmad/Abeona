//
//  RouteStopsTableViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 12/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteStopsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leaveImageHeightConstraint;

@property (nonatomic, strong) IBOutlet UIImageView *leaveImageView;
@property (nonatomic, strong) IBOutlet UIImageView *circleImageView;

@property (nonatomic, strong) IBOutlet UIView *halfLine;
@property (nonatomic, strong) IBOutlet UIView *fullLine;
@property (nonatomic, strong) IBOutlet UIView *alertView;

@property (nonatomic, strong) IBOutlet UIButton *detailBtn;
@property (nonatomic, strong) IBOutlet UIButton *ticketBtn;


@end
