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

@interface LoginController () {
    BOOL veespoTest;
}

@end

static NSString *pappamiconfing = @"http://api.pappa-mi.it/api/config";
static int delta = 70;

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
    
    BOOL iP5 = ([UIScreen mainScreen].bounds.size.height == 568.0f) ? YES : NO;
    
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.layer.cornerRadius = 3.0f;
    self.usernameField.placeholder = @"Indirizzo E-Mail";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    
    if (iP5) [self.usernameField setFrame:CGRectMake(self.usernameField.frame.origin.x,
                                                   self.usernameField.frame.origin.y + delta,
                                                   self.usernameField.frame.size.width,
                                                   self.usernameField.frame.size.height)];

    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.delegate = self;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    if (iP5) [self.passwordField setFrame:CGRectMake(self.passwordField.frame.origin.x,
                                                     self.passwordField.frame.origin.y + delta,
                                                     self.passwordField.frame.size.width,
                                                     self.passwordField.frame.size.height)];
    
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"Accedi" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    if (iP5) [self.loginButton setFrame:CGRectMake(self.loginButton.frame.origin.x,
                                                   self.loginButton.frame.origin.y + delta,
                                                   self.loginButton.frame.size.width,
                                                   self.loginButton.frame.size.height)];
    
    self.singUpButton.backgroundColor = darkColor;
    self.singUpButton.layer.cornerRadius = 3.0f;
    self.singUpButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.singUpButton setTitle:@"Registrati" forState:UIControlStateNormal];
    [self.singUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.singUpButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    if (iP5) [self.singUpButton setFrame:CGRectMake(self.singUpButton.frame.origin.x,
                                                   self.singUpButton.frame.origin.y + delta,
                                                   self.singUpButton.frame.size.width,
                                                   self.singUpButton.frame.size.height)];
    
    self.anonymousButton.backgroundColor = [UIColor clearColor];
    self.anonymousButton.titleLabel.font = [UIFont fontWithName:fontName size:14.0f];
    [self.anonymousButton setTitle:@"Vuoi provare l'applicazione senza registrarti?" forState:UIControlStateNormal];
    [self.anonymousButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.anonymousButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    if (iP5) [self.anonymousButton setFrame:CGRectMake(self.anonymousButton.frame.origin.x,
                                                   self.anonymousButton.frame.origin.y + delta,
                                                   self.anonymousButton.frame.size.width,
                                                   self.anonymousButton.frame.size.height)];
    
    self.titleLabel.textColor =  [UIColor yellowColor];
    self.titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    self.titleLabel.text = @"Pappa-Mi";
    
    self.subTitleLabel.textColor =  [UIColor yellowColor];
    self.subTitleLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.subTitleLabel.text = @"Bentornato, esegui il login o registrati";
    
    if (iP5) [self.subTitleLabel setFrame:CGRectMake(self.subTitleLabel.frame.origin.x,
                                                       self.subTitleLabel.frame.origin.y + 20,
                                                       self.subTitleLabel.frame.size.width,
                                                       self.subTitleLabel.frame.size.height)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:pappamiconfing];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *host = [NSDictionary dictionaryWithDictionary:JSON];
        [[NSUserDefaults standardUserDefaults] setObject:host[@"apihost"] forKey:@"apihost"];
        if ([host[@"veespoproduction"] isEqualToString:@"NO"])
            veespoTest = YES;
        else if ([host[@"veespoproduction"] isEqualToString:@"YES"])
            veespoTest = NO;
//        [[NSUserDefaults standardUserDefaults] setObject:@"test-m.pappa-mi.it" forKey:@"apihost"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender
{
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self exec:@"POST" block:^(BOOL responsedata){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.usernameField.text = @"";
            self.usernameField.placeholder = @"Indirizzo E-Mail";
            self.passwordField.text = @"";
            self.passwordField.placeholder = @"Password";
            // unregister for keyboard notifications while not visible.
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillShowNotification
                                                          object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIKeyboardWillHideNotification
                                                          object:nil];
            if (!responsedata) {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                                  message:@"E' stato riscontrato un errore di comunicazione."
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        }];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Attenzione!"
                                                          message:@"Devi inserire indirizzo mail e password!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        self.usernameField.text = @"";
        self.usernameField.placeholder = @"Indirizzo E-Mail";
        self.passwordField.text = @"";
        self.passwordField.placeholder = @"Password";
    }
}

-(void)exec:(NSString *)method block:(void(^)(BOOL responsedData))block
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"darthpelo@gmail.com", @"email",
//                            @"password", @"password",
//                            nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.usernameField.text, @"email",
                            self.passwordField.text, @"password",
                            nil];
    [httpClient postPath:@"/auth/password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL *url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://%@/api/user/current", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        AFJSONRequestOperation *jsonRequest =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            // Workaround per problemi con il sistema di login lato server
                                                            if ([JSON[@"type"] isEqualToString:@"O"])
                                                                [[NSUserDefaults standardUserDefaults] setObject:JSON forKey:GUESTUSER];
                                                            else
                                                                [[NSUserDefaults standardUserDefaults] setObject:JSON forKey:LOGGEDUSER];
                                                            
                                                            [Veespo initUser:[NSString stringWithFormat:@"pappa-mi-user-%@",JSON[@"id"]]
                                                                      apiKey:@""
                                                                    userName:nil
                                                                    language:@"it"
                                                                 veespoGroup:nil
                                                                  fileConfig:nil
                                                                   urlConfig:nil
                                                                  andTestUrl:veespoTest];
                                                            
                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                                                            self.mainSideViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainSideViewController"];
                                                            self.mainSideViewController.controllerId = @"SidebarController";
                                                            if ([JSON[@"type"] isEqualToString:@"O"])
                                                                self.mainSideViewController.userMode = GUESTUSER;
                                                            else
                                                                self.mainSideViewController.userMode = LOGGEDUSER;
                                                            UIViewController *vc = self.mainSideViewController;
                                                            __weak LoginController *lc = self;
                                                            
                                                            // Logout function
                                                            self.mainSideViewController.closeViewController = ^{
                                                                NSHTTPCookie *cookie;
                                                                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                                                for (cookie in [storage cookies])
                                                                    [storage deleteCookie:cookie];
                                                                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                                
                                                                lc.usernameField.text = @"";
                                                                lc.usernameField.placeholder = @"Indirizzo E-Mail";
                                                                lc.passwordField.text = @"";
                                                                lc.passwordField.placeholder = @"Password";
                                                                
                                                                CATransition *transition = [CATransition animation];
                                                                transition.duration = 0.75;
                                                                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                transition.type = kCATransitionPush;
                                                                transition.subtype =kCATransitionFromLeft;
                                                                transition.delegate = lc;
                                                                [lc.view.layer addAnimation:transition forKey:nil];
                                                                [vc.view removeFromSuperview];
                                                                
                                                                // Remove data information on NSUserDefaults
                                                                if (![JSON[@"type"] isEqualToString:@"O"])
                                                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGGEDUSER];
                                                                else
                                                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GUESTUSER];
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
                                                            block(NO);
                                                        }];
        [jsonRequest start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        block(NO);
    }];
}

- (IBAction)anonymousPressed:(id)sender
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
        [storage deleteCookie:cookie];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGGEDUSER];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://%@/api/user/current", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        [[NSUserDefaults standardUserDefaults] setObject:JSON forKey:GUESTUSER];
                                                        
                                                        [Veespo initUser:[NSString stringWithFormat:@"pappa-mi-user-%@",JSON[@"id"]]
                                                                  apiKey:@""
                                                                userName:nil
                                                                language:@"it"
                                                             veespoGroup:nil
                                                              fileConfig:nil
                                                               urlConfig:nil
                                                              andTestUrl:veespoTest];
                                                        
                                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
                                                        self.mainSideViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainSideViewController"];
                                                        self.mainSideViewController.controllerId = @"SidebarController";
                                                        self.mainSideViewController.userMode = GUESTUSER;
                                                        UIViewController *vc = self.mainSideViewController;
                                                        __weak LoginController *lc = self;
                                                        
                                                        // Logout function
                                                        self.mainSideViewController.closeViewController = ^{
                                                            NSHTTPCookie *cookie;
                                                            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                                            for (cookie in [storage cookies])
                                                                [storage deleteCookie:cookie];
                                                            [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                                            lc.usernameField.text = @"";
                                                            lc.usernameField.placeholder = @"Indirizzo E-Mail";
                                                            lc.passwordField.text = @"";
                                                            lc.passwordField.placeholder = @"Password";
                                                            CATransition *transition = [CATransition animation];
                                                            transition.duration = 0.75;
                                                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                            transition.type = kCATransitionPush;
                                                            transition.subtype =kCATransitionFromLeft;
                                                            transition.delegate = lc;
                                                            [lc.view.layer addAnimation:transition forKey:nil];
                                                            [vc.view removeFromSuperview];
                                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GUESTUSER];
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
                                                                             // unregister for keyboard notifications while not visible.
                                                                             [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                                             name:UIKeyboardWillShowNotification
                                                                                                                           object:nil];
                                                                             
                                                                             [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                                             name:UIKeyboardWillHideNotification
                                                                                                                           object:nil];
                                                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                                         }];
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        PMNSLog("%@", error.debugDescription);
                                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                    }];
    [jsonRequest start];
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
