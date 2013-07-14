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
#import "PMMenuViewController.h"
#import "PMNewsView.h"
#import "PMNewsDetailViewController.h"
#import "MBProgressHUD.h"
#import "PMSchoolsView.h"
#import "AFNetworking.h"

#import "PMHomeViewController.h"

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
    
    frontController = [[PMHomeViewController alloc] initWithNibName:nil bundle:nil];
    
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
                case 1:{    // Home Logged User
                    if (ms.contentViewController.view.tag == 0) {
                        break;
                    }
                    bFrontController.title = @"Home";
                    ms.contentViewController.view.tag = 0;
                    [ms removeSubviewsOfView:bFrontController.view];
                    bFrontController = nil;
                    bFrontController = [[PMHomeViewController alloc] initWithNibName:nil bundle:nil];
                    break;
                }
                case 2:{
                    bFrontController.title = @"News";
                    ms.contentViewController.view.tag = 1;
                    [ms removeSubviewsOfView:bFrontController.view];
                    CGRect frame = [Utils getNavigableContentFrame];
                    PMNewsView *nv = [[PMNewsView alloc] initWithFrame:frame allnews:YES];
                    nv.newsSelected = ^(NSString *content){
                        PMNewsDetailViewController *newsVC = [[PMNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
                        [newsVC setWebContent:content];
                        [((UINavigationController *)ms.contentViewController) pushViewController:newsVC animated:YES];
                    };
                    nv.showProgress = ^(BOOL flag){
                        if(flag == YES)
                            [MBProgressHUD showHUDAddedTo:ms.view animated:YES];
                        else
                            [MBProgressHUD hideAllHUDsForView:ms.view animated:YES];
                    };
                    [bFrontController.view addSubview:nv];
                    break;
                }
                case 3:{
                    bFrontController.title = @"News Personalizzate";
                    ms.contentViewController.view.tag = 1;
                    [ms removeSubviewsOfView:bFrontController.view];
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

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.contentViewController.isViewLoaded && self.contentViewController.view.window) {
        // viewController is visible
        if (self.contentViewController.view.tag == 0) {
            [self removeSubviewsOfView:frontController.view];
            CGRect frame = [Utils getNavigableContentFrame];
            
            // L'utente loggato vede l'elenco delle sue scuole.
            if ([self.userMode isEqualToString:LOGGEDUSER]) {
                PMHomeViewController *hvc = [[PMHomeViewController alloc] initWithNibName:nil bundle:nil];
                hvc.homeButtonPressed = ^{
                    [self revealToggle:nil];
                };
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
                self.contentViewController = nav;
            } else {
                frontController.title = @"Home";
                NSURL *url = [NSURL URLWithString:schoolUrl];
                NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    PMSchoolsView *sv = [[PMSchoolsView alloc] initWithFrame:frame];
                    sv.schoolsList = [NSArray arrayWithArray:JSON];
                    sv.schoolSelected = ^(NSDictionary *school) {
                        UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                        PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                        [menuVC setSchoolData:school];
                        [((UINavigationController *)self.contentViewController) pushViewController:menuVC animated:YES];
                    };
                    [frontController.view addSubview:sv];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    PMNSLog("failure");
                }];
                
                [jsonRequest start];
            }
        }
    }
}
*/
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

- (void)removeSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    // Rimozione UIView per news e scuole 
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PMNewsView class]] || [subview isKindOfClass:[PMSchoolsView class]]) {
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        //[self listSubviewsOfView:subview];
    }
}

@end

