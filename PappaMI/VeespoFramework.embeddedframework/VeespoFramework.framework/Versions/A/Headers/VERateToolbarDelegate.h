//
//  VERateToolbarDelegate.h
//  VeespoLib
//
//  Created by Giordano Scalzo on 3/23/12.
//  Copyright (c) 2012 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VERateToolbarDelegate <NSObject>
-(void)back:(id)sender;
-(void)tags:(id)sender;
-(void)submit:(id)sender;
@end
