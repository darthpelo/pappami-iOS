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
    NSString *urlSrt;
}

@property (nonatomic, copy) void (^newsSelected)(NSString *content);
@property (nonatomic, copy) void (^showProgress)(BOOL flag);

- (id)initWithFrame:(CGRect)frame allnews:(BOOL)flag;

@end
