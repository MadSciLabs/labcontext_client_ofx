#include "ofMain.h"
#include "ofxLabContext.h"

int main(){
    
	//ofSetupOpenGL(1024,768,OF_FULLSCREEN);			// <-------- setup the GL context
	//ofRunApp(new ofApp());
    
    ofAppiOSWindow * iOSWindow = new ofAppiOSWindow();
    //iOSWindow->enableRendererES2();
    iOSWindow->enableDepthBuffer();
    iOSWindow->enableAntiAliasing(4);
    //if(iOSWindow->isRetinaSupportedOnDevice()) iOSWindow->enableRetina();
    //iOSWindow->enableHardwareOrientation();

    ofSetupOpenGL(iOSWindow, 1024, 768, OF_FULLSCREEN);
    ofRunApp(new ofxLabContext);
}
