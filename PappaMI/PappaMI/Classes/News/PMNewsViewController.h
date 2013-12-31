//
//  PMNewsViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 30/12/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *newsTableView;

@end
