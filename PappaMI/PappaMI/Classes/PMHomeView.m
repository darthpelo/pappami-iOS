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
        titolo.font = [UIFont fontWithName:@"Avenir-Black" size:20];
        [titolo setBackgroundColor:[UIColor clearColor]];
        titolo.textAlignment = NSTextAlignmentCenter;
        titolo.text = @"Le scuole dei tuoi figli";
        [self addSubview:titolo];
        CGRect tFrame = CGRectMake(frame.origin.x, titolo.frame.origin.y + titolo.frame.size.height + 10, frame.size.width, frame.size.height - (titolo.frame.origin.y + titolo.frame.size.height));
        homeTableView = [[UITableView alloc] initWithFrame:tFrame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [homeTableView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:homeTableView];
    }
    return self;
}

- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER])
        personalSchoolsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGGEDUSER] objectForKey:@"schools"]];
    else
        personalSchoolsList = [NSArray arrayWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:GUESTUSER] objectForKey:@"schools"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personalSchoolsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [[personalSchoolsList objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.schoolSelected)
        self.schoolSelected([personalSchoolsList objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
