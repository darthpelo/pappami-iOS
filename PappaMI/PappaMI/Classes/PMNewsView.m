//
//  PMNewsView.m
//  PappaMI
//
//  Created by Alessio Roberto on 08/07/13.
//

#import "PMNewsView.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@implementation PMNewsView

- (id)initWithFrame:(CGRect)frame allnews:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!flag)
            urlSrt = [NSString stringWithFormat:@"http://%@/api/node/all/stream/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]];
        else
            urlSrt = [NSString stringWithFormat:@"http://%@/api/node/news/stream/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]];
        newsTableView = [[UITableView alloc] initWithFrame:frame];
        newsTableView.delegate = self;
        newsTableView.dataSource = self;
        [self addSubview:newsTableView];
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSURL *url = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        url = [NSURL URLWithString:urlSrt];
    else
        url = [NSURL URLWithString:urlSrt];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         newsList = [NSMutableArray arrayWithArray:JSON[@"posts"]];
         [newsTableView reloadData];
         if (self.showProgress)
         self.showProgress(NO);
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         PMNSLog("failure");
         if (self.showProgress)
         self.showProgress(NO);
    }];
    [jsonRequest start];
    if (self.showProgress)
    self.showProgress(YES);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsList.count;
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
    NSDictionary *item = [newsList objectAtIndex:indexPath.row];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", item[@"author"][@"name"],item[@"ext_date"]];
    cell.textLabel.font = [UIFont fontWithName:boldFontName size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:12];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newsSelected) {
        NSDictionary *item = [newsList objectAtIndex:indexPath.row];
        self.newsSelected(item[@"content"]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
