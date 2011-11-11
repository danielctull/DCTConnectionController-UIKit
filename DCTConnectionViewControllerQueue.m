//
//  DCTConnectionViewControllerQueue.m
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTConnectionViewControllerQueue.h"
#import "DCTConnectionViewController.h"
#import "DCTQueue.h"

@interface DCTConnectionViewControllerQueue ()
- (void)dctInternal_displayConnectionControllerNotification:(NSNotification *)notification;
- (void)dctInternal_runNextConnectionViewController;
@end

@implementation DCTConnectionViewControllerQueue {
	DCTConnectionViewController *currentConnectionViewController;
	DCTQueue *queue;
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

- (void)dctInternal_displayConnectionControllerNotification:(NSNotification *)notification {
	
	id o = [notification object];
	
	if (![o isKindOfClass:[DCTConnectionController class]]) return;
	
	NSAssert([o conformsToProtocol:@protocol(DCTConnectionControllerDisplay)], @"Connection controller %@ should adhere to the DCTConnectionControllerDisplay protocol.", o);
			
	[queue enqueue:o];
	[self dctInternal_runNextConnectionViewController];
}

- (void)dctInternal_runNextConnectionViewController {
	
	if (currentConnectionViewController) return;
	
	if ([queue count] == 0) return;
	
	DCTConnectionController<DCTConnectionControllerDisplay> *cc = [queue dequeue];
	
	NSAssert([cc conformsToProtocol:@protocol(DCTConnectionControllerDisplay)], @"Connection controller %@ should adhere to the DCTConnectionControllerDisplay protocol.", cc);
	
	Class connectionViewControllerClass = [cc connectionViewControllerClass];
	
	currentConnectionViewController = [[connectionViewControllerClass alloc] init];
	currentConnectionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	currentConnectionViewController.connectionController = cc;
	
	__weak DCTConnectionViewController *cvc = currentConnectionViewController;
	__weak DCTConnectionViewControllerQueue *weakself = self;
	
	currentConnectionViewController.completionBlock = ^{
		[cvc.parentViewController dismissModalViewControllerAnimated:YES];
		[weakself dctInternal_runNextConnectionViewController];
	};
	
	[self.window.rootViewController presentModalViewController:currentConnectionViewController animated:YES];
}

@end
