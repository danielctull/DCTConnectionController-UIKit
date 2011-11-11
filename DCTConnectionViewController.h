//
//  DCTConnectionViewController.h
//  
//
//  Created by Daniel Tull on 11.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTConnectionController.h"



@protocol DCTConnectionController <NSObject>
@property (nonatomic, readonly) Class connectionViewControllerClass;
@end




@interface DCTConnectionViewController : UIViewController

@property (nonatomic, strong) DCTConnectionController *connectionController;

@end
