//
//  PMDishViewController.h
//  PappaMI
//
//  Created by Alessio Roberto on 05/07/13.
//

#import <UIKit/UIKit.h>

@interface PMDishViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *dishData;

@property (nonatomic, strong) NSString *dishId;

@property (nonatomic, weak) IBOutlet UITableView *compTableView;

@property (nonatomic, weak) IBOutlet UIButton *statButton;

@property (nonatomic, weak) IBOutlet UIButton *veespoButton;

- (IBAction)statPressed:(id)sender;

- (IBAction)veespoPressed:(id)sender;

@end
