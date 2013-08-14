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
    self.backgroundColor = [UIColor clearColor];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 200, 320.0, 0.0)];
    
    //[picketView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 156, 320, 44)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    picketToolbar.barStyle = UIBarStyleBlackOpaque;
    [picketToolbar sizeToFit];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClick)];

    NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:flexible,btnDone, nil];
    [picketToolbar setItems:arrBarButtoniTems];
    [self addSubview:pickerView];
    [self addSubview:picketToolbar];
    
}

-(void)btnDoneClick{
    
    NSString *strSelectedValue;
    
    strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
    int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)])
        [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
    
    [self removeFromSuperview];
    
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
