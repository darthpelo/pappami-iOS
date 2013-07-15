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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        newsTableView = [[UITableView alloc] initWithFrame:frame];
        newsTableView.delegate = self;
        newsTableView.dataSource = self;
        [self addSubview:newsTableView];
    }
    return self;
}

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

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.newsSelected) {
        NSDictionary *item = [self.newsList objectAtIndex:indexPath.row];
        self.newsSelected(item[@"content"]);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
