//
//  PMDishViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 05/07/13.
//

#import "PMDishViewController.h"
#import "Utils.h"
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
    
    self.veespoButton.backgroundColor = darkColor;
    self.veespoButton.layer.cornerRadius = 3.0f;
    self.veespoButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.veespoButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.veespoButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.veespoButton setFrame:CGRectMake(self.veespoButton.frame.origin.x,
                                         (self.compTableView.frame.origin.y + self.compTableView.frame.size.height) - 10,
                                         self.veespoButton.frame.size.width,
                                         self.veespoButton.frame.size.height)];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.dishData = nil;
    self.dishId = nil;
}

- (IBAction)veespoPressed:(id)sender
{
    VEVeespoViewController *veespo = [[VEVeespoViewController alloc] init];
    veespo.closeVeespoViewController = ^(NSDictionary *data){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:veespo animated:YES completion:nil];
    [veespo loadDataFor:@"tgt-dfc11f51-162d-14a7-9bb5-2995f87f41a7"
                  title:self.dishData[@"dish"]
            detailsView:nil];
}

- (IBAction)statPressed:(id)sender
{
    
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
