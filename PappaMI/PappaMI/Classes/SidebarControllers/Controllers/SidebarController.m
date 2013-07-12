//
//  SidebarController.m
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SidebarController.h"
#import "SidebarCell.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface SidebarController ()

@property (nonatomic, strong) NSArray* items;

@end

@implementation SidebarController
@synthesize closeViewController;

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIColor* mainColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f];
    
    self.view.backgroundColor = darkColor;
    self.tableView.backgroundColor = darkColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    NSString* fontName = @"Avenir-Black";
    NSString* boldFontName = @"Avenir-BlackOblique";
    
    self.profileNameLabel.textColor = [UIColor whiteColor];
    self.profileNameLabel.font = [UIFont fontWithName:fontName size:14.0f];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        self.profileNameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"fullname"];
    else
        self.profileNameLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:GUESTUSER] objectForKey:@"fullname"];
    self.profileLocationLabel.textColor = mainColor;
    self.profileLocationLabel.font = [UIFont fontWithName:boldFontName size:12.0f];
    self.profileLocationLabel.text = @"Milano, IT";
    
    // Avatar
    NSURL *url = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER][@"avatar"]
             rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location == NSNotFound)
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"], [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER][@"avatar"]]]];
        else
            url = [NSURL URLWithString:[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER][@"avatar"]]];
    } else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"], [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:GUESTUSER][@"avatar"]]]];
    [self.profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"profile.jpg"]];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
        NSDictionary* object0 = [NSDictionary dictionaryWithObjects:@[ @"Home", @"1", @"account" ] forKeys:@[ @"title", @"id", @"icon" ]];
        NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"News", @"2", @"envelope" ] forKeys:@[ @"title", @"id", @"icon" ]];
//        NSDictionary* object2 = [NSDictionary dictionaryWithObjects:@[ @"News Personalizzate", @"3", @"envelope" ] forKeys:@[ @"title", @"id", @"icon" ]];
        NSDictionary *object3 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"id", @"icon" ]];
        self.items = @[object0, object1, object3];
    } else {
        NSDictionary* object0 = [NSDictionary dictionaryWithObjects:@[ @"Home", @"1", @"account" ] forKeys:@[ @"title", @"id", @"icon" ]];
        NSDictionary* object1 = [NSDictionary dictionaryWithObjects:@[ @"News", @"2", @"envelope" ] forKeys:@[ @"title", @"id", @"icon" ]];
        NSDictionary *object2 = [NSDictionary dictionaryWithObjects:@[ @"Logout", @"0", @"arrow" ] forKeys:@[ @"title", @"id", @"icon" ]];
        self.items = @[object0, object1, object2];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SidebarCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell"];
    
    NSDictionary* item = self.items[indexPath.row];
    
    cell.titleLabel.text = item[@"title"];
    cell.iconImageView.image = [UIImage imageNamed:item[@"icon"]];
    
    NSString* count = item[@"count"];
    if(![count isEqualToString:@"0"]){
        cell.countLabel.text = count;
    }
    else{
        cell.countLabel.alpha = 0;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.closeViewController) {
        NSDictionary* item = self.items[indexPath.row];
        self.closeViewController([item[@"id"] integerValue]);
    }
}

@end
