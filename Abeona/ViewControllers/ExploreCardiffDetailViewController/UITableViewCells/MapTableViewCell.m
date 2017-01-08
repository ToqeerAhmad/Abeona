//
//  MapTableViewCell.m
//  Abeona
//
//  Created by Toqir Ahmad on 09/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mapview.layer.cornerRadius = 3.0;
    self.mapview.layer.borderColor = [HelperClass colorwithHexString:@"2C2C2C" alpha:1.0].CGColor;
    self.mapview.layer.borderWidth = 1.0;
    self.mapview.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
