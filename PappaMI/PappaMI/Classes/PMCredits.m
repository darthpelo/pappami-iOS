//
//  PMCredits.m
//  PappaMI
//
//  Created by Alessio Roberto on 22/08/13.
//

#import "PMCredits.h"
#import "Utils.h"

@implementation PMCredits

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:[Utils getNavigableContentFrame]];
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
