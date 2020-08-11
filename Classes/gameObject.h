//
//  gameObject.h
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//    
/*
 This contains the climbing game. It implements the interface expected by the menuObject

 The game itself doesn't draw anything; it mostly just switches messages and calls
 owned-object updaters
 

game modes: 
0: sell screen. take no input. run physics. 
init to narrow band of grips, put climber on grips, maybe have him fool around
entry from start or from exiting a level
1: playing: take input, run physics
entry from start-level: init grips according to difficulty settings
entry from pause menu: change nothing, 
2: paused: no input, no physics. 
entry from game play; change nothing
3: victory mode: no input, yes physics
don't reset the board just yet, but stop play.
let the user see the win, \
 
 init into sell screen mode
 
 
*/

#import <Foundation/Foundation.h>

#import "sprite.h"
#import "gripBoard.h"
#import "timer.h"
#import "person.h"

@interface gameObject : NSObject {
	gripBoard *gripBr; 
	person *user;
	timer *theTimer;
	int gameMode;	
	int settings[4]; //  on/off: 0:music1:the freedom 2:gravity 3:peace
	float maxReach; // 90=too easy-- use to set difficulty
	
	
}

// operate game and redraw visual elements
- (void)update;

// many messages; see menuObject.m for the list
- (void)takeMessage:(int)which;


// returns 1 if you've hit the target
- (int)takeTouch:(float)tx:(float)ty;


- (void)setAccel:(float*)a;

@end
