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
    self.customView.layer.cornerRadius = 3.0;
    self.customView.layer.borderColor = [HelperClass colorwithHexString:@"2C2C2C" alpha:1.0].CGColor;
    self.customView.layer.borderWidth = 1.0;
    self.customView.layer.masksToBounds = true;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
