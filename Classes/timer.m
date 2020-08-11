//
//  timer.m
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//

#import "timer.h"


@implementation timer
		
- (id)init {
	int i; 
	if (self = [super init]) {
		for (i=0; i<3; ++i) { 
			sprSetSize(&(numerals[i]), 24, 24); 
			sprSetTile(&(numerals[i]), i);
			sprSetRot(&(numerals[i]), 0.0f);
			sprSetPos(&(numerals[i]), 110-(i*22), 20.0); 
		}
		counter =0;
			
	}
	return self;
}


	
- (void) startGame {
	counter = 0; 
	running = 1; 
}
- (void) stopGame {
	running = 0; 
}
- (void) resumer {
	running = 1;  
}
- (void) hideme {
	showing = 0; 
}
- (void) addOne {
	++counter; 
}



- (void)updater {
	int i, time, m10s, m1s, s10s, s1s; 	
	
	if (running==1) {
		time = counter;
		s1s = time%10; // second ones
		s10s = time%60; // second tens
		s10s = (int)(floor(s10s/10)); 
		
		time = (int)(floor(time/60));
		m1s = time%10; 
		m10s = (int)(floor(time/10)); 
		m10s = m10s%10; 
		
		sprSetTile(&(numerals[0]), s1s);
		sprSetTile(&(numerals[1]), s10s);
		sprSetTile(&(numerals[2]), m1s);
		for (i=0; i<3; ++i) { 
			sprDraw(&(numerals[i]));
		}
	} 
}	




- (void) dealloc {
	[super dealloc];
}




@end
 

