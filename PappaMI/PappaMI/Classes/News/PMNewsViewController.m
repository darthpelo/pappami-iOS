//
//  PMNewsViewController.m
//  PappaMI
//
//  Created by Alessio Roberto on 30/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMNewsViewController.h"

@interface PMNewsViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSDictionary *item = [self.newsList objectAtIndex:indexPath.row];
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
    if (self.newsSelected) {
        NSDictionary *item = [self.newsList objectAtIndex:indexPath.row];
        self.newsSelected(item[@"content"]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
