//
//  DCTConnectionViewController.h
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTConnectionController.h"
#import "DCTConnectionControllerDisplay.h"

typedef void (^DCTConnectionViewControllerFinishedBlock) ();


@interface DCTConnectionViewController : UIViewController <UIWebViewDelegate, DCTConnectionControllerDisplay>

@property (nonatomic, strong) DCTConnectionController<DCTDisplayableConnectionController> *connectionController;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, copy) DCTConnectionViewControllerFinishedBlock completionBlock;

@end
