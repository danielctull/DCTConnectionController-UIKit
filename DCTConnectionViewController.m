//
//  DCTConnectionViewController.m
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTConnectionViewController.h"

@implementation DCTConnectionViewController

@synthesize connectionController;
@synthesize webView;
@synthesize navigationBar;
@synthesize completionBlock;

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.webView loadRequest:self.connectionController.URLRequest];
	self.navigationBar.topItem.title = self.title;
}

- (void)setTitle:(NSString *)title {
	[super setTitle:title];
	self.navigationBar.topItem.title = title;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	
	if (!self.title || [self.title isEqualToString:@""])	
		self.title = [wv stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	/*
	NSString *requestString = [[request URL] absoluteString];
	
	if ([requestString hasPrefix:self.connectionController.redirectURI]) {
		self.connectionController.returnedObject = request;
		[self.connectionController connectionDidFinishLoading];
		return NO;
	}*/
	
	if (self.completionBlock)
		self.completionBlock();
	
	return NO;
}

@end
