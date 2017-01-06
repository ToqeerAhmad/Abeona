//
//  WalkthroughViewController.m
//  Abeona
//
//  Created by Toqir Ahmad on 05/01/2017.
//  Copyright © 2017 Toqir Ahmad. All rights reserved.
//

#import "WalkthroughViewController.h"

@interface WalkthroughViewController ()
{
    CGRect frame;
    UIImageView *imgView;
    NSMutableArray *images;
}
@end

@implementation WalkthroughViewController

@synthesize scrollView,pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpWalkThroughDesign];
}

-(void) viewDidLayoutSubviews
{
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * images.count, SCREEN_HEIGHT)];
}

-(void)setUpWalkThroughDesign
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    images = [[NSMutableArray alloc]initWithObjects: [UIImage imageNamed:@"walkthrough_1"],[UIImage imageNamed:@"walkthrough_2"],[UIImage imageNamed:@"walkthrough_3"], nil];
    
    int numberofViews = (int)[images count];
    
    for (int i = 0; i < numberofViews; i++)
    {
        
        frame.origin.x = [[[UIApplication sharedApplication]delegate]window].frame.size.width * i ;
        frame.origin.y = 0;
        frame.size = [[[UIApplication sharedApplication]delegate]window].frame.size;
        imgView = [[UIImageView alloc] init];
        imgView.frame = frame;
        imgView.image = [images objectAtIndex:i];
        [imgView setUserInteractionEnabled:YES];
        scrollView.pagingEnabled = YES;
        
        
        if (i == 0) {
            
            // [self setSingleLabelInScroll:@"Your Favorite stores delivered anytime, anywhere."];
            // [self setLogoImageOnScrollView];
            
        }else if(i == 1) {
            
            
        }else if (i == 2){
            
            
        }else{
            
            
        }
        
        [scrollView addSubview:imgView];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if( [scrollView isDragging]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setDesignOfPages:page];
        pageControl.currentPage = page;
    }
}

-(IBAction)nextBtnAction:(id)sender
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    page = page+1;
    pageControl.currentPage = page;
    [self setDesignOfPages:page];
    [scrollView setContentOffset:CGPointMake(pageWidth * page, 0) animated:YES];
    
}

- (void)setDesignOfPages:(int)page {
    
    if (page == 0) {
        [self.nextBtn setTitle:@"    GET STARTED" forState:UIControlStateNormal];
        self.switchView.hidden = true;
    }else if (page == 1) {
        [self.nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        self.switchView.hidden = true;
    }else if (page == 2) {
        [self.nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        self.switchView.hidden = false;
    }else {
        SignInViewController *siginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
        [self.navigationController pushViewController:siginVC animated:true];

    }
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
