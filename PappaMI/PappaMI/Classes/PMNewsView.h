//
//  PMNewsView.h
//  PappaMI
//
//  Created by Alessio Roberto on 08/07/13.
//

#import <UIKit/UIKit.h>

@interface PMNewsView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *newsTableView;
    NSString *urlSrt;
}

@property (nonatomic, copy) void (^newsSelected)(NSString *content);
@property (nonatomic, strong) NSMutableArray *newsList;

@end
