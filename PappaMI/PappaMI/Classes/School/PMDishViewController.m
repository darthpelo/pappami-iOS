//
//  PMDishViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 05/07/13.
//

#import "PMDishViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "PMStatsViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

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
    
    NSString* boldFontName = @"Avenir-Black";
    UIColor *mainColor = UIColorFromRGB(0x00B2EE);
    UIColor *darkColor = UIColorFromRGB(0x00688B);
    
	[self setNavigationBar];
    self.title = self.dishData[@"dish"];
    self.view.backgroundColor = mainColor;
    
    CGRect frame = [Utils getNavigableContentFrame];
    [self.compTableView setFrame:CGRectMake(self.compTableView.frame.origin.x, self.compTableView.frame.origin.y, 320, frame.size.height - self.compTableView.frame.origin.y - 44)];
    self.compTableView.delegate = self;
    self.compTableView.dataSource = self;
    
    self.statButton.backgroundColor = darkColor;
    self.statButton.layer.cornerRadius = 3.0f;
    self.statButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.statButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.statButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.statButton setFrame:CGRectMake(self.statButton.frame.origin.x,
                                         (self.compTableView.frame.origin.y + self.compTableView.frame.size.height) - 10,
                                         self.statButton.frame.size.width,
                                         self.statButton.frame.size.height)];
    
    self.veespoButton.layer.cornerRadius = 3.0f;
    [self.veespoButton setFrame:CGRectMake(self.veespoButton.frame.origin.x,
                                         (self.compTableView.frame.origin.y + self.compTableView.frame.size.height) - 10,
                                         self.veespoButton.frame.size.width,
                                         self.veespoButton.frame.size.height)];
    
    // Guest user can't give feedback on dishes
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
//        self.veespoButton.enabled = YES;
//    else
//        self.veespoButton.enabled = NO;
    
    int components = ((NSArray*)[self.dishData objectForKey:@"components"]).count;
    if (components == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Avviso"
                                                          message:@"Non sono disponibili gli ingredienti di questo piatto."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    self.dishData = nil;
    self.dishId = nil;
}

- (IBAction)veespoPressed:(id)sender
{
    VEVeespoViewController *veespo = [[VEVeespoViewController alloc] init];
    veespo.closeVeespoViewController = ^(NSDictionary *data){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:veespo animated:YES completion:^{
        if (![[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Avviso"
                                                              message:@"In modalità Ospite, i voti non vengono raccolti a fini statistici, ma solo per mostrare la funzionalità di voto."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }];
    [veespo loadDataFor:[NSString stringWithFormat:@"tgt-pappa-mi-dish-%@", self.dishId]
                  title:self.dishData[@"dish"]
            detailsView:nil];
}

- (IBAction)statPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://legacy1.veespo.com/v1/average/target/tgt-pappa-mi-dish-%@", self.dishId]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *tags = [NSDictionary dictionaryWithDictionary:JSON[@"data"][@"avgS"]];
        
        NSURL *url = [NSURL URLWithString:@"http://legacy1.veespo.com/v1/tag-labels/category/ctg-f86fbf9e-b53b-e7a5-d75d-57139ea6541d?lang=it"];
        request = [NSMutableURLRequest requestWithURL:url];
        AFJSONRequestOperation *jsonRequest =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            NSDictionary *labels = [NSDictionary dictionaryWithDictionary:JSON[@"data"]];
                                                            NSMutableArray *list = [[NSMutableArray alloc] init];
                                                            for (id key in [tags allKeys]) {
                                                                NSString *label = labels[key];
                                                                NSString *avg = tags[key];
                                                                // Ignoro tag senza media
                                                                if (label && avg) {
                                                                    NSDictionary* object = [NSDictionary dictionaryWithObjects:@[ label, avg ] forKeys:@[ @"name", @"avg" ]];
                                                                    [list addObject:object];
                                                                }
                                                            }
                                                            NSArray *sortedList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                NSNumber *num1 = [NSNumber numberWithFloat:[obj1[@"avg"] floatValue]];
                                                                NSNumber *num2 = [NSNumber numberWithFloat:[obj2[@"avg"] floatValue]];
                                                                return (NSComparisonResult)[num1 compare:num2];
                                                            }];
                                                            PMStatsViewController *stat = [[PMStatsViewController alloc] initWithNibName:nil bundle:nil];
                                                            [stat setList:[[sortedList reverseObjectEnumerator] allObjects]];
                                                            [self.navigationController pushViewController:stat animated:YES];
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            PMNSLog("failure");
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        }];
        [jsonRequest start];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        PMNSLog("failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [jsonRequest start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)[self.dishData objectForKey:@"components"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    [cell setUserInteractionEnabled:NO];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    NSDictionary *item = [self.dishData[@"components"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02fgr", [item[@"qty"] floatValue]];
    cell.textLabel.font = [UIFont fontWithName:boldFontName size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:12];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
