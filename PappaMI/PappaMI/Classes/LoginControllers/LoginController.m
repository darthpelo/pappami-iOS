//
//  LoginController.m
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "LoginController.h"
#import "MBProgressHUD.h"
#import "PMConnection.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginController () {
    PMConnection *connection;
    BOOL veespoTest;
}
@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        veespoTest = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *mainColor = UIColorFromRGB(0x00B2EE);
    UIColor *darkColor = UIColorFromRGB(0x00688B);
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
//    BOOL iP5 = ([UIScreen mainScreen].bounds.size.height == 568.0f) ? YES : NO;
    
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
    
    self.anonymousButton.backgroundColor = [UIColor clearColor];
    self.anonymousButton.titleLabel.font = [UIFont fontWithName:fontName size:14.0f];
    [self.anonymousButton setTitle:@"Vuoi provare l'applicazione senza registrarti?" forState:UIControlStateNormal];
    [self.anonymousButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.anonymousButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel.textColor =  [UIColor yellowColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"Pappa-Mi";
    
    self.subTitleLabel.textColor =  [UIColor yellowColor];
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Bentornato, esegui il login o registrati";
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    connection = [[PMConnection alloc] init];
    [connection getAPIhost:^(BOOL veespoHost) {
        veespoTest = veespoHost;
        if (veespoHost == YES) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
#warning Veespo init
            [self showSideBarController:LOGGEDUSER];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deobservKeyboardNotifications
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)resetTextFields
{
    self.usernameField.text = @"";
    self.usernameField.placeholder = @"Indirizzo E-Mail";
    self.passwordField.text = @"";
    self.passwordField.placeholder = @"Password";
}

- (void)ereaseCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
        [storage deleteCookie:cookie];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)showSideBarController:(NSString *)userType
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
    self.mainSideViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainSideViewController"];
    self.mainSideViewController.controllerId = @"SidebarController";
    
    self.mainSideViewController.userMode = userType;
    UIViewController *vc = self.mainSideViewController;
    __weak LoginController *lc = self;
    
    // Logout function
    self.mainSideViewController.closeViewController = ^{
        
        [lc ereaseCookie];
        
        [lc resetTextFields];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.75;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = lc;
        [lc.view.layer addAnimation:transition forKey:nil];
        [vc.view removeFromSuperview];
        
        // Remove data information on NSUserDefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userType];
    };
    
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
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }
     ];
}

#pragma mark - Login

- (IBAction)loginPressed:(id)sender
{
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [connection loginUser:[NSDictionary dictionaryWithObjectsAndKeys:self.usernameField.text, @"email", self.passwordField.text, @"password", nil] success:^(id responseData) {
            
            [self resetTextFields];
            
            [self deobservKeyboardNotifications];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseData forKey:LOGGEDUSER];
            
#warning Add Veespo init
            
            // Pappa-MI api respond with Guest user data if you insert wrong information
            if (![responseData[@"type"] isEqualToString:@"O"]) {
                [self showSideBarController:LOGGEDUSER];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                                  message:@"I dati inseriti non sono corretti."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        } failure:^(id responseData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                              message:@"E' stato riscontrato un errore con il server."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                          message:@"Devi inserire indirizzo mail e password!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        [self resetTextFields];
    }
}


- (IBAction)anonymousPressed:(id)sender
{
    [self ereaseCookie];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGGEDUSER];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [connection getGuestData:^(id responseData) {
        
        [self deobservKeyboardNotifications];
        
        [[NSUserDefaults standardUserDefaults] setObject:responseData forKey:GUESTUSER];
        
#warning Add Veespo init
        
        [self showSideBarController:GUESTUSER];
        
    } failure:^(id responseData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                          message:@"E' stato riscontrato un errore con il server."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }];
}

- (IBAction)singUpPressed:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                      message:@"Al momento la registrazione si può eseguire solo tramite il nostro sito www.pappa-mi.it.\nRegistrati utilizzando la tua mail e la tua password e non i sistemi alternativi (FaceBook, Twitter etc.) non ancora disponibili.\nConclusa la registrazione apri nuovamente l'app ed inserisci i tuoi dati per cominciare ad utilizzare Pappa-MI!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

@end
