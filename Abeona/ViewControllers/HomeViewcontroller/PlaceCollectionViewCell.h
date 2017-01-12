//
//  PlaceCollectionViewCell.h
//  Abeona
//
//  Created by Toqir Ahmad on 12/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblAttraction_type;
@property (nonatomic, weak) IBOutlet UILabel *lblTypeMarket;
@property (nonatomic, weak) IBOutlet UIImageView *placeImage;

@end
