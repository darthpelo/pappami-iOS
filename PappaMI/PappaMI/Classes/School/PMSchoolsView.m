//
//  PMSchoolsView.m
//  PappaMI
//
//  Created by Alessio Roberto on 12/07/13.
//

#import "PMSchoolsView.h"

@implementation PMSchoolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titolo = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 280, 21)];
        titolo.font = [UIFont fontWithName:@"Avenir-Black" size:20];
        [titolo setBackgroundColor:[UIColor clearColor]];
        titolo.textAlignment = NSTextAlignmentCenter;
        titolo.text = @"Seleziona una scuola di Milano";
        [self addSubview:titolo];
        CGRect tFrame = CGRectMake(frame.origin.x, titolo.frame.origin.y + titolo.frame.size.height + 3, frame.size.width, frame.size.height - (titolo.frame.origin.y + titolo.frame.size.height) + 3);
        homeTableView = [[UITableView alloc] initWithFrame:tFrame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [homeTableView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:homeTableView];
    }
    return self;
}

- (void)loadView
{
    [homeTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schoolsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [[self.schoolsList objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.schoolSelected)
        self.schoolSelected([self.schoolsList objectAtIndex:indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
