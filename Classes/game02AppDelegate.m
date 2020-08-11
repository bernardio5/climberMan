//
//  game02AppDelegate.m
//  game02
//
//  Created by Neal McDonald on 1/14/10.
//  Copyright University of Maryland, Baltimore County 2010. All rights reserved.
//

#import "game02AppDelegate.h"
#import "EAGLView.h"

@implementation game02AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[glView startAnimation];
	//Configure and start accelerometer
	
#if WITH_ACCELEROMETER	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0f / 10.0f)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
#endif
	
}

- (void) applicationWillResignActive:(UIApplication *)application
{
#if WITH_ACCELEROMETER	
	[[UIAccelerometer sharedAccelerometer] setDelegate: nil];
#endif
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
#if WITH_ACCELEROMETER	
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
#endif
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	float acc[3]; 
	acc[0] = acceleration.x; 
	acc[1] = acceleration.y; 
	acc[2] = acceleration.z; 
	[glView setAccel:acc];
}


- (void) dealloc
{
#if WITH_ACCELEROMETER	
	[[UIAccelerometer sharedAccelerometer] setDelegate: nil];
#endif
	[window release];
	[glView release];
	
	[super dealloc];
}

@end
