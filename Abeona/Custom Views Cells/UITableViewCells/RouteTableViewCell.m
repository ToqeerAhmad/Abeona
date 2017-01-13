//
//  RouteTableViewCell.m
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "RouteTableViewCell.h"

@implementation RouteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ticketBtn.layer.cornerRadius = 3;
    self.ticketBtn.layer.masksToBounds = true;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
