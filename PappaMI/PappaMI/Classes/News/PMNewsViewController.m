//
//  PMNewsViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 30/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMNewsViewController.h"
#import "PMNewsDetailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface PMNewsViewController () {
    NSMutableArray *newsList;
}

@end

@implementation PMNewsViewController

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
	// Do any additional setup after loading the view.
    self.title = @"News";
    self.newsTableView.backgroundColor = UIColorFromRGB(0x00B2EE);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getNewsList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Download News
- (void)getNewsList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/node/news/stream/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        newsList = [NSMutableArray arrayWithArray:JSON[@"posts"]];
                                                        [self.newsTableView reloadData];
                                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        PMNSLog("failure");
                                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                    }];
    [jsonRequest start];
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"NewsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCell"];
    }

    NSDictionary *item = [newsList objectAtIndex:indexPath.row];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item[@"author"][@"name"],item[@"ext_date"]];
    cell.textLabel.font = [UIFont fontWithName:boldFontName size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:12];
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [newsList objectAtIndex:indexPath.row];
    PMNewsDetailViewController *newsVC = [[PMNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    [newsVC setWebContent:item[@"content"]];
    [self.navigationController pushViewController:newsVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
