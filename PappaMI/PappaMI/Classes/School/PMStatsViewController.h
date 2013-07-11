//
//  PMStatsViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 11/07/13.
//

#import <UIKit/UIKit.h>

@interface PMStatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *statTableView;
}

@property (nonatomic, strong) NSArray *list;

@end
