//
//  YHCPickerView.m
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import "YHCPickerView.h"

@implementation YHCPickerView
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = arrValues;
    }
    return self;

}
-(void)showPicker{

    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    
    CGFloat yOffset = ([UIScreen mainScreen].bounds.size.height == 568.0f) ? 348.0 : 260.0;
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 200 + yOffset, 320.0, 0.0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
        
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 156 + yOffset, 320, 44)];
    picketToolbar.barStyle = UIBarStyleDefault;
    [picketToolbar sizeToFit];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClick)];

    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    
    [UIView animateWithDuration:0.45 animations:^{
        pickerView.frame = CGRectMake(0.0, 200, 320.0, 0.0);
        picketToolbar.frame = CGRectMake(0, 156, 320, 44);
    }];
}

-(void)btnDoneClick{
    
    NSString *strSelectedValue;
    
    strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
    int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)])
        [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
    CGFloat yOffset = ([UIScreen mainScreen].bounds.size.height == 568.0f) ? 348.0 : 260.0;
    [UIView animateWithDuration:0.45 animations:^{
        pickerView.frame = CGRectMake(0.0, 200 + yOffset, 320.0, 0.0);
        picketToolbar.frame = CGRectMake(0, 156 + yOffset, 320, 44);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrRecords.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.arrRecords objectAtIndex:row];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
           
}

@end
