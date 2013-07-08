//
//  PMHomeView.m
//  PappaMI
//
//  Created by Alessio Roberto on 03/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMHomeView.h"


@implementation PMHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        homeTableView = [[UITableView alloc] initWithFrame:frame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [self addSubview:homeTableView];
    }
    return self;
}

- (void)loadData
{
    personalSchollsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
    PMNSLog("%@", personalSchollsList);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personalSchollsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [[personalSchollsList objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.schoolSelected)
        self.schoolSelected([personalSchollsList objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
