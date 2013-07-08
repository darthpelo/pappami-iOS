//
//  PMMenuViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMMenuViewController.h"
#import "PMMenuCell.h"
#import "PMDishViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PMMenuViewController ()

@property (nonatomic, strong) NSArray* items;

@end

@implementation PMMenuViewController

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
    self.view.backgroundColor = UIColorFromRGB(0x00B2EE);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    self.label.text = [NSString stringWithFormat:@"Menù del %@", dateString];
    self.dateButton.backgroundColor = UIColorFromRGB(0x00688B);
    self.dateButton.layer.cornerRadius = 3.0f;
    self.dateButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:18.0f];
//    [self.dateButton setTitle:@"Seleziona la data" forState:UIControlStateNormal];
    [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dateButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    NSDictionary *object0 = [NSDictionary dictionaryWithObjects:@[ @"Pasta integrale biologica al pomodoro", @"aaaa" ] forKeys:@[ @"title", @"targetId"]];
    NSDictionary *object1 = [NSDictionary dictionaryWithObjects:@[ @"Frittata con zucchine", @"bbbb" ] forKeys:@[ @"title", @"targetId"]];
    NSDictionary *object2 = [NSDictionary dictionaryWithObjects:@[ @"Insalata di stagione", @"bbbb" ] forKeys:@[ @"title", @"targetId"]];
    NSDictionary *object3 = [NSDictionary dictionaryWithObjects:@[ @"Frutta fresca di stagione", @"aaaa" ] forKeys:@[ @"title", @"targetId"]];
    
    self.items = @[object0, object1, object2, object3];
    
    UIButton* menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"button-close.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = menuItem;
    self.title = [self.schoolData objectForKey:@"name"];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PMMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    NSDictionary* item = self.items[indexPath.row];
    
    cell.titleLabel.text = item[@"title"];
    
    cell.feedbackSelected = ^(NSString *targetId){
        VEVeespoViewController *veespo = [[VEVeespoViewController alloc] init];
        veespo.closeVeespoViewController = ^(NSDictionary *data){
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:veespo animated:YES completion:nil];
        [veespo loadDataFor:targetId
                      title:item[@"title"]
                detailsView:nil];
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
    PMDishViewController *dishVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"DishViewController"];
    [self.navigationController pushViewController:dishVC animated:YES];
}

- (void)closeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateButtonPressed:(id)sender
{
    if (datePicker == nil) {
        datePicker = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
        datePicker.delegate = self;
    }
    [self presentSemiModalViewController:datePicker];
}

//- (void)changeMenuDate
//{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat: @"dd-MM-yyyy"];
//    NSString *dateString = [dateFormat stringFromDate:datePicker.date];
//    self.label.text = [NSString stringWithFormat:@"%@", dateString];
//}

#pragma mark Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:datePicker];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"dd-MM-yyyy"];
    self.label.text = [NSString stringWithFormat:@"Menù del %@",[dateFormat stringFromDate:viewController.datePicker.date]];
    PMNSLog("%@", viewController.datePicker.date);
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:datePicker];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:datePicker];
}

@end
