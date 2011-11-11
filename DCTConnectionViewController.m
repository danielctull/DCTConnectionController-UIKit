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

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[webView loadRequest:self.connectionController.URLRequest];
	navigationBar.topItem.title = self.title;
}

- (void)setTitle:(NSString *)title {
	[super setTitle:title];
	navigationBar.topItem.title = title;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if ([self.delegate respondsToSelector:@selector(oauth2ViewControllerDidDisappear:)])
		[self.delegate oauth2ViewControllerDidDisappear:self];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	
	if (!self.title || [self.title isEqualToString:@""])	
		self.title = [wv stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	
	NSString *requestString = [[request URL] absoluteString];
	
	if ([requestString hasPrefix:self.authorizationConnectionController.redirectURI]) {
		self.authorizationConnectionController.returnedObject = request;
		[self.authorizationConnectionController connectionDidFinishLoading];
		return NO;
	}
	
	return YES;
}

@end
