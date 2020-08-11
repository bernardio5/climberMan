//
//  game02AppDelegate.h
//  game02
//
//  Created by Neal McDonald on 1/14/10.
//  Copyright University of Maryland, Baltimore County 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

#define WITH_ACCELEROMETER 1

@interface game02AppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet EAGLView *glView;
	}

@property (nonatomic, retain) UIWindow *window;

@end
