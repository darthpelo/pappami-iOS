//
//  VEConnectionErrorDelegate.h
//  VeespoLib
//
//  Created by Giordano Scalzo on 3/23/12.
//  Copyright (c) 2012 Veespo Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VEConnectionErrorDelegate <NSObject>

- (void)noRetryConnection;

@end