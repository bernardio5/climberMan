![Climberman App Store image](AppStore.png?raw=true "Title")

This is a game I used as a template when I was teaching game development at UMBC. 
It was used by at least two student projects to make games that appeared on the App Store. 
This game was on the App store for a few years, and made dozens of dollars for me. 

Using this repo to make an iOS game: 

1) make the standard Apple OGL project
2) Delete ES1Renderer.h/.m, ES2...h/.m, ESRenderer.h, and the shaders
3) Copy in content of GLSprite's EAGLView.h/.m (completely) and GLSpriteAppDelegate.h/.m
 (being careful to preserve your project's name)
4) Add the CoreGraphics framework
	Right-click the frameworks folder
	"add Existing Framework.."
	/Developer/Platforms/iPhoneOS.../Developer/SDKs/iPhoneOS3.1.2.sdk/System/Library/Frameworks/.
5) mainWindow.xib should be fine.  

That's right: iPhoneOS3.1.2: I've been doing this a while. 
