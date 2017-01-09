//
//  HomeViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 10/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pushToTabBarView:(id)sender {
    UITabBarController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:homeVc animated:true];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiff"];
    [[NSUserDefaults standardUserDefaults] synchronize];


}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float height = [HelperClass getCellHeight:188 OriginalWidth:375].height;
    return CGSizeMake((SCREEN_WIDTH-28)/2, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtworkByArtistCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isCardiff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UITabBarController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:homeVc animated:true];

}

- (IBAction)pushToExploreCardiffView:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isCardiffDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UITabBarController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:homeVc animated:true];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
