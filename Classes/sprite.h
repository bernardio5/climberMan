/*
 *  sprite.h
 *  GLSprite
 *
 *  Created by Neal McDonald on 1/13/10.
 *
 
 Sprites are length-2 rectangular triangle strips. 
 they are textured from a tile-set image
 
 the tile set is a single image-- only one allowed for all sprites
 the tile set is a grid of 16x16 images
 
 it doesn't matter how big the tiles are in pixels. I've used 16 and 8.
 They do have to be square and a power of 2: 2, 4, 8, 16, 32.
 16 gives 1024x1024, which causes a loading delay on a 3GS.
 8 is very speedy, but there is a tiny bit of blur. 
 2,4,and bigger than 16 are plumb crazy. 
 
 
 tiles are numbered from top left, going first right, then down-- as english text
 first one is tile 0. I tend to use hex tile numbering because I'm a dick. 
 
 
 Tile position is at its center. 
 Tiles rotate about their centers-- the center is the pivot
 
 if you don't like that, use a big tile with transparency and an off-center graphic 
 Rotations are in radians
 

 Coordinates are screen coords, top left is the origin, and down is +y.
 
 
 To switch to a side view, rotate your tiles and pretend. 
 
 
 
 
 
 *
 */


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


// set to 0 to rotate all tiles 90 degrees
#define VERTICAL_LAYOUT 1


typedef struct { 
	float cx, cy, sx, sy;		/* position and size */
	float r;					/* rotation */
	float t1x, t1y, t2x, t2y;	/* texture coords: top left, bottom right */
} sprite; 





/* setting */
static inline void sprSet(sprite *s, float x, float y, float szx, float szy, float r) {
	s->cx = x; 
	s->cy = y;
	s->sx = szx;
	s->sy = szy; 
	s->r = r;
}

static inline void sprSetPos(sprite *s, float x, float y) {
	s->cx = x; 
	s->cy = y;
}

static inline void sprSetRot(sprite *s, float x) {
	s->r = x;
}

static inline float sprGetCenterX(sprite *s) { 
	return s->cx;
}

static inline float sprGetCenterY(sprite *s) { 
	return s->cy;
}

static inline void sprSetSize(sprite *s, float x, float y) {
	s->sx = x*0.5f; 
	s->sy = y*0.5f;
}


// set so middle of tile is at x1y2, and top of tile is at x2y2
static inline void sprSetConnector(sprite *s, float width, float x1, float y1, float x2, float y2) {
	float dx, dy, len, angle;
	
 	dx = x2-x1;
	dy = y2-y1;
	len = (float)sqrt(dx*dx+dy*dy); 
	angle = (float)acos(dx/len);
	if (dy<0.0) { angle = 6.2831853f-angle; } // remember: y pointing down
	angle += 1.5707963;
	
	s->cx = x1 + (dx*0.5); 
	s->cy = y1 + (dy*0.5);
	s->sx = width*0.5f; 
	s->sy = len * 0.5;
	s->r = angle; 
}	



/* set the sprite to use one tile of the tile set */
static inline void sprSetTile(sprite *s, int which) {
	int col = which%16;
	int row = (which-col)/16;
	s->t1x = 0.0625f * col;
	s->t2x = s->t1x + 0.0625f;
	s->t1y = 0.0625f * row;
	s->t2y = s->t1y + 0.0625f;
}

/* set the sprite to cover multiple tiles, no bounds checking, babe. */
static inline void sprSetMultiTile(sprite *s, int which, int dx, int dy) {
	sprSetTile(s, which); 
	s->t2x += 0.0625 * (dx-1); 
	s->t2y += 0.0625 * (dy-1); 
}






/* ************************ buttony */
#if VERTICAL_LAYOUT
static inline bool sprInside(sprite *s, float px, float py) {
	if (px<((s->cx)-(s->sx))) { return NO; }
	if (py<((s->cy)-(s->sy))) { return NO; }
	if (px>((s->cx)+(s->sx))) { return NO; }
	if (py>((s->cy)+(s->sy))) { return NO; }
	return YES; 
}

#else
static inline bool sprInside(sprite *s, float px, float py) {
	if (py<((s->cx)-(s->sx))) { return NO; }
	if (py<((s->cy)-(s->sy))) { return NO; }
	if (px>((s->cx)+(s->sx))) { return NO; }
	if (px>((s->cy)+(s->sy))) { return NO; }
	return YES; 
}

#endif	





/* ********************** drawing */

static inline void sprDraw(sprite *s) {
	float p[8], t[8], sn, cs, nx, ny; 
	int i;
	
	p[0] = -s->sx; 
	p[1] = -s->sy; 
	
	p[2] =  s->sx; 
	p[3] = -s->sy; 
	
	p[4] = -s->sx; 
	p[5] =  s->sy; 
	
	p[6] =  s->sx; 
	p[7] =  s->sy; 
	
	t[0] = s->t1x; 
	t[1] = s->t1y; 
	
	t[2] = s->t2x; 
	t[3] = s->t1y; 
	
	t[4] = s->t1x; 
	t[5] = s->t2y; 
	
	t[6] = s->t2x; 
	t[7] = s->t2y; 
	/*
	 for (i=0; i<16; ++i) { 
	 m[i] = 0.0f;
	 }
	 
	 m[3] = s->cx;
	 m[7] = s->cy;
	 
	 m[0] = cs;
	 m[1] = -sn;
	 m[4] = sn;
	 m[5] = cs;
	 
	 m[10] = m[15] = 1.0f;
	 */
#if VERTICAL_LAYOUT
	sn = (float)sin(s->r); 
	cs = (float)cos(s->r); 
#else
	sn = (float)sin(s->r+ 1.57079); 
	cs = (float)cos(s->r+ 1.57079); 
#endif	
	for (i=0; i<7; i+=2) { 
		nx = (cs*p[i])-(sn*p[i+1])+(s->cx);
		ny = (sn*p[i])+(cs*p[i+1])+(s->cy);
		p[i] = nx;
		p[i+1] = ny;
	}
	
	glVertexPointer(2, GL_FLOAT, 0, p);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, t);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//glPushMatrix();
	//glTranslatef(s->cx, s->cy, 0.0f); 
	//glRotatef(s->r, 0.0f,0.0f,1.0f);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	//glPopMatrix();
	
}





