//
//  PMHomeViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 13/07/13.
//

#import <UIKit/UIKit.h>

@interface PMHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *homeTableView;
    NSArray *schoolsList;
}

@end
