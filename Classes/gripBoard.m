//
//  gripBoard.m
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import "gripBoard.h"


@implementation gripBoard


- (id)init {
	int i, j;
	
	if (self = [super init]) {
		sprSetSize(&targetSym, 45,45); 
		sprSetMultiTile(&targetSym, 0x30, 1, 1);
		sprSetRot(&targetSym, 0.0f); 
		
		sprSetSize(&flairSym, 45,45); 
		sprSetMultiTile(&flairSym, 0x34, 1, 1);
		sprSetRot(&flairSym, 0.0f); 
		
		sprSetSize(&flashSym, 45,45); 
		sprSetMultiTile(&flashSym, 0x16, 1, 1);
		sprSetRot(&flashSym, 0.0f); 
		turning = 0.0f;
		
		target = -1; 
		starterGrip = -1; 
		
		for (i=0; i<MAX_GRIPS; ++i) {
			j= random()%3;
			sprSetSize(&(grips[i]), 32, 32); 
			switch (j) {
				case 0: sprSetMultiTile(&(grips[i]), 0x20, 1, 1);break;
				case 1: sprSetMultiTile(&(grips[i]), 0x21, 1, 1);break;
				case 2: sprSetMultiTile(&(grips[i]), 0x31, 1, 1);break;
			}
		}
		[self initLevel: 5: 90.0]; 
		randomCounter = 0; 

		ox = 0.0f;
		oy = 0.0f;
		
	}	
	return self;
}


- (void) initLevel:(int)which:(float)mr { 
	maxReach = mr;
	switch (which) { 
		case 1: // init ez
			[self initBomb:320: 380: 8: 10: 0: 60]; 
			starterGrip = 50;
			break;
		case 2: // init med
			[self initBomb:320: 380: 6: 8: 0: 60]; 
			starterGrip = 30;
			break;
		case 3: // init hard
			[self initBomb:320: 380: 5: 7: 0: 60]; 
			starterGrip = 20;
			break;
		case 4: break; // resume; leave it all alone
		case 5: // init sell
			[self initBomb:160: 480: 5: 10: 140: 00]; 
			starterGrip = 17;
			break;
	}
}


- (void)initBomb:(int)w: (int)h: (int)cols: (int)rows: (int)xstart:(int)ystart {
	int i, j, k, useRows; 
	float dx, dy, px,py;
	
	useRows = rows; 
	if ((cols*rows)>MAX_GRIPS) { useRows = MAX_GRIPS/cols; }
	gripsUsed = cols* useRows;
	
	for (i=0; i<MAX_GRIPS; ++i) {
		sprSetPos(&(grips[i]), -100.0f, 0.0f); 
	}
	
	dx = w/cols; 
	dy = h/useRows;
	srandom(randomCounter); 
	// make the things to grab
	k=0;
	for (j=0; j<useRows; ++j) { 
		for (i=0; i<cols; ++i) {
			px = (i*dx) + (random()%((int)dx)) + xstart;
			py = (j*dy) + (random()%((int)dy)) + ystart;
			sprSetPos(&(grips[k]), px, py);
			sprSetRot(&(grips[k]), (6.28f*(float)(random()%1000))*0.001f);
			++k;
		}
	}
	gripsUsed = k;
		
	
	target = random()%(cols*2);
	sprSetPos(&targetSym, grips[target].cx, grips[target].cy); 
	sprSetPos(&flashSym, grips[target].cx, grips[target].cy); 
}


- (int) getFirstGrip {
	return starterGrip;
}


- (int) onGrip:(float)msx: (float)msy{
	int i, res;
	float dx, dy;
	res = -1;
	// is click on a grip?
	for (i=0; i<gripsUsed; ++i) { 
		dx = grips[i].cx - msx; 
		dy = grips[i].cy - msy; 
		if ((dx*dx+dy*dy)<160) {
			res = i;
		}
	}
	return res; 
}

- (float) gripX:(int)which {
	if (which<gripsUsed) { 
		return grips[which].cx;
	} else {
		return -100.0;
	}
}
- (float) gripY:(int)which {
	if (which<gripsUsed) { 
		return grips[which].cy;
	} else {
		return -100.0;
	}
}

- (bool) isTarget:(int)which {
	if (which==target) return YES;
	else return NO;
}


- (void) setOrigin:(float)px:(float)py{
	ox = px;
	oy = py;
}

- (void) update: (float)sx : (float)sy { 
	int i;
	float d, dx, dy; 

	turning +=0.015; 
	
	// recenter using origin
	for (i=0; i<gripsUsed; ++i) { 
		grips[i].sx -= ox; 
		grips[i].sy -= oy; 
		sprDraw(&(grips[i])); 
		grips[i].sx += ox; 
		grips[i].sy += oy; 
			
	}

	
	// draw target
	sprDraw(&targetSym);
	sprSetRot(&flashSym, turning); 
	sprDraw(&flashSym); 
	
	// draw grips!
	for (i=0; i<gripsUsed; ++i) { 
		sprDraw(&(grips[i])); 
		
		dx = sx- grips[i].cx - ox;
		dy = sy- grips[i].cy - oy;
		d = dx*dx+dy*dy;
		if (d<maxReach*maxReach) { 
			sprSetPos(&flairSym, grips[i].cx, grips[i].cy); 
			sprDraw(&flairSym); 
		}
	}
}


- (void) dealloc
{	
	[super dealloc];
}



@end
