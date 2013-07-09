//
//  PMHomeView.h
//  PappaMI
//
//  Created by Alessio Roberto on 03/07/13.
//

#import <UIKit/UIKit.h>

@interface PMHomeView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *homeTableView;
    NSArray *personalSchollsList;
}

@property (nonatomic, copy) void (^schoolSelected)(NSDictionary *school);

@end
