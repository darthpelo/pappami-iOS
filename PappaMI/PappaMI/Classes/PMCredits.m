//
//  PMCredits.m
//  PappaMI
//
//  Created by Alessio Roberto on 22/08/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "PMCredits.h"

@implementation PMCredits

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [webView setBackgroundColor:[UIColor clearColor]];
        webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = NO;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                              pathForResource:@"credits" ofType:@"html"] isDirectory:NO]]];
        [self addSubview:webView];
    }
    return self;
}



@end
