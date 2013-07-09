//
//  PMMenuCell.h
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//

#import <UIKit/UIKit.h>

@interface PMMenuCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, copy) void (^feedbackSelected)(NSString *targetId);

@end
