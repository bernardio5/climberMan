//
//  handFoot.h
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "sprite.h"
#import "particle.h"

#define MAX_STR 10.0f

@interface handFoot : NSObject {
	sprite  sym, selSym, shoSym, sleeveSym, lungeSym;
	particle *owner, *shoulder; // the body/shoulder to which the hand is attached
	float gpx, gpy, strength; // the site of the grip to which the hand grabs
	spring *s1, *s2;
	float maxReach, maxReachSq;
	int sel, holding; // whether the grip is selected, attached to a grip
	
}

- (void)setup: (particle *)hnd : (particle *)should : (spring *)sp1 : (spring *)sp2 : (int)handp;


- (float)getShoulderX; 
- (float)getShoulderY; 

- (void) setReach:(float)mr;
- (void) select;
- (void) unselect;
- (bool) inRange:(float) msx:(float) msy;

- (void) grab: (float)newX: (float)newY;
- (void) ungrab ;

- (void) stretch:(float)ds;

- (void) update:(float)cx:(float)cy ; 




@end
