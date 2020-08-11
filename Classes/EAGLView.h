//
//  EAGLView.h
//  game02
//
//  Created by Neal McDonald on 1/14/10.
//  Copyright University of Maryland, Baltimore County 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "menuObject.h" 

@interface EAGLView : UIView
{
@private
	
	/* The pixel dimensions of the backbuffer */
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint viewRenderbuffer, viewFramebuffer;
	
	/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
	GLuint depthRenderbuffer;
	
	/* OpenGL name for the sprite texture */
	GLuint spriteTexture;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	// Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id displayLink;
    NSTimer *animationTimer;	
	
	
	menuObject *menuAndGame;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;


- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;
- (void)setupView;




- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
- (void)setAccel:(float*)ac;
- (void)doTouch:(NSSet *)touches withEvent:(UIEvent *)event:(int)whichEvt;
@end
