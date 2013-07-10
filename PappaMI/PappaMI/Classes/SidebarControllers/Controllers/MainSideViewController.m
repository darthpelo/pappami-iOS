//
//  MainViewController.m
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "MainSideViewController.h"
#import "SidebarController.h"
#import "FlatTheme.h"
#import "Utils.h"
#import "PMHomeView.h"
#import "PMMenuViewController.h"
#import "PMNewsView.h"
#import "PMNewsDetailViewController.h"

@interface MainSideViewController () {
    UIViewController *frontController;
}

@end

@implementation MainSideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
    UIViewController *rearVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:self.controllerId];
    
    frontController = [[UIViewController alloc] init];
    frontController.view.backgroundColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:frontController];

    [FlatTheme styleNavigationBarWithFontName:@"Avenir" andColor:[UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f]];
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    frontController.navigationItem.leftBarButtonItem = menuItem;
    
    self.contentViewController = nav;
    self.contentViewController.view.tag = 0;
    self.sidebarViewController = rearVC;
    
    // Gestione callback selezione elementi da menu sidebar
    __weak MainSideViewController *ms = self;
    __block UIViewController *bFrontController = frontController;
    ((SidebarController *)self.sidebarViewController).closeViewController = ^(NSInteger sectionId){
        [ms revealToggle:nil];
        // logout
        if (sectionId == 0) {
            if (ms.closeViewController)
                ms.closeViewController();
        } else {
            switch (sectionId) {
                case 1:{
                    bFrontController.title = @"Scuole";
                    ms.contentViewController.view.tag = 0;
                    [ms listSubviewsOfView:bFrontController.view];
                    CGRect frame = [Utils getNavigableContentFrame];
//                    if ([ms.userMode isEqualToString:LOGGEDUSER]) {
                        PMHomeView *hv = [[PMHomeView alloc] initWithFrame:frame];
                        [bFrontController.view addSubview:hv];
                        bFrontController.title = @"Scuole";
                        hv.schoolSelected = ^(NSDictionary *school) {
                            UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                            PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                            [menuVC setSchoolData:school];
                            [((UINavigationController *)ms.contentViewController) pushViewController:menuVC animated:YES];
                        };
//                    }
                    break;
                }
                case 2:{
                    bFrontController.title = @"News";
                    ms.contentViewController.view.tag = 1;
                    [ms listSubviewsOfView:bFrontController.view];
                    CGRect frame = [Utils getNavigableContentFrame];
                    PMNewsView *nv = [[PMNewsView alloc] initWithFrame:frame allnews:YES];
                    nv.newsSelected = ^(NSString *content){
                        PMNewsDetailViewController *newsVC = [[PMNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
                        [newsVC setWebContent:content];
                        [((UINavigationController *)ms.contentViewController) pushViewController:newsVC animated:YES];
                    };
                    [bFrontController.view addSubview:nv];
                    break;
                }
                case 3:{
                    bFrontController.title = @"News Dedicate";
                    ms.contentViewController.view.tag = 1;
                    [ms listSubviewsOfView:bFrontController.view];
                    CGRect frame = [Utils getNavigableContentFrame];
                    PMNewsView *nv = [[PMNewsView alloc] initWithFrame:frame allnews:NO];
                    nv.newsSelected = ^(NSString *content){
                        PMNewsDetailViewController *newsVC = [[PMNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
                        [newsVC setWebContent:content];
                        [((UINavigationController *)ms.contentViewController) pushViewController:newsVC animated:YES];
                    };
                    [bFrontController.view addSubview:nv];
                    break;
                }
            }
        }
    };
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.contentViewController.view.tag == 0) {
        CGRect frame = [Utils getNavigableContentFrame];
        frontController.title = @"Home";
//        if ([self.userMode isEqualToString:LOGGEDUSER]) {
            frontController.title = @"Tue Scuole";
            PMHomeView *hv = [[PMHomeView alloc] initWithFrame:frame];
            [frontController.view addSubview:hv];
            hv.schoolSelected = ^(NSDictionary *school) {
                UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                [menuVC setSchoolData:school];
                [((UINavigationController *)self.contentViewController) pushViewController:menuVC animated:YES];
            };
//        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)revealToggle:(id)sender {    
    [super toggleSidebar:!self.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (void)revealGesture:(UIPanGestureRecognizer *)recognizer {
    [super dragContentView:recognizer];
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PMHomeView class]] || [subview isKindOfClass:[PMNewsView class]]) {
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        //[self listSubviewsOfView:subview];
    }
}

@end

