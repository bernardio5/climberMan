//
//  handFoot.m
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//

#import "handFoot.h"


@implementation handFoot

/*
 This class is for feet and hands.
 They grab onto a place and hold up the rest.
 They can be moved; when they are moving they can't hold weight. 
 When they are holding weight, they get tired.
 When they are too tired, they fall off. 
 
 they should travel between grips in a finite amount of time
 the arm should look more like an arm.
 
 
 hndFeet know nothing of grips; they just grab a particular place (x,y) 
 
 
 
 This class is the arms/legs of the climber.
 It takes input: where to grab.
 It tells whether a point is in range
 It draws the arm and hand
 
 */
		
- (void)setup: (particle *)hnd : (particle *)should : (spring *)sp1 : (spring *)sp2 : (int)handp {			
	sprSetSize(&sym, 50, 50); 
	sprSetSize(&selSym, 50, 50); 
	sprSetSize(&shoSym, 50, 50); 
	sprSetSize(&sleeveSym, 50, 50); 
	sprSetSize(&lungeSym, 50, 50); 
	maxReach = 90.0f;
	maxReachSq = maxReach*maxReach;
	
	switch (handp) { // 0:lh 1:rh 2:lf 3:right foot
		case 0: // lf hn
			sprSetMultiTile(&sym, 0x10, 1, 1);
			sprSetMultiTile(&selSym, 0x11, 1, 1);
			sprSetMultiTile(&sleeveSym, 0x22, 1, 1);
			break;
		case 1: //rt hn
			sprSetMultiTile(&sym, 0x12, 1, 1);
			sprSetMultiTile(&selSym, 0x13, 1, 1);
			sprSetMultiTile(&sleeveSym, 0x22, 1, 1);
			break;
		case 2: // lf ft
			sprSetMultiTile(&sym, 0x14, 1, 1);
			sprSetMultiTile(&selSym, 0x15, 1, 1);
			sprSetMultiTile(&sleeveSym, 0x32, 1, 1);
			break;		
		case 3: // rt ft
			sprSetMultiTile(&sym, 0x35, 1, 1);
			sprSetMultiTile(&selSym, 0x24, 1, 1);
			sprSetMultiTile(&sleeveSym, 0x32, 1, 1);
			break;
	}
	//	sym = new handSymbol();
	//	selSym = new handSelSymbol();
	sprSetMultiTile(&shoSym, 0x25, 1, 1);
	sprSetMultiTile(&lungeSym, 0x36, 1, 1);
			
	owner = hnd; // where the hand is
	shoulder = should; // shoulder is the basis of hand range
	s1 = sp1; 
	s2 = sp2; 
	sel = 0; 
	holding = 0; 
	// strength = maxStr; 
}



- (void) setReach: (float)mr {
	maxReach = mr;
	maxReachSq = mr*mr;
}
	

- (void) select { 
	sel = 1;
}

- (void) unselect { 
	sel = 0;
}


- (float)getShoulderX { 
	return shoulder->posx; 
}

- (float)getShoulderY { 
	return shoulder->posy; 
}


- (bool) inRange:(float) msx:(float) msy {
	float dx, dy;
	dx = msx-shoulder->posx;
	dy = msy-shoulder->posy;
	if ((dx*dx+dy*dy)<maxReachSq) { 
		return YES;
	} 
	return NO;
}
		
		
- (void) grab: (float)newX: (float)newY {
	if ([self inRange:newX: newY]) { 			
		gpx = newX;
		gpy = newY;
		holding = 1;
	}
}
		
- (void) ungrab {
	holding = 0;
}
	


- (void) stretch:(float)ds {
	sprChangeLen(s1, ds);
	sprChangeLen(s2, ds);
}
		
		
- (void) update:(float)cx:(float)cy {
	float dx, dy, len, angle;
			
	// figure arm rotation 
	sprSetConnector(&shoSym, 50.0f, shoulder->posx, shoulder->posy, owner->posx, owner->posy); 

	sprSetRot(&lungeSym, (shoSym.r)+1.5707963); 

	sprSetPos(&selSym, owner->posx, owner->posy);
	sprSetRot(&selSym, (shoSym.r));

	sprSetPos(&sym, owner->posx, owner->posy);
	sprSetRot(&sym, (shoSym.r));
		
	// figure sleeve rotation
 	sprSetConnector(&sleeveSym, 50.0f, cx, cy, shoulder->posx, shoulder->posy); 

	// set up lunge symbol
	dx = shoulder->posx - owner->posx; 
	dy = shoulder->posy - owner->posy; 
	dx = dx*3 + shoulder->posx; 
	dy = dy*3 + shoulder->posy; 
	sprSetPos(&lungeSym, dx, dy);
	//sprSetRot(&lungeSym, angle); 
	
	if (holding==1) { 
		// ownr part wil have been sprung upon
		// f = sqrt(owner->forx*owner->forx+owner->fory*owner->fory);				
		owner->forx = 0.0f;
		owner->fory = 0.0f;
		owner->velx = 0.0f;
		owner->velx = 0.0f;
		owner->vely = 0.0f;
		owner->posx = gpx;
		owner->posy = gpy;
	}
		
	sprDraw(&shoSym); 
	if (sel==1) { 
		// sprDraw(&rangeSym); 
		sprDraw(&selSym); 
		sprDraw(&lungeSym); 
	} else {
		sprDraw(&sym); 
	}
	
	sprDraw(&sleeveSym); 
}


- (void) dealloc
{
	
	
	[super dealloc];
}



		

@end
