//
//  PMHomeViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 13/07/13.
//

#import "PMHomeViewController.h"
#import "PMMenuViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface PMHomeViewController ()

@end

static NSString *schoolUrl = @"http://api.pappa-mi.it/api/school/1364003/list";

@implementation PMHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    
    self.title = @"Home";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Differente logica di visualizzazione tra utente loggato ed utente ospite
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER]) {
        UILabel *titolo = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 280, 21)];
        titolo.font = [UIFont fontWithName:@"Avenir-Black" size:20];
        [titolo setBackgroundColor:[UIColor clearColor]];
        titolo.textAlignment = NSTextAlignmentCenter;
        titolo.text = @"Le scuole dei tuoi figli";
        [self.view addSubview:titolo];
        CGRect tFrame = CGRectMake(0, titolo.frame.origin.y + titolo.frame.size.height + 10, 320, 100);
        homeTableView = [[UITableView alloc] initWithFrame:tFrame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [homeTableView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:homeTableView];
    } else {
        UILabel *titolo = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 21)];
        titolo.font = [UIFont fontWithName:@"Avenir-Black" size:20];
        [titolo setBackgroundColor:[UIColor clearColor]];
        titolo.textAlignment = NSTextAlignmentCenter;
        titolo.text = @"Seleziona una scuola di Milano";
        [self.view addSubview:titolo];
        CGRect tFrame = CGRectMake(0, titolo.frame.origin.y + titolo.frame.size.height + 10, 320, self.view.frame.size.height - (titolo.frame.origin.y + titolo.frame.size.height) + 3);
        homeTableView = [[UITableView alloc] initWithFrame:tFrame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [homeTableView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:homeTableView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        schoolsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSURL *url = [NSURL URLWithString:schoolUrl];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        AFJSONRequestOperation *jsonRequest =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            schoolsList = [NSArray arrayWithArray:JSON];
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                            [homeTableView reloadData];
                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            PMNSLog("failure");
                                                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                        }];
        
        [jsonRequest start];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return schoolsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [[schoolsList objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* sidebarStoryboard = [UIStoryboard storyboardWithName:@"SideBarStoryboard" bundle:nil];
    PMMenuViewController *menuVC = [sidebarStoryboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [menuVC setSchoolData:[schoolsList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:menuVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
