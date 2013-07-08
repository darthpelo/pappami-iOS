//
//  PMNewsView.h
//  PappaMI
//
//  Created by Alessio Roberto on 08/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMNewsView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *newsTableView;
    NSMutableArray *newsList;
}

@end
