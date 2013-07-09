//
//  PMMenuCell.m
//  PappaMI
//
//  Created by Alessio Roberto on 04/07/13.
//

#import "PMMenuCell.h"

@implementation PMMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)buttonPressed:(id)sender
//{
//    if (self.feedbackSelected)
//        self.feedbackSelected(@"tgt-dfc11f51-162d-14a7-9bb5-2995f87f41a7");
//}

@end
