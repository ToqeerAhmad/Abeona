//
//  UILabelClass.m
//  Nyfty
//
//  Created by Toqir Ahmad on 08/10/2016.
//  Copyright © 2016 Atif Mehmood. All rights reserved.
//

#import "UILabelClass.h"

@implementation UILabelClass


- (void)awakeFromNib {
    [super awakeFromNib];
    float size = SCREEN_WIDTH / 375 * self.font.pointSize;
    [self setFont:[UIFont fontWithName:self.font.fontName size:size]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
