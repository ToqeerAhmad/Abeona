//
//  RouteMapTableViewCell.m
//  Abeona
//
//  Created by Toqir Ahmad on 12/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "RouteMapTableViewCell.h"

@implementation RouteMapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mapView.layer.cornerRadius = 3.0;
    self.mapView.layer.borderColor = [HelperClass colorwithHexString:@"2C2C2C" alpha:1.0].CGColor;
    self.mapView.layer.borderWidth = 1.0;
    self.mapView.layer.masksToBounds = true;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
