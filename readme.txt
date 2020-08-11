

steps

1) make the standard Apple OGL project

2) Delete ES1Renderer.h/.m, ES2...h/.m, ESRenderer.h, and the shaders

3) Cpy in content of GLSprite's EAGLView.h/.m (completely) and GLSpriteAppDelegate.h/.m
 (being careful to preserve your project's name)
 
4) Add the CoreGraphics framework
	Right-click the frameworks folder
	"add Existing Framework.."
	/Developer/Platforms/iPhoneOS.../Developer/SDKs/iPhoneOS3.1.2.sdk/System/Library/Frameworks/.
	
5) mainWindow.xib should be fine.  
	