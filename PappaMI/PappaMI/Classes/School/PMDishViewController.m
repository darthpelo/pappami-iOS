//
//  PMDishViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 05/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMDishViewController.h"

@implementation UIViewController (CustomFeatures)
-(void)setNavigationBar{
    // Set the custom back button
    UIImage *buttonImage = [UIImage imageNamed:@"arrow-back.png"];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"selback.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 38*0.6, 32*0.6);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
}
@end

@interface PMDishViewController ()

@end

@implementation PMDishViewController

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
	[self setNavigationBar];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
