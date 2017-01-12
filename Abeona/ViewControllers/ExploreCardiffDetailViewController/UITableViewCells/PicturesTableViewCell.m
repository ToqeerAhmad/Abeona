//
//  PicturesTableViewCell.m
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "PicturesTableViewCell.h"

@implementation PicturesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpCell {
    
    [self.placeImage setImageWithURL:[NSURL URLWithString:_placeObject.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.lblTitle.text = _placeObject.title;
    self.lblTypeMarket.text = _placeObject.type;
    self.lblAddress.text = _placeObject.address;
    self.lblHours.text = _placeObject.hours;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
