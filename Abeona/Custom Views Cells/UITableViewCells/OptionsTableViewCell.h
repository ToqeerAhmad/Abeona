//
//  OptionsTableViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblRouteType;
@property (nonatomic, weak) IBOutlet UILabel *lblTime;
@property (nonatomic, weak) IBOutlet UILabel *lblArrive_DepartTime;
@property (nonatomic, weak) IBOutlet UILabel *lblBottomNOte;
@property (nonatomic, weak) IBOutlet UILabel *lblAmount;
@property (nonatomic, weak) IBOutlet UIImageView *transportTypeImage;

@end
