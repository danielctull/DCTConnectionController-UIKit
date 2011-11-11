//
//  DCTConnectionViewController.h
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTConnectionController.h"



@protocol DCTConnectionControllerDisplay <NSObject>
@property (nonatomic, readonly) Class connectionViewControllerClass;
@end



typedef void (^DCTConnectionViewControllerFinishedBlock) ();


@interface DCTConnectionViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) DCTConnectionController *connectionController;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, copy) DCTConnectionViewControllerFinishedBlock completionBlock;

@end
