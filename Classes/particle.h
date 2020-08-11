/*
 *  particle.h
 *  game02
 *
 *  Created by Neal McDonald on 1/15/10.
 *  Copyright 2010 University of Maryland, Baltimore County. All rights reserved.
 *
 */

typedef struct {
	float posx, posy, velx, vely, accx, accy, forx, fory, mass;
} particle;
 
static inline void ptInit(particle *it, float xIn, float yIn) {
	it->posx = xIn; 
	it->posy = yIn; 
	it->velx = 0.0f;
 	it->vely = 0.0f;
 	it->accx = 0.0f;
 	it->accy = 0.0f;
 	it->forx = 0.0f;
 	it->fory = 0.0f;
 	it->mass = 1.0f;
 }
  
static inline void ptUpdate(particle *p, float dt) {
	p->accx = (p->forx / p->mass) * dt;
	p->accy = (p->fory / p->mass) * dt;
	
	p->velx += p->accx*dt;	
	p->vely += p->accy*dt;
	
	p->posx += p->velx*dt;
	p->posy += p->vely*dt;
	
	p->forx = 0.0f;
	p->fory = 0.0f;
} 



//////////////////////////////////////////// using sprites

#include "sprite.h"

// draw sprite where pt is-- do not rotate
static inline void ptSprite(particle *p, sprite *s) {
	sprSetPos(s, p->posx, p->posy); 
	sprDraw(s); 
}


// draw sprite and rotate to match direction
static inline void ptDirectionalSprite(particle *p, sprite *s) {
	float dx, dy, len, angle;
	
 	dx = p->velx;
	dy = p->vely;
	len = (float)sqrt(dx*dx+dy*dy); 
	if (len<0.001f) { 
		angle = (float)acos(dx/len);
		if (dy<0.0) { angle = 6.2831853f-angle; } // remember: y pointing down
		angle += 1.5707963;
		sprSetRot(s, angle); 
	} // if the thing isn't moving, don't change its angle. 
	
	sprSetPos(s, p->posx, p->posy); 
	sprDraw(s); 
}


// draw sprite connecting two particles
static inline void ptConnector(particle *a, particle *b, sprite *s, float width) {
	sprSetConnector(s, a->posx, a->posy, b->posx, b->posy, width); 
	sprDraw(s); 
}	





///////////////////////////////////////////// springs
	
typedef struct {
	float restLen, currentLen, k, minRest, maxRest, relaxedRest;
	particle *body1, *body2; 
} spring;



static inline float sprGetDx(spring *it) {
	return (it->body1->posx - it->body2->posx);
}

static inline float sprGetDy(spring *it) {
	return (it->body1->posy - it->body2->posy);
}

static inline float sprDist(spring *it) {
	float dx, dy;
	
	dx = sprGetDx(it);
	dy = sprGetDy(it);
	return (float)sqrt(dx*dx+dy*dy);
}


static inline void sprInit(spring *it, particle *b1, particle *b2, float restMult, float kIn) {
	it->body1 = b1; 
	it->body2 = b2; 
	it->restLen = sprDist(it) * restMult; 
	it->minRest = it->restLen * 0.5f;
	it->maxRest = it->restLen * 1.5f;
	it->relaxedRest = it->restLen;
	it->k = kIn;
}
		
static inline void sprChangeLen(spring *it, float del) {
	float nrl = it->restLen * del;
	if (nrl<it->minRest) { nrl = it->minRest; }
	if (nrl>it->maxRest) { nrl = it->maxRest; }
	it->restLen = nrl;
}
		
static inline void sprExert(spring *it) {
	float dx, dy, currentLen, f; 
			
	currentLen = sprDist(it);
	f = it->k * (currentLen - it->restLen); 
	dx = sprGetDx(it)/currentLen;
	dy = sprGetDy(it)/currentLen;

	it->body1->forx -= f*dx;
	it->body1->fory -= f*dy;
	it->body2->forx += f*dx;
	it->body2->fory += f*dy;
	// trace(f); 
			
	// if flexed, gradually ease
	if (it->restLen<(it->relaxedRest-0.01f)) { it->restLen += 0.08f; }
	if (it->restLen>(it->relaxedRest+0.01f)) { it->restLen -= 0.08f; }
}




// draw sprite connecting the particles of the spring
static inline void sprSprite(spring *sg, sprite *st, float width) {
	sprSetConnector(st, sg->body1->posx, sg->body1->posy, sg->body2->posx, sg->body2->posy, width); 
	sprDraw(st); 
}	



// draw sprite connecting the particles of the spring-- set width inverse to stretch
static inline void sprSpringy(spring *sg, sprite *st, float width) {
	float dw = width * (sprDist(sg) / sg->restLen); 
	sprSetConnector(st, sg->body1->posx, sg->body1->posy, sg->body2->posx, sg->body2->posy, dw); 
	sprDraw(st); 
}






/////////////////////////////////////// rivets
typedef struct {
	float px, py;
	particle *body; 
} rivet;

static inline void rivInit(rivet *it, particle *b1, float npx, float npy) {
	it->body = b1; 
	it->px = npx; 
	it->py = npy;
}


static inline void rivExert(rivet *it) {
	it->body->forx = 0.0f;
	it->body->fory = 0.0f;
	it->body->accx = 0.0f;
	it->body->accy = 0.0f;
	it->body->velx = 0.0f;
	it->body->vely = 0.0f;
	it->body->posx = it->px;
	it->body->posy = it->py;
}



/////////////////////////////////////// friction
typedef struct {
	float mag;
} friction;

static inline void frkInit(friction *it, float m) {
	it->mag = m; 
}

static inline void frkExert(friction *it, particle *p) {
	p->velx *= it->mag;
	p->vely *= it->mag;
}



/////////////////////////////////////// gravity
typedef struct {
	float gx, gy;
} gravity;

static inline void gravInit(gravity *it, float mx, float my) {
	it->gx = mx; 
	it->gy = my; 
}

static inline void gravExert(gravity *it, particle *p) {
	p->forx += it->gx * p->mass;
	p->fory += it->gy * p->mass;
}



