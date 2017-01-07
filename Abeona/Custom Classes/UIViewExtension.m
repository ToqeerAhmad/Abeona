//
//  UIViewExtension.m
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "UIViewExtension.h"

@implementation UIViewExtension

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.borderColor = [HelperClass colorwithHexString:@"bfbfbf" alpha:1.0].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = true;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
