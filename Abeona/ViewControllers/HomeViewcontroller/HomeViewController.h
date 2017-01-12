//
//  HomeViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 10/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelLocator.h"

@interface HomeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionview;
@property (nonatomic, strong) ModelLocator *model;


@end
