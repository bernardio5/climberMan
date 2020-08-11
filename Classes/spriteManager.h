/*
 *  spriteManager.h
 *  game02
 *
 *  Created by Neal McDonald on 1/18/10.
 *  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
 *
 */


#include "sprite.h" 

typedef struct {
	int texture; 
	
	sprite *allSprites;
} spriteManager;



int makeSprite(); 

void moveSprite(int whichSprite, float x, float y); 
void setTile(int whichSprite, int whichTile);