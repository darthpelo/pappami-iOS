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
#import "MBProgressHUD.h"
#import "PMSchoolsView.h"
#import "AFNetworking.h"

@interface MainSideViewController ()

@end

static NSString *schoolUrl = @"http://api.pappa-mi.it/api/school/1364003/list";

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
    
    UIViewController *frontController = [[UIViewController alloc] init];
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
    
    // Inizializzazione Home
    frontController.title = @"Home";
    CGRect frame = [Utils getNavigableContentFrame];
    if ([self.userMode isEqualToString:LOGGEDUSER]) {
        UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
        PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
        self.contentViewController = nav;
        menuVC.navigationItem.leftBarButtonItem = menuItem;
    } else {
        [MBProgressHUD showHUDAddedTo:frontController.view animated:YES];
        NSURL *url = [NSURL URLWithString:schoolUrl];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        AFJSONRequestOperation *jsonRequest =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            [MBProgressHUD hideAllHUDsForView:frontController.view animated:YES];
                                                            PMSchoolsView *sv = [[PMSchoolsView alloc] initWithFrame:frame];
                                                            sv.schoolsList = [NSArray arrayWithArray:JSON];
                                                            sv.schoolSelected = ^(NSDictionary *school) {
                                                                UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                                                                PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//                                                                [menuVC setSchoolData:school];
                                                                [((UINavigationController *)self.contentViewController) pushViewController:menuVC animated:YES];
                                                            };
                                                            [frontController.view addSubview:sv];
                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            PMNSLog("failure");
                                                            [MBProgressHUD hideAllHUDsForView:frontController.view animated:YES];
                                                        }];
        
        [jsonRequest start];
    }
    
    
    // Gestione callback selezione elementi da menu sidebar
    __weak MainSideViewController *ms = self;
    __block UIViewController *bFrontController = frontController;
    ((SidebarController *)self.sidebarViewController).closeViewController = ^(NSInteger sectionId){
        [ms revealToggle:nil];
        switch (sectionId) {
            case 1:{
                if (ms.contentViewController.view.tag == 0) break;
                bFrontController.title = @"Home";
                ms.contentViewController.view.tag = 0;
                [ms removeSubviewsOfView:bFrontController.view];
                CGRect frame = [Utils getNavigableContentFrame];
                if ([ms.userMode isEqualToString:LOGGEDUSER]) {
                    PMHomeView *hv = [[PMHomeView alloc] initWithFrame:frame];
                    [bFrontController.view addSubview:hv];
                    bFrontController.title = @"Home";
                    hv.schoolSelected = ^(NSDictionary *school) {
                        UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                        PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//                        [menuVC setSchoolData:school];
                        [((UINavigationController *)ms.contentViewController) pushViewController:menuVC animated:YES];
                    };
                } else {
                    [MBProgressHUD showHUDAddedTo:bFrontController.view animated:YES];
                    NSURL *url = [NSURL URLWithString:schoolUrl];
                    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    AFJSONRequestOperation *jsonRequest =
                    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                        [MBProgressHUD hideAllHUDsForView:bFrontController.view animated:YES];
                                                                        PMSchoolsView *sv = [[PMSchoolsView alloc] initWithFrame:frame];
                                                                        sv.schoolsList = [NSArray arrayWithArray:JSON];
                                                                        sv.schoolSelected = ^(NSDictionary *school) {
                                                                            UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                                                                            PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
//                                                                            [menuVC setSchoolData:school];
                                                                            [((UINavigationController *)ms.contentViewController) pushViewController:menuVC animated:YES];
                                                                        };
                                                                        [bFrontController.view addSubview:sv];
                                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                        PMNSLog("failure");
                                                                        [MBProgressHUD hideAllHUDsForView:bFrontController.view animated:YES];
                                                                    }];
                    
                    [jsonRequest start];
                }
                break;
            }
            case 2:{
                if (ms.contentViewController.view.tag == 1) break;
                bFrontController.title = @"News";
                ms.contentViewController.view.tag = 1;
                [ms removeSubviewsOfView:bFrontController.view];
                CGRect frame = [Utils getNavigableContentFrame];
                [MBProgressHUD showHUDAddedTo:bFrontController.view animated:YES];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/node/news/stream/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
                NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                AFJSONRequestOperation *jsonRequest =
                [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                    [MBProgressHUD hideAllHUDsForView:bFrontController.view animated:YES];
                                                                    PMNewsView *nv = [[PMNewsView alloc] initWithFrame:frame];
                                                                    nv.newsList = [NSMutableArray arrayWithArray:JSON[@"posts"]];
                                                                    nv.newsSelected = ^(NSString *content){
                                                                        PMNewsDetailViewController *newsVC = [[PMNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
                                                                        [newsVC setWebContent:content];
                                                                        [((UINavigationController *)ms.contentViewController) pushViewController:newsVC animated:YES];
                                                                    };
                                                                    [bFrontController.view addSubview:nv];
                                                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                    PMNSLog("failure");
                                                                    [MBProgressHUD hideAllHUDsForView:bFrontController.view animated:YES];
                                                                }];
                [jsonRequest start];
                break;
            }
            case 0:
                if (ms.closeViewController)
                    ms.closeViewController();
                break;
        }
    };
}

- (void)viewDidUnload {
    [super viewDidUnload];
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

- (void)removeSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    // Rimozione UIView per news e scuole 
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[PMHomeView class]] || [subview isKindOfClass:[PMNewsView class]] || [subview isKindOfClass:[PMSchoolsView class]]) {
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        //[self listSubviewsOfView:subview];
    }
}

@end

