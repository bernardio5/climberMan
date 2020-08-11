//
//  gameObject.m
//  game02
//
//  Created by Neal McDonald on 1/14/10.
//

#import "menuObject.h"


@implementation menuObject
// link buttons to screens and game start/resume
//											   0  1  2  3  4   5  6  7  8    9  0  1  2  3,  4  5  6  7  8   9  0  1  2
// which screen do you belong to?
static const int targetScreen[NUM_BUTTONS] = { 1, 1, 1, 1,  2, 2, 4,   5, 5, 5, 5, 5,  6, 6, 6, 6, 6, 
											7,  7, 7, 7,  7, 7, 7,   7, 7, 7,  7, 
											8,  8, 8, 8,  8, 8, 8,   8, 8, 8, 8,
											9,  9, 9, 9,  9, 9, 9,   9, 9, 9,  9, };
// when clicked, go to what screen? 
static const int nextScreen[NUM_BUTTONS] =  { -1, 5, 2,-1,  1,-1, 1,  -1, 7, 8, 9, 1, -1,-1,-1,-1, 1,
-1,   6, 6, 6,  6, 6, 6,   6, 6, 6,  5, 
-1,   6, 6, 6,  6, 6, 6,   6, 6, 6,  5, 
-1,   6, 6, 6,  6, 6, 6,   6, 6, 6,  5, 
};
// when clicked, say what to the game?  menu-to-game messages: 4resume, 5 exit to sell, 
//												6789 select handfoot   20-29 easy  30-39 med  40-49 hard
static const int gameMessage[NUM_BUTTONS] = {  0, 0, 0, 0,  0, 0, 5,   0, 0,0,0, 0,  6, 8, 7, 9, 5, 
0,   21, 22, 23, 24, 25, 26, 27, 28, 29, 0,
0,   31, 32, 33, 34, 35, 36, 37, 38, 39, 0,
0,   41, 42, 43, 44, 45, 46, 47, 48, 49, 0,
			};

// what are the onscreen coords? 
//     0      1      2      3      4      5      6      7       8       9      0      1      2      3   
// y coords don't change
static const float ys[NUM_BUTTONS] = { 60.0f, 223.0f, 273.0f, 440.0f,
										150.0f, 263.0f,    230.0f,  
										123.0f, 173.0f, 223.0f, 273.0f, 423.0f, 
										20.0f, 20.0f, 460.0f, 460.0f, 20.0, 
80.0, 150.0, 150.0, 150.0, 220.0, 220.0, 220.0, 290.0, 290.0, 290.0,   440.0,
80.0, 150.0, 150.0, 150.0, 220.0, 220.0, 220.0, 290.0, 290.0, 290.0,   440.0,
80.0, 150.0, 150.0, 150.0, 220.0, 220.0, 220.0, 290.0, 290.0, 290.0,   440.0,
										 };
// x coords when onscreen
static const float xs[NUM_BUTTONS] = {  160.0f, 100.0f, 74.0f, 100.0f, 
										130.0f, 96.0f,    160.0f, 
										100.0f, 74.0f, 74.0f, 74.0f, 74.0f, 
										25.0f, 295.0f, 25.0f, 295.0f, 190.0f , 
160.0f,   80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f,   160.0f,
160.0f,   80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f,   160.0f,
160.0f,   80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f, 80.0f, 160.0f, 240.0f,   160.0f,
										 };

// screen 1: title, select level, instructions, settings, credits at bottom
// screen 2: instructions placard and go back
// screen 4: level complete
// screen 5: select level, ez, med, hard
// screen 6: game screen, hands and feet in corners and a go back
// screen 7: select EZ: ez, 1,2,3,4,5,6,7,8,9
// screen 8: select med: med, 1,2,3,4,5,6,7,8,9
// screen 9: select hard: hard, 1,2,3,4,5,6,7,8,9



static const float tiles[NUM_BUTTONS] = { 0x40, 0x80, 0x90, 0xf2,
										0x0a, 0xe0, 
										0xf0, 
										0x80, 0xb0, 0xc0, 0xd0, 0xe0, 
										0x11, 0x13, 0x15, 0x24, 0xe0,
0xb0,  0x01, 0x02,   0x03, 0x04, 0x05,  0x06, 0x07, 0x08, 0x09, 0xe0, 
0xc0,  0x01, 0x02,   0x03, 0x04, 0x05,  0x06, 0x07, 0x08, 0x09, 0xe0, 
0xd0,  0x01, 0x02,   0x03, 0x04, 0x05,  0x06, 0x07, 0x08, 0x09, 0xe0, 
										};
static const int txsz[NUM_BUTTONS] ={ 6.0, 4.0, 2.0, 3.0,
										5.0, 2.0, 
										2.0, 
										4.0, 2.0, 2.0, 2.0, 2.0, 
										1.0, 1.0, 1.0, 1.0, 2.0,
2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 
2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 
2.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 
										};
static const int tysz[NUM_BUTTONS] = { 2.0, 1.0, 1.0, 1.0,
										5.0, 1.0,
										1.0, 
										1.0, 1.0, 1.0, 1.0, 1.0, 
										1.0, 1.0, 1.0, 1.0, 1.0,
1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 
1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 
1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 

										};

- (id)init {
	// Assign self to value returned by super's designated initializer
	// Designated initializer for NSObject is init
	if (self = [super init]) {
		int i;
		
		menuSpr = (sprite *)malloc(sizeof(sprite)*NUM_BUTTONS); 
				
		for (i=0; i<NUM_BUTTONS; ++i) { 
			sprSetPos(&(menuSpr[i]), xs[i]-400.0f, ys[i]); 
			sprSetRot(&(menuSpr[i]), 0.0f);
			sprSetSize(&(menuSpr[i]), 60.0*txsz[i], 60.0*tysz[i]); 
			sprSetMultiTile(&(menuSpr[i]), tiles[i], txsz[i], tysz[i]);
			
			sprVisible[i] = 1;
			gxs[i] = xs[i] - 400.0; // set "goal" x coord to all offscreen
			if (targetScreen[i]==1) { 
				gxs[i] = xs[i];
			}
		}
		
		sprSetRot(&(menuSpr[14]), 3.1415f); 
		sprSetRot(&(menuSpr[15]), 3.1415f); 
				
		theGame = [[gameObject alloc] init];
		[self changeScreen:1];
		
		
	}	
	return self;
}




// the per-frame routine does three things:
// 1) it moves buttons towards their goal positions, 
//      if they are not already there
// 2) it calls the update function for "theCreeps", so they can move.
//      if the game ends, then set screen state to be "game over"
// 3) draws the buttons

- (void)update {
	int i;
	
	[ theGame update ];
	 
	// then draw menu buttons in front!
	for (i=0; i<NUM_BUTTONS; ++i) { 
		// move out-of-place buttons
		if (menuSpr[i].cx>gxs[i]) { menuSpr[i].cx -= 20.0; }
		if (menuSpr[i].cx<gxs[i]) { menuSpr[i].cx += 20.0; }
		
		//if (sprVisible[i]==1) { 
			sprDraw(&(menuSpr[i])); 
		//}
	}

}



- (void)setAccel:(float *)a {
	[theGame setAccel:a];
	// NSLog(@"%f, %f", a[0], a[1]);

}



// 1:on 2:move 3:off 4:cancelled
- (void)touchEvent:(float*)ts:(int)nt:(int)evType {
	int i, isUsed, isWon;
	
	isUsed = 0; 
	
	// menu buttons jump when you release the button
	if ((nt>0)&&(evType==3)) { 
		gx = ts[0];
		gy = ts[1];
		
		for (i=0; i<NUM_BUTTONS; ++i) { 
			if (sprInside(&(menuSpr[i]), gx, gy)) {
				// click the button? 
				if (nextScreen[i]!=-1) { 
					[self changeScreen:nextScreen[i]]; 
				}
				// is there a message for the game? 
				if (gameMessage[i]!=0) { 
					[theGame takeMessage:(gameMessage[i])]; 
				}
				// are we a check mark? 
				if (i>18) {
					if (sprVisible[i]==1) { 
						sprVisible[i]=0;
					} else {
						sprVisible[i]=1;
					}
				}
				isUsed = 1; 
				
			}
		}
	}
	
	// the click was not on a button; send it to the game 
	if (isUsed==0) { 
		isWon = [theGame takeTouch:ts[0]:ts[1]];
		if (isWon==1) { 
			[self changeScreen:4]; // touched the goal!
		}
		
	}
}



- (void)changeScreen:(int)newState {
	int i;
	
	whichScreen = newState;
	for (i=0; i<NUM_BUTTONS; ++i) { 
		gxs[i] = -400.0;
		if (newState==targetScreen[i]) { 
			gxs[i] = xs[i];
		}
	}
}






- (void) dealloc
{
	free(menuSpr);
	
	[super dealloc];
}





@end





