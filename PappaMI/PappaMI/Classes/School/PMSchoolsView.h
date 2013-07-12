//
//  PMSchoolsView.h
//  PappaMI
//
//  Created by Alessio Roberto on 12/07/13.
//

#import <UIKit/UIKit.h>

@interface PMSchoolsView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *homeTableView;
}

@property (nonatomic, copy) void (^schoolSelected)(NSDictionary *school);

@property (nonatomic, strong) NSArray *schoolsList;

@end
