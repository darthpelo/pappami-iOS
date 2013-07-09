//
//  PMMenuViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//

#import <UIKit/UIKit.h>
#import "TDDatePickerController.h"

@interface PMMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    TDDatePickerController *datePicker;
}

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UIButton *dateButton;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, strong) NSDictionary *schoolData;

- (IBAction)dateButtonPressed:(id)sender;

@end
