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

@interface MainSideViewController ()

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
    
    UIViewController* frontController = [[UIViewController alloc] init];
    frontController.view.backgroundColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:frontController];

    [FlatTheme styleNavigationBarWithFontName:@"Avenir" andColor:[UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f]];
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 20)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];

    frontController.navigationItem.leftBarButtonItem = menuItem;
    frontController.title = @"Home";

    self.contentViewController = nav;
    self.contentViewController.view.tag = 0;
    self.sidebarViewController = rearVC;

    __weak MainSideViewController *ms = self;
    ((SidebarController *)self.sidebarViewController).closeViewController = ^(NSIndexPath *indexPath){
        [ms revealToggle:nil];
        if (indexPath.row == 2) {
            if (ms.closeViewController)
                ms.closeViewController();
        } else {
            switch (indexPath.row) {
                case 0:{
                    frontController.title = @"Home";
                    ms.contentViewController.view.tag = 0;
                    [ms listSubviewsOfView:ms.contentViewController.view];
                    CGRect frame = [Utils getNavigableContentFrame];
                    frame.origin.y = 22.5;
                    PMHomeView *hv = [[PMHomeView alloc] initWithFrame:frame];
                    [ms.contentViewController.view addSubview:hv];
                    break;
                }
                case 1:{
                    frontController.title = @"Elenco scuole";
                    ms.contentViewController.view.tag = 1;
                    [ms listSubviewsOfView:ms.contentViewController.view];
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 80)];
                    lbl.numberOfLines = 4;
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    lbl.textColor = [UIColor whiteColor];
                    lbl.font = [UIFont fontWithName:@"Avenir" size:16];
                    lbl.text = @"Pagina in cui gli utenti possono guardare la lista delle scuole (senza votare)";
                    [ms.contentViewController.view addSubview:lbl];
                    break;
                }
                default:
                    break;
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
        frame.origin.y = 22.5;
        PMHomeView *hv = [[PMHomeView alloc] initWithFrame:frame];
        [self.contentViewController.view addSubview:hv];
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
        
        NSLog(@"%@", subview);
        if ([subview isKindOfClass:[PMHomeView class]] || [subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        //[self listSubviewsOfView:subview];
    }
}

@end

