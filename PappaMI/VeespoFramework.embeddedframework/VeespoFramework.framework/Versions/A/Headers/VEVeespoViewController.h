//
//  VEVeespoViewController.h
//  VeespoLib
//
//  Created by Giordano Scalzo on 2/1/12.
//  Copyright (c) 2012 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VEConnectionErrorDelegate.h"
#import "VECreateTagDelegate.h"
#import "VERateToolbarDelegate.h"

@interface VEVeespoViewController : UIViewController <VERateToolbarDelegate, UISearchBarDelegate, VEConnectionErrorDelegate, VECreateTagDelegate>

- (void)loadDataFor:(NSString *)targetId_ title:(NSString *)title detailsView:(UIView *)detailsView;
- (void)setSkins:(int)value;

@property (nonatomic, copy) void (^closeVeespoViewController)(NSDictionary *resultData);

@end
