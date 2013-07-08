//
//  LoginController.h
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"
#import "MainSideViewController.h"

@interface LoginController : BaseLoginController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * usernameField;

@property (nonatomic, weak) IBOutlet UITextField * passwordField;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton *singUpButton;

@property (nonatomic, weak) IBOutlet UIButton *anonymousButton;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;

@property (nonatomic, weak) IBOutlet UILabel * subTitleLabel;

@property (nonatomic, strong) MainSideViewController *mainSideViewController;

- (IBAction)loginPressed:(id)sender;

- (IBAction)anonymousPressed:(id)sender;

- (IBAction)singUpPressed:(id)sender;

@end
