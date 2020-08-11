//
//  gripBoard.h
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "sprite.h"

#define MAX_GRIPS 240

@interface gripBoard : NSObject {
	sprite grips[MAX_GRIPS];

	sprite targetSym, flairSym, flashSym;

	int target, starterGrip, gripsUsed;
	float ox, oy;
	int randomCounter; 
	float turning, maxReach; 
}
- (void)initBomb:(int)w: (int)h: (int)cols: (int)rows: (int)xstart:(int)ystart;


- (void)initLevel:(int)which:(float)maxReach;

- (int) getFirstGrip;
- (int) onGrip:(float)msx: (float)msy ;
- (float) gripX:(int)which ;
- (float) gripY:(int)which ;
- (bool) isTarget:(int)which ;
- (void) setOrigin:(float)ox:(float)oy;
- (void) update: (float)sx: (float)sy ;



@end
