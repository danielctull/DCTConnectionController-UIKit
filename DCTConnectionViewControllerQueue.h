//
//  DCTConnectionViewControllerQueue.h
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTConnectionController+UIKit.h"

/** A queue to handle the presenting of DCTConnectionViewController instances that allow the display
 of web-based connections. This is primarily aimed at handling OAuth-type operations.
 
 Near the start of every application loading the singleton instance of DCTConnectionViewControllerQueue 
 should be retrieved using sharedQueue and given the main UIWindow for the application. This is likely
 to be in application:didFinishLaunchingWithOptions: and can be as simple as the following:
 
 DCTConnectionViewControllerQueue *queue = [[DCTConnectionViewControllerQueue alloc] init];
 queue.window = self.window;
 
 This allows the queue to listen for notifications from instances of DCTOAuth2AuthorizationConnectionController
 that they require being displayed. Once an DCTOAuth2AuthorizationConnectionController has completed,
 it sends a notification that it needs to be dismissed, which the queue also takes care of.
 
 The reason for this being a queue is the unlikely (but still probable) case where two different OAuth2 services
 need a login at the same time, this class will queue up the second until the first finishes. Once the
 first is complete, it will show another DCTOAuth2ViewController for the second connection controller.
 
 Note: Becuase this requirement in also apparent in the first OAuth, this class (along with the view controller 
 peices) may become their own project. Also, due to the separation of the view controller and connection controllers, 
 I'm hoping it'll be easy to create a GUI for Mac OS X so the connection controllers will work on there too.
 */
@interface DCTConnectionViewControllerQueue : NSObject

/** The main UIWindow of the application. The queue uses the rootViewController property to
 modally present a DCTOAuth2ViewController when one is needed to login to a service. */
@property (nonatomic, retain) UIWindow *window;

@end
