//
//  HomeViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 10/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionview;

@end
