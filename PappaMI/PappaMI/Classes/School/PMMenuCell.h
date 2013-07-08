//
//  PMMenuCell.h
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMMenuCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@property (nonatomic, weak) IBOutlet UIButton *statButton;

@property (nonatomic, weak) IBOutlet UIButton *feedbackButton;

@property (nonatomic, copy) void (^feedbackSelected)(NSString *targetId);

- (IBAction)buttonPressed:(id)sender;

@end
