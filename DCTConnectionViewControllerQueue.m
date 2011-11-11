//
//  DCTConnectionViewControllerQueue.m
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTConnectionViewControllerQueue.h"

static DCTOAuth2ViewControllerQueue *sharedInstance = nil;

@interface DCTOAuth2ViewControllerQueue ()
- (void)dctInternal_displayConnectionControllerNotification:(NSNotification *)notification;
- (void)dctInternal_dismissConnectionControllerNotification:(NSNotification *)notification;
- (void)dctInternal_runNextConnectionViewController;
@end

@implementation DCTConnectionViewControllerQueue {
	DCTConnectionViewController *currentConnectionViewController;
	NSArray *queue;
}

@synthesize window;

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dctInternal_displayOAuth2ViewControllerNotification:) 
												 name:DCTConnectionControllerNeedsDisplayNotification
											   object:nil];
	
	queue = [[DCTQueue alloc] init];
	
	return self;
}

- (void)dctInternal_displayOAuth2ViewControllerNotification:(NSNotification *)notification {
	
	id o = [notification object];
	
	if (![o isKindOfClass:[DCTOAuth2AuthorizationConnectionController class]]) return;
	
	[queue enqueue:o];
	[self dctInternal_runNextConnectionController];
}

- (void)dctInternal_dismissOAuth2ViewControllerNotification:(NSNotification *)notification {
	
	id o = [notification object];
	
	if (![o isKindOfClass:[DCTOAuth2AuthorizationConnectionController class]]) return;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DCTOAuth2AuthorizationConnectionControllerNeedsDismissingNotification object:o];
	[displayingViewController.parentViewController dismissModalViewControllerAnimated:YES];
	
}

- (void)dctInternal_runNextConnectionController {
	
	if (currentConnectionViewController) return;
	
	if ([queue count] == 0) return;
	
	DCTConnectionController *cc = [queue objectAtIndex:0];
	
	NSAssert()
	
	
	if (![cc conformsToProtocol:@protocol()])
	
	
	
	displayingViewController = [[DCTConnectionViewController alloc] init];
	displayingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	displayingViewController.ConnectionController = cc;
	displayingViewController.delegate = self;
	[self.window.rootViewController presentModalViewController:displayingViewController animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dctInternal_dismissOAuth2ViewControllerNotification:) name:DCTOAuth2AuthorizationConnectionControllerNeedsDismissingNotification object:cc];
}

@end
