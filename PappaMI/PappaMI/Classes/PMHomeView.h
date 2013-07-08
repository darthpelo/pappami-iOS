//
//  PMHomeView.h
//  PappaMI
//
//  Created by Alessio Roberto on 03/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMHomeView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *homeTableView;
    NSArray *personalSchollsList;
}

@property (nonatomic, copy) void (^schoolSelected)(NSDictionary *school);

@end
