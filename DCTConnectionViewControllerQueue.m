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
#import "DCTConnectionControllerDisplay.h"

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
											 selector:@selector(dctInternal_displayConnectionControllerNotification:) 
												 name:DCTConnectionControllerNeedsDisplayNotification
											   object:nil];
	
	queue = [[DCTQueue alloc] init];
	
	return self;
}

- (void)dctInternal_displayConnectionControllerNotification:(NSNotification *)notification {
	
	id o = [notification object];
	
	if (![o isKindOfClass:[DCTConnectionController class]]) return;
	
	NSAssert([o conformsToProtocol:@protocol(DCTDisplayableConnectionController)], @"Connection controller %@ should adhere to the DCTConnectionControllerDisplay protocol.", o);
			
	[queue enqueue:o];
	[self dctInternal_runNextConnectionViewController];
}

- (void)dctInternal_runNextConnectionViewController {
	
	if (currentConnectionViewController) return;
	
	if ([queue count] == 0) return;
	
	DCTConnectionController<DCTDisplayableConnectionController> *cc = [queue dequeue];
	
	NSAssert([cc conformsToProtocol:@protocol(DCTDisplayableConnectionController)], @"Connection controller %@ should adhere to the DCTConnectionControllerDisplay protocol.", cc);
	
	Class connectionControllerDisplayClass = [DCTConnectionViewController class];
		
	currentConnectionViewController = [[connectionControllerDisplayClass alloc] init];
	currentConnectionViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	currentConnectionViewController.connectionController = cc;
	
	__weak DCTConnectionViewControllerQueue *weakself = self;
	
	currentConnectionViewController.completionBlock = ^{
		[weakself.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
		[weakself dctInternal_runNextConnectionViewController];
	};
	
	[self.window.rootViewController presentViewController:currentConnectionViewController
												 animated:YES
											   completion:nil];
}

@end
