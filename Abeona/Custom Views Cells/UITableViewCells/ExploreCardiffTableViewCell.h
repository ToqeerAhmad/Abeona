//
//  ExploreCardiffTableViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 08/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreCardiffTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblAttraction_type;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView *placeImage;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;
@property (nonatomic, weak) IBOutlet UILabel *lblHours;

@end
