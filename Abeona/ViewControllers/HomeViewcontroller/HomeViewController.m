//
//  HomeViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 10/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "HomeViewController.h"
#import "PlaceCollectionViewCell.h"

@interface HomeViewController ()
{
    MBProgressHUD *progressBar;

}
@end

@implementation HomeViewController
@synthesize model;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    model = [ModelLocator getInstance];
    [super viewWillAppear:animated];
    
    [self getDataFromAPI];
}

- (IBAction)pushToTabBarView:(id)sender {
    UITabBarController *homeVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [self.navigationController pushViewController:homeVc animated:true];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isCardiff"];
    [[NSUserDefaults standardUserDefaults] synchronize];


}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return model.resposeArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float height = [HelperClass getCellHeight:188 OriginalWidth:375].height;
    return CGSizeMake((SCREEN_WIDTH-28)/2, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ResponseModel *object = [model.resposeArray objectAtIndex:indexPath.row];
    PlaceCollectionViewCell *cell = (PlaceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ArtworkByArtistCell" forIndexPath:indexPath];
    [cell.placeImage setImageWithURL:[NSURL URLWithString:object.image] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.lblAttraction_type.text = object.type;
    cell.lblTypeMarket.text = object.typeMarket;

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    model.index = (int)indexPath.row;
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

#pragma mark - Web API

- (void)getDataFromAPI {
    
    WebServices *service = [[WebServices alloc] init];
    service.delegate = self;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [service SendRequestForData:params andServiceURL:@"https://www.projectabeona.com/wp-json/wp/v2/pages/?parent=6" andServiceReturnType:@""];
    
}



-(void) webServiceStart
{
    progressBar=[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:NO];
    progressBar.labelText=@"Please Wait...";
    [progressBar show:YES];
}


/////// in case error occured in web service

-(void) webServiceError:(NSString *)errorType
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:errorType preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self getDataFromAPI];
    }];
    [alertController addAction:cancel];
    [alertController addAction:retry];
    [progressBar hide:YES];
}


// successful web service call end //////////
-(void) webServiceEnd:(id)returnObject andResponseType:(id)responseType {
    [self.collectionview reloadData];
    [progressBar hide:YES];
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
