//
//  timer.h
//  game02
//
//  Created by Neal McDonald on 1/15/10.
//  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sprite.h"

@interface timer : NSObject {
	sprite numerals[3]; // counts the number of switches made
	int counter, running, showing; 
}

- (void)startGame; 
- (void)stopGame; 
- (void)resumer; 
- (void)hideme; 


- (void)addOne; 
- (void)updater; 

@end

