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
#import "PMCredits.h"
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
    self.sidebarViewController = rearVC;
    
    // Inizializzazione Home
    frontController.title = @"Home";
    UIStoryboard* sidebar = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
    PMMenuViewController *menuVC = [sidebar instantiateViewControllerWithIdentifier:@"MenuViewController"];
    nav = nil;
    nav = [[UINavigationController alloc] initWithRootViewController:menuVC];
    self.contentViewController = nav;
    menuVC.navigationItem.leftBarButtonItem = menuItem;
    
    
    // Gestione callback selezione elementi da menu sidebar
    __weak MainSideViewController *ms = self;
    __block UIViewController *bFrontController = frontController;
    __block UINavigationController *bNav = nav;
    ((SidebarController *)self.sidebarViewController).closeViewController = ^(NSInteger sectionId){
        [ms revealToggle:nil];
        switch (sectionId) {
            case 1:{
                [ms removeSubviewsOfView:bFrontController.view];
                
                UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                bNav =  nil;
                bNav = [[UINavigationController alloc] initWithRootViewController:menuVC];
                ms.contentViewController = bNav;
                menuVC.navigationItem.leftBarButtonItem = menuItem;
                
                break;
            }
            case 2:{
                bNav =  nil;
                bNav = [[UINavigationController alloc] initWithRootViewController:bFrontController];
                ms.contentViewController = bNav;
                bFrontController.title = @"News";
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
            case 3:{
                bNav =  nil;
                bNav = [[UINavigationController alloc] initWithRootViewController:bFrontController];
                ms.contentViewController = bNav;
                bFrontController.title = @"Credits";
                [ms removeSubviewsOfView:bFrontController.view];
                CGRect frame = [Utils getNavigableContentFrame];
                PMCredits *cv = [[PMCredits alloc] initWithFrame:frame];
                [bFrontController.view addSubview:cv];
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
        if ([subview isKindOfClass:[PMHomeView class]] || [subview isKindOfClass:[PMNewsView class]] || [subview isKindOfClass:[PMCredits class]]) {
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        //[self listSubviewsOfView:subview];
    }
}

@end

