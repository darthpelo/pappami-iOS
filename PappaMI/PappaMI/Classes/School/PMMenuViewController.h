//
//  PMMenuViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//

#import <UIKit/UIKit.h>
#import "TDDatePickerController.h"
#import "PickerView.h"

@interface PMMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PickerViewDelegate> {
    TDDatePickerController *datePicker;
    PickerView *schoolPicker;
    NSDictionary *schoolData;
    NSString *dateString;
    NSArray *citySchools;
}

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, weak) IBOutlet UIButton *dateButton;

@property (nonatomic, weak) IBOutlet UIButton *schoolButton;

- (IBAction)dateButtonPressed:(id)sender;

- (IBAction)schoolButtonPressed:(id)sender;

@end
