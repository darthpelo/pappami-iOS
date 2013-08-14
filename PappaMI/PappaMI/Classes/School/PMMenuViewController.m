//
//  PMMenuViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//

#import "PMMenuViewController.h"
#import "PMMenuCell.h"
#import "PMDishViewController.h"
#import "AFNetworking.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

/*
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
    button.frame = CGRectMake(0, 0, 38*0.4, 32*0.4);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
}
@end
*/

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
//    [self setNavigationBar];
    
    self.view.backgroundColor = UIColorFromRGB(0x00B2EE);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-dd-MM"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    self.schoolButton.backgroundColor = UIColorFromRGB(0x00688B);
    self.schoolButton.layer.cornerRadius = 3.0f;
    [self.schoolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.schoolButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.dateButton.backgroundColor = UIColorFromRGB(0x00688B);
    self.dateButton.layer.cornerRadius = 3.0f;
    [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dateButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];

    schoolData = [NSDictionary dictionary];
    [self loadDataAtIndex:0];
    
    self.title = [schoolData objectForKey:@"name"];
}

- (void)loadDataAtIndex:(int)index
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
        NSArray *tmp = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
        schoolData = [tmp objectAtIndex:index];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *api = [NSString stringWithFormat:@"http://%@/api/menu/%@/%@",
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"],
                     [schoolData objectForKey:@"id"],
                     dateString];
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.items = [NSArray arrayWithArray:JSON];
        if (self.items.count == 0) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Avviso"
                                                              message:@"I menù sono disponibili solo per i giorni feriali."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PMNSLog("failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [jsonRequest start];
}

/*
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.schoolData = nil;
}
*/

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

- (IBAction)schoolButtonPressed:(id)sender
{
    NSMutableArray *personalSchoolsList = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
        NSArray *tmp = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
        for (NSDictionary *dict in tmp) {
            [personalSchoolsList addObject:[dict objectForKey:@"name"]];
        }
    } else {
        NSArray *tmp = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:GUESTUSER] objectForKey:@"schools"]];
        for (NSDictionary *dict in tmp) {
            [personalSchoolsList addObject:[dict objectForKey:@"name"]];
        }
    }
    schoolPicker = [[YHCPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) withNSArray:personalSchoolsList];
    
    schoolPicker.delegate = self;
    [self.view addSubview:schoolPicker];
    [schoolPicker showPicker];
}

-(void)selectedRow:(int)row withString:(NSString *)text{
    [self loadDataAtIndex:row];
    self.title = text;
    schoolPicker = nil;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PMMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    NSDictionary* item = self.items[indexPath.row];
    
    cell.titleLabel.text = item[@"desc1"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/dish/%@/%@",
                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"],
                                       self.items[indexPath.row][@"id"],
                                       [schoolData objectForKey:@"id"]]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
        PMDishViewController *dishVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"DishViewController"];
        dishVC.dishData = JSON;
        dishVC.dishId = self.items[indexPath.row][@"id"];
        [self.navigationController pushViewController:dishVC animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PMNSLog("failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [jsonRequest start];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Date Picker Delegate

-(void)datePickerSetDate:(TDDatePickerController*)viewController {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self dismissSemiModalViewController:datePicker];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd"];
    NSString *api = [NSString stringWithFormat:@"http://%@/api/menu/%@/%@",
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"],
                     [schoolData objectForKey:@"id"],
                     [dateFormat stringFromDate:viewController.datePicker.date]];
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.items = [NSArray arrayWithArray:JSON];
        if (self.items.count == 0) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Avviso"
                                                              message:@"I menù sono disponibili solo per i giorni feriali."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PMNSLog("failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [jsonRequest start];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:datePicker];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController {
	[self dismissSemiModalViewController:datePicker];
}

@end
