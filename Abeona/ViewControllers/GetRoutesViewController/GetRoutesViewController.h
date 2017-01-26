//
//  GetRoutesViewController.h
//  Abeona
//
//  Created by Toqir Ahmad on 07/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetRoutesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *routesOptionstableView;
@property (nonatomic, weak) IBOutlet UILabel *lblCurrentAddress;
@property (nonatomic, weak) IBOutlet UIButton *editJourney;

@end
