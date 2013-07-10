//
//  PMHomeView.m
//  PappaMI
//
//  Created by Alessio Roberto on 03/07/13.
//

#import "PMHomeView.h"


@implementation PMHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        UILabel *titolo = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 280, 21)];
        titolo.font = [UIFont fontWithName:@"Avenir-Black" size:14];
        [titolo setBackgroundColor:[UIColor clearColor]];
        titolo.textAlignment = NSTextAlignmentCenter;
        titolo.text = @"Le scuole dei tuoi figli";
        [self addSubview:titolo];
        CGRect tFrame = CGRectMake(frame.origin.x, titolo.frame.origin.y + titolo.frame.size.height, frame.size.width, frame.size.height - (titolo.frame.origin.y + titolo.frame.size.height) + 3);
        homeTableView = [[UITableView alloc] initWithFrame:tFrame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [homeTableView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:homeTableView];
    }
    return self;
}

- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        personalSchollsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
    else
        personalSchollsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:GUESTUSER] objectForKey:@"schools"]];
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
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.schoolSelected)
        self.schoolSelected([personalSchollsList objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
