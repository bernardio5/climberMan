//
//  person.h
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//


// object for the climber guy
// made of particles, springs and handfeet objects (which grab things and draw)
// (could endure refactoring) 
// knows nothing of grips; only grabs where told-- there need be nothing there. 


#import <Foundation/Foundation.h>

#import "sprite.h"
#import "particle.h"
#import "handFoot.h"


#define NUM_BODIES 9
#define NUM_ROPES 10
#define NUM_SPRINGS 16


@interface person : NSObject {
	
	particle bodies[NUM_BODIES];
	spring springs[NUM_SPRINGS];
	gravity theGravity;
	friction theFriction; 
	
	handFoot *hands[4]; // left right hand foot
	int selectedHand; // which hand is reaching for the mouse?
	
	
	sprite bodySym;
	float accx, accy;
}

- (id) init:(float)maxReach;
- (void) teleport:(float)gx: (float)gy: (float)mr;
	
- (void) selectHand:(int)which;

- (void) toggleFreedom;


- (void) stretch:(int)tighter;

// get the center of the current reach range.
- (float)getShoulderX; 
- (float)getShoulderY; 

- (bool) inRange:(float)msx: (float)msy;

- (void) grab:(float)msx: (float) msy;

- (void) ungrab;

- (void)setAccel:(float*)a;




// operate game and redraw visual elements
- (void)update;





// - (int)takeAccel:(float *)xyz;


// touches are different for this version
// we'll have 4 corner sprites: hands and feet. 
// touching them selects the limb
// touching in the range is an attempt to grab a grip; 

// - (int)takeTouch:(float *)ts;

@end
