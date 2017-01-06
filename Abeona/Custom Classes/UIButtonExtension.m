//
//  UIButtonExtension.m
//  Abeona
//
//  Created by Toqir Ahmad on 06/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "UIButtonExtension.h"

@implementation UIButtonExtension

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = true;
    
    float size = SCREEN_WIDTH / 375 * self.titleLabel.font.pointSize;
    [self.titleLabel setFont:[UIFont fontWithName:self.titleLabel.font.fontName size:size]];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
