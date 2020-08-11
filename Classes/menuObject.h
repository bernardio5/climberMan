//
//  menuObject.h
//  game02
//
//  Created by Neal McDonald on 1/14/10.
// 
//
#import "sprite.h"

#import "gameObject.h"

/* max # simultaneous touches. */ 
#define MAX_TOUCHES 4


/* the menu object owns the actual game and takes care of it
	it also provides a mechanism for making screenfuls of menu buttons 
 that you can click to run the game, select game settings, get instructions
 there's also a pause menu. 
 
	the game object must implement certain functions, 
	but, beyond that, it can be whatever. 
 
	game and menu share one sprite sheet-- there's no mechanism 
 for swapping tile sets. 
 
	the menu takes messages from the EAGL view: touches, accelerometer
    it passes them on through to the game, but it also is always looking for 
	touch-end events, which will trigger buttons if they're over them. 
 
 
 knock yourself out, kid. 

 */ 

// number of menu buttons on all screens
#define NUM_BUTTONS 51


@interface menuObject : NSObject {
	sprite *menuSpr;		// all the menu sprites
	int sprVisible[NUM_BUTTONS];
	int whichScreen;		// current screen number
	float gxs[NUM_BUTTONS]; // target positions of the current menu screen
	
	float acc[3];			// current accelerometer readings

	float gx, gy;			// temp
	
	
	gameObject *theGame;
	
	
}

// set current menu to "toWhat". buttons will be offscreen, 
// but "update" soon will move them into place. 
 - (void) changeScreen:(int)toWhat; 

// init is already declared

- (void)update; // draw to active EAGL view; update game state

/// input
- (void)setAccel:(float*)ac; // an array of 3 floats: xyz accelerometer readings

// event types: 1:begin touch, 2:move touch 3:end touch 4:cancel touch(?)
- (void)touchEvent:(float*)ts:(int)nt:(int)evType;



@end
