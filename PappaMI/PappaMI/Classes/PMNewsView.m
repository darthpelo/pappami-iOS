//
//  PMNewsView.m
//  PappaMI
//
//  Created by Alessio Roberto on 08/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMNewsView.h"
#import "AFNetworking.h"

@implementation PMNewsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        newsTableView = [[UITableView alloc] initWithFrame:frame];
        newsTableView.delegate = self;
        newsTableView.dataSource = self;
        [self addSubview:newsTableView];
    }
    return self;
}

- (void)loadData
{
    NSURL *url = [NSURL URLWithString:@"http://test.pappa-mi.it/api/node/news/stream/"];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *jsonRequest =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         PMNSLog("%@", JSON);
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
         PMNSLog("failure");
     }];
    [jsonRequest start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.schoolSelected)
//        self.schoolSelected([personalSchollsList objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
