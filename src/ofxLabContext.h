#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxJSONElement.h"

//#include "ofUtils.h"

#include "ofxEstimote.h"
//#include "ofxHttpUtils.h"
#include "labBeacon.h"

//#include "estimoteTest.h"

#include "Poco/String.h"

class ofxLabContext : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        //ofxHttpUtils httpUtils;
        //ofUtils utils;
    
        //void newResponse(ofxHttpResponse & response);

        bool getBeaconInfo(int _beaconIndex);
    
        ofxEstimote* estimote;

        ofVec2f origin;
        int beaconRadius;
        float distanceRange;
    
        //vector<labBeacon> arrLabBeacons;
        Boolean isConnected = false;
    
        ofxJSONElement json;
    
        map<string,labBeacon> arrContextBeacons;

};


