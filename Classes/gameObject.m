//
//  gameObject.m
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import "gameObject.h"


@implementation gameObject


- (id)init {
	if (self = [super init]) {
		// new gripBoard
		gripBr = [[gripBoard alloc] init];
		// new person
		maxReach = 80.0;
		user = [[person alloc] init:maxReach];
		// new timer
		theTimer = [[timer alloc] init];
		
		// initially be in sell-screen mode
		
		// shucks: settings should get saved/restored
		settings[0] = 1; // music
		settings[1] = 0; // freedom
		settings[2] = 1; // gravity
		settings[3] = 1; // peace
		
		
		[self takeMessage:5];
	}	
	return self;
}

// operate game and redraw visual elements
- (void)update {
	float sx, sy; 
	
	if (gameMode!=2) { 
		sx = [user getShoulderX]; 
		sy = [user getShoulderY]; 
		[gripBr update: sx: sy]; 
		[user update]; 
	}
	[theTimer updater]; 

}

// mesages: 1,2,3:start EZ,med,hard 4:resume 5:exit, start sell mode 
- (void)takeMessage:(int)which {
	int i, j;
	float nx, ny; 
	
	switch (which) { 
		case 1: gameMode = 1; [theTimer startGame]; maxReach = 90.0; break; // start easy
		case 2: gameMode = 1; [theTimer startGame]; maxReach = 80.0; break; // start med
		case 3: gameMode = 1; [theTimer startGame]; maxReach = 70.0; break; // start hard
		case 4: gameMode = 2; [theTimer resumer];   break; // resume
		case 5: gameMode = 0; [theTimer hideme];    maxReach = 80.0; break; // exit, goto sell
			
		// select hands and feet
		case 6: [ user selectHand:0 ];  [theTimer addOne]; break; // lh 
		case 7: [ user selectHand:2 ];  [theTimer addOne]; break; // lf
		case 8: [ user selectHand:1 ];  [theTimer addOne]; break; // ll 
		case 9: [ user selectHand:3 ];  [theTimer addOne]; break; // rl 

		// change settings
	}
	if ((20<which)&&(which<30)) { gameMode = 1; [theTimer startGame]; maxReach = 90.0; };
	if ((30<which)&&(which<40)) { gameMode = 1; [theTimer startGame]; maxReach = 80.0; };
	if ((40<which)&&(which<50)) { gameMode = 1; [theTimer startGame]; maxReach = 70.0; };
	
	
	// restart game? 
	if ((which<4)||(which==5)) {
		[gripBr initLevel:which:maxReach];
		j = [gripBr getFirstGrip];
		nx = [gripBr gripX:j];
		ny = [gripBr gripY:j];
		[ user teleport:nx: ny: maxReach];
		
		// teleport attaches one hand to the starter grip
		// attach the other hands to whatever
		for (i=1; i<4; ++i) {
			[user selectHand: i];
			for (j=0; j<MAX_GRIPS; ++j) { 
				nx = [gripBr gripX:j];
				if (nx>-50.0f) { 
					ny = [gripBr gripY:j];
					if ([user inRange:nx:ny]) {
						[user grab:nx:ny];
					}
				}
			}
		}
		[user selectHand:0];
	}
}


- (int)takeTouch:(float)msx:(float)msy {
	int it, res;

	res = 0; 

	if (gameMode == 1) { // i.e. we are playing, so listen
		// if you can reach there
		if ([user inRange:msx: msy]) { 
			// if there's something to grab
			it = [gripBr onGrip:msx:msy];
			if (it!=-1) { 
				// grab it!
				[ user grab:([gripBr gripX:it]):([gripBr gripY:it]) ]; 
			
				if ([ gripBr gripY:it]<100) { 
				}
			
				if ([gripBr isTarget:it]) {
					res = 1; 
					gameMode = 3; // vistory mode: no more input, but do continue physics
					[theTimer stopGame]; 
				}
			
			} else {
				// clicked on nothing
				// [user ungrab];
			}
		
		} // if inRange
	} // if gameMode
 
	return res; 
}


- (void)setAccel:(float*)a {
	[user setAccel:a];
}




- (void) dealloc
{
	[gripBoard dealloc];
	[user dealloc];
	[theTimer dealloc]; 
	
	[super dealloc];
}




@end
