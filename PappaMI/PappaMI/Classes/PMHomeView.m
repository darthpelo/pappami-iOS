//
//  PMHomeView.m
//  PappaMI
//
//  Created by Alessio Roberto on 03/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMHomeView.h"

@implementation PMHomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        homeTableView = [[UITableView alloc] initWithFrame:frame];
        homeTableView.delegate = self;
        homeTableView.dataSource = self;
        [self addSubview:homeTableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personalSchollsList.count;
}

@end
