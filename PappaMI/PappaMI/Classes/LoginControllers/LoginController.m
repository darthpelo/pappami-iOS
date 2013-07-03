//
//  LoginController.m
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "LoginController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginController ()

@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
//    UIColor* darkColor = [UIColor colorWithRed:7.0/255 green:61.0/255 blue:48.0/255 alpha:1.0f];

    UIColor *mainColor = UIColorFromRGB(0x00B2EE);
    UIColor *darkColor = UIColorFromRGB(0x00688B);
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.layer.cornerRadius = 3.0f;
    self.usernameField.placeholder = @"Indirizzo E-Mail";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;

    
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.delegate = self;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"Accedi" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.singUpButton.backgroundColor = darkColor;
    self.singUpButton.layer.cornerRadius = 3.0f;
    self.singUpButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.singUpButton setTitle:@"Registrati" forState:UIControlStateNormal];
    [self.singUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.singUpButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Vuoi provare l'applicazione senza registrarti?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor yellowColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"Pappa-Mi";
    
    self.subTitleLabel.textColor =  [UIColor yellowColor];
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Bentornato, esegui il login o registrati";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self exec:@"POST" block:^(BOOL responsedata){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)exec:(NSString *)method block:(void(^)(BOOL responsedData))block
{
    NSURL *url = [NSURL URLWithString:@"http://test.pappa-mi.it/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"test001@pappa-mi.it", @"email",
                            @"password01", @"password",
                            nil];
    [httpClient postPath:@"/auth/password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL *url = [NSURL URLWithString:@"http://test.pappa-mi.it/api/user/current"];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        AFJSONRequestOperation *jsonRequest =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            [[NSUserDefaults standardUserDefaults] setObject:JSON forKey:CURRENTUSER];
                                                            
                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                                                            self.mainSideViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainSideViewController"];
                                                            self.mainSideViewController.controllerId = @"SidebarController";
                                                            UIViewController *vc = self.mainSideViewController;
                                                            __weak LoginController *lc = self;
                                                            self.mainSideViewController.closeViewController = ^{
                                                                CATransition *transition = [CATransition animation];
                                                                transition.duration = 0.75;
                                                                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                transition.type = kCATransitionPush;
                                                                transition.subtype =kCATransitionFromLeft;
                                                                transition.delegate = lc;
                                                                [lc.view.layer addAnimation:transition forKey:nil];
                                                                [vc.view removeFromSuperview];
                                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTUSER];
                                                            };
                                                            
                                                            vc.view.frame = CGRectMake(0, 0, vc.view.frame.size.width, vc.view.frame.size.height);
                                                            CGFloat yOffset = [vc isKindOfClass:[UINavigationController class]] ? -20 : 0;
                                                            vc.view.frame = CGRectMake(320, yOffset, vc.view.frame.size.width, vc.view.frame.size.height);
                                                            [self.view addSubview:vc.view];
                                                            
                                                            [UIView animateWithDuration:1.0
                                                                                  delay:0.0
                                                                                options:UIViewAnimationOptionCurveEaseInOut
                                                                             animations:^{
                                                                                 vc.view.frame = CGRectMake(0, yOffset, vc.view.frame.size.width, vc.view.frame.size.height);
                                                                             }
                                                                             completion:^(BOOL finished) {
                                                                                 block(finished);
                                                                             }];
                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            NSLog(@"Error: %@", error);
                                                        }];
        [jsonRequest start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

@end
