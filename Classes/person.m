//
//  person.m
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import "person.h"


@implementation person
 /* 
 there are 4 hands, gripping something or not
 there is a body
 hands and body have weight, could fall
 hands and body are connected by springs
 hands get tired & let go if overburdened
 
 the hands attach bodies to grips
 springs attach hands and bodies
 
 the hands need to reach toward the mouse to grab a grip
 the hands need to grab grips
 the hands need to let go
 
 */

static int bodyXs[] = { 260, 360, 260, 360, 310, 290, 330, 290, 330 };
static int bodyYs[] = { 330, 330, 420, 420, 310, 350, 350, 390, 390 };

static int springLinksA[] = { 0, 1, 2, 3, 4, 4, 5, 5, 5, 6, 6, 7, 0, 1, 2, 3 };
static int springLinksB[] = { 5, 6, 7, 8, 5, 6, 6, 7, 8, 7, 8, 8, 7, 8, 5, 6 };

static int handFootBodyA[] = { 0, 1, 2, 3 }; 
static int handFootBodyB[] = { 5, 6, 7, 8 }; 
static int handFootSpringA[] = { 0, 1, 2, 3 }; 
static int handFootSpringB[] = { 12, 13, 14, 15 }; 


- (id) init:(float)maxReach {
	int i; 
	float k, sf;
	particle *a, *b; 
	spring *s1, *s2; 

	
	if (self = [super init]) {
		// build the body in place
		for (i=0; i<NUM_BODIES; ++i) { 
			ptInit(&(bodies[i]), bodyXs[i], bodyYs[i]); 
		}
		bodies[7].mass = 2.0f;
		bodies[8].mass = 2.0f;
				
		// add the muscles
		k = 9000.0;
		sf = 1.0;
		for (i=0; i<NUM_SPRINGS; ++i) {
			a = &(bodies[springLinksA[i]]);
			b = &(bodies[springLinksB[i]]);
			sprInit(&(springs[i]), a, b, sf, k); 
		}
		
		// hands and feet, 0:lh 1:rh 2:lf 3:right foot
		for (i=0; i<4; ++i) { 
			hands[i] = [[handFoot alloc] init];
			a = &(bodies[handFootBodyA[i]]);
			b = &(bodies[handFootBodyB[i]]);
			s1 = &(springs[handFootSpringA[i]]);
			s1 = &(springs[handFootSpringB[i]]);
			[hands[i] setup: a:b:s1:s2:i ];
			[hands[i] setReach:maxReach ];
		}
		
		sprSetSize(&bodySym, 50, 100); 
		sprSetMultiTile(&bodySym, 0x23, 1, 2);
		
		selectedHand=0;
		
		// set up gravity and friction
		gravInit(&theGravity, 0.0f, 1000.0f); 
		frkInit(&theFriction, 0.7f);
	
	
	
	}
	return self; 
}		

		
// teleport over to grab the grip at gxgy
// happens at beginning of level; set reach, too
- (void) teleport:(float)gx: (float)gy: (float)mr {
	float dx, dy;
	int i;
			
	// let go of everything
	for (i=0; i<4; ++i) { 
		[hands[i] ungrab];
		[hands[i] unselect]; 
		[hands[i] setReach: mr];
	}
			
	// move all the particles over to the new grip
	dx = gx - bodyXs[0];
	dy = gy - bodyYs[0];
	for (i=0; i<9; ++i) { 
		bodies[i].posx = bodyXs[i]+ dx;
		bodies[i].posy = bodyYs[i]+ dy;
		bodies[i].velx = 0.0f;
		bodies[i].vely = 0.0f;
		bodies[i].accx = 0.0f;
		bodies[i].accy = 0.0f;
		bodies[i].forx = 0.0f;
		bodies[i].fory = 0.0f;
		
	}
	[ hands[0] grab:gx:gy];
	
}




- (void) selectHand:(int)which {
	[ hands[selectedHand] unselect];
	selectedHand = which;
	[hands[which] select];
}


- (void) toggleFreedom {

}

- (void) stretch:(int)tighter {
	if (tighter==0) { 
		[ hands[selectedHand] stretch:.9f ]; 
	} else {
		[ hands[selectedHand] stretch:1.1f ]; 		
	}
}


- (float)getShoulderX {
	return [ hands[selectedHand] getShoulderX];
}
- (float)getShoulderY {
	return [ hands[selectedHand] getShoulderY];
}

		
- (bool) inRange:(float)msx: (float)msy {
	return [ hands[selectedHand] inRange:msx:msy ];
}
		
// mouse moves hands to grip
// down: active grip is removed from its hand
- (void) grab:(float)msx: (float) msy {
	[ hands[selectedHand] grab:msx: msy]; 
}
		
- (void) ungrab {
	[ hands[selectedHand] ungrab]; 
}
		

- (void)setAccel:(float*)a {
	accx = a[0]; 
	accy = a[1]; 
	// NSLog(@"%f, %f", a[0], a[1]);
}

		
- (void) update {
	int i; 
	float cx, cy; //, dx, dy, len, angle;
			
	// first, run springs
	for (i=0; i<NUM_SPRINGS; ++i) {
		sprExert(&(springs[i]));
	}
	
	// add the fricton, gravity, accelerometer input
	for (i=0; i<NUM_BODIES; ++i) {
		gravExert(&theGravity, &(bodies[i]));
		frkExert(&theFriction, &(bodies[i]));
		bodies[i].forx += accx*30000.0f;
		bodies[i].fory += accy*30000.0f;
	}
	
	
	// determine body center
	cx = 0;
	cy = 0;
	for (i=5; i<9; ++i) {
		cx += (bodies[i].posx)*0.25;
		cy += (bodies[i].posy)*0.25;
	}
	
	// then run/draw hands
	[hands[0] update:cx:cy-0.0f];  
	[hands[1] update:cx:cy-0.0f];  
	[hands[2] update:cx:cy+27.0f];  
	[hands[3] update:cx:cy+27.0f];  

	
	
	// then update particles
	for (i=0; i<NUM_BODIES; ++i) {
		ptUpdate(&(bodies[i]), 0.033); 
	}
	

	
	sprSetPos(&bodySym, cx, cy); 
	sprDraw(&bodySym); 
}



- (void) dealloc {
	int i;
		
	for (i=0; i<4; ++i) { 
		[hands[i] dealloc];
	}

	[super dealloc];
}






@end
