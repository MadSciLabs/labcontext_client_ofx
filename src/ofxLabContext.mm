#include "ofxLabContext.h"

// Visual helpers (not required).
// Change below to match your beacon/colours- otherwise they will appear white. id's are beacon's major id.
const int ids[3] = {32492, 42365, 40448};

// blue, purple, green (color of estimotes associated with major ids)
const ofColor colors[3] = {ofColor(0,127,255), ofColor(127,0,255), ofColor(127,255,127)};



ofColor getColor(int majorId) {
    for(int i = 0; i < 3; i++) if(majorId == ids[i]) return(colors[i]);
    return ofColor();
}

// tested on ipad - enable retina in main.mm if working on iphone
//--------------------------------------------------------------
void ofxLabContext::setup(){

    //ofSetFrameRate(60);
    ofSetVerticalSync(true);
    ofEnableAlphaBlending();
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    estimote = new ofxEstimote();
    estimote->setup();

    
    // display options
    origin.set(ofGetWidth()*.5, 150); // the device origin
    distanceRange = 15.0; // meters?
    beaconRadius = 20;
    
    ofLog(OF_LOG_NOTICE, "> START");
}

//--------------------------------------------------------------
void ofxLabContext::update(){

    //int t;
    //Boolean isFound = false;
    //Boolean b;
    //string _uuid;
    //labBeacon _labBeacon;
    
/*
    vector<ofxEstimoteData>& beacons = estimote->getBeaconsRef();
    //vector<estimoteTest> beacons;
    //beacons.push_back(estimoteTest(1,"34","12"));
    
    //Check each viewable beacon against our array to see if we
    // need to hit up the API to populate it
    for(int i = 0; i < beacons.size(); i++) {
        
        isFound = false;
        _uuid = "";
        
        _uuid.append(ofToString(beacons[i].major));
        _uuid.append(ofToString(beacons[i].minor));
        
        //ofLog(OF_LOG_NOTICE, "Index : " + ofToString(i));

        // draw the beacons in advertising mode whose rssi signal is not 0
        // a filled coloured circle represents the beacon, outline represents the raw rssi signal
        if(beacons[i].rssi != 0) {

            for (int j=0; j<arrLabBeacons.size(); j++) {

                
                //t = ofGetDay();
                
                if ( ofIsStringInString(arrLabBeacons[j].uuid, _uuid))
                {
                    isFound = true;
                }
            }
            
            if (!isFound) {
                ofLog(OF_LOG_NOTICE, "not found");
                ofLog(OF_LOG_NOTICE, _uuid);
                
                //push to Vector
                ofLog(OF_LOG_NOTICE, ofToString(arrLabBeacons.size()));
                
                _labBeacon = labBeacon(_uuid, "name", "desc");
                _labBeacon.updateInfo();

                arrLabBeacons.push_back(_labBeacon);
            }
        }
    }
*/
    
}

// displaying the beacons in a linear 1D proximity map
//--------------------------------------------------------------
void ofxLabContext::draw(){
    
    
    // draw a label which has the range in meters + line
    ofSetColor(0, 50);
    ofLine(origin.x, origin.y, origin.x, ofGetHeight()-origin.y);
    //ofDrawBitmapStringHighlight(ofToString(distanceRange) + " meters or so?", int(origin.x)-50, int(ofGetHeight() - origin.y));
    ofSetColor(0);
    
    // draw the beacons relative to a device/origin - grey rectangle
    ofPushMatrix();
    ofPushStyle();
    ofSetColor(50);
    float s = 50;
    ofTranslate(int(origin.x-(s*.5)), int(origin.y-(s*.5)));
    ofRect(0,0, s, s);
    //ofDrawBitmapStringHighlight("iDevice", 5, 5);//, ofColor(255,0,255));
    ofPopStyle();
    ofPopMatrix();

    string _uuid;
    labBeacon _beacon;
    
    stringstream _beaconList;
    _beaconList << "LAB CONTEXTUAL INTERFACES" << endl;
    _beaconList << endl;
    
    vector<ofxEstimoteData>& beacons = estimote->getBeaconsRef();
    for(int i = 0; i < beacons.size(); i++) {
        
        // draw the beacons in advertising mode whose rssi signal is not 0
        // a filled coloured circle represents the beacon, outline represents the raw rssi signal
        if(!estimote->isBeaconActivated() && !beacons[i].connectivityMode && beacons[i].rssi != 0) {
            
            _uuid = "";
            _uuid.append(ofToString(beacons[i].major));
            _uuid.append(ofToString(beacons[i].minor));

            //If we have this beacon
           _beacon = arrContextBeacons[_uuid];

            if (_beacon.uuid == "")
            {
                cout  << "Can't find uuid : " << _uuid << endl;
                string url = "http://lab.madsci1.havasworldwide.com/context/" + _uuid;
                
                // Now parse the JSON
                bool parsingSuccessful = json.open(url);
                if (parsingSuccessful) {
                    
                    cout << "Parsed JSON" << endl;
                    cout << ">" << ofToString(json[0]["fields"]["name"]) << "<" << endl;
                    
                    //cout << ofToString(json[0]["fields"]["name"]) << endl;
                    
                    if (!ofIsStringInString( ofToString(json[0]["fields"]), "null" ))
                    {
                        _beacon = labBeacon(_uuid, ofToString(json[0]["fields"]["name"]), ofToString(json[0]["fields"]["description"]), false);
                    } else {
                        cout << "NULL" << endl;
                        _beacon =  labBeacon(_uuid,"","",true);
                    }
                } else {
                    
                    cout  << "Failed to parse JSON" << endl;
                    _beacon =  labBeacon(_uuid,"","",true);
                }
                arrContextBeacons[_uuid] = _beacon;
            }
            
            //If we show this
            if (!_beacon.ignore)
            {
                //cout  << "No ignore" << endl;

                beacons[i].contextName = _beacon.name;
                beacons[i].contextDesc = _beacon.desc;

                _beaconList << "> " << ofToString(beacons[i].contextName) << " (dist: " << ofToString(beacons[i].distance) << ")" << endl;
                
                    float nDistance = beacons[i].distance / distanceRange; //
                float posY = posY = ofMap(nDistance, 0.0, 1.0, origin.y, ofGetHeight()-origin.y);
                    ofPushMatrix();
                    ofPushStyle();
                    ofTranslate(int(origin.x), int(posY));
                    ofNoFill();
                    ofSetColor(255,100);
                    ofCircle(0, 0, ofMap(beacons[i].rssi, -30, -100, 200, 25)); // -30 = close/larger, -100 = far/smaller
                    ofFill();
                    ofSetColor(getColor(beacons[i].major)); // get beacon color from major id
                    ofCircle(0, 0, beaconRadius);
                    ofSetColor(0);
                    ofDrawBitmapString(estimote->beaconDataToString(beacons[i]), 5, 5);// draw the beacons info
                    ofPopStyle();
                    ofPopMatrix();
            }
        }
    }

    // draw the single beacon in connectivity mode if activated, in top left somewhere
    if(estimote->isBeaconActivated()) {
        ofxEstimoteData& activatedBeacon = estimote->getActivatedBeacon();
        if(activatedBeacon.connectivityMode) {
            
            //If we have this beacon
            _beacon = arrContextBeacons[ofToString(activatedBeacon.major)+ofToString(activatedBeacon.minor)];
            activatedBeacon.contextName = _beacon.name;
            activatedBeacon.contextDesc = _beacon.desc;
            
            ofPushMatrix();
            ofPushStyle();
            ofTranslate(20, 100);
            ofColor beaconClr = getColor(activatedBeacon.major);
            //ofDrawBitmapStringHighlight(activatedBeacon.contextName + "\n" + estimote->beaconDataToString(activatedBeacon), 5, 5, beaconClr, ofColor::black);
            ofDrawBitmapStringHighlight(activatedBeacon.contextName + "\n" + activatedBeacon.contextDesc + "\n\n" + "connect" + "\n\n" + "cancel", 5, 5, beaconClr, ofColor::black);
            ofPopStyle();
            ofPopMatrix();
        }
    }

/*
    vector<ofxEstimoteData>& beacons = estimote->getBeaconsRef();
    if (isConnected)
    {
    
        for(int i = 0; i < beacons.size(); i++) {
        
        // draw the beacons in advertising mode whose rssi signal is not 0
        // a filled coloured circle represents the beacon, outline represents the raw rssi signal
        if(!beacons[i].connectivityMode && beacons[i].rssi != 0) {
            
            //See if this beacon exists in the array ... else get it
            
            
            float nDistance = beacons[i].distance / distanceRange; //
            float posY = ofMap(nDistance, 0.0, 1.0, origin.y, ofGetHeight()-origin.y);
            ofPushMatrix();
            ofPushStyle();
            ofTranslate(int(origin.x), int(posY));
            ofNoFill();
            ofSetColor(255,100);
            ofCircle(0, 0, ofMap(beacons[i].rssi, -30, -100, 200, 25)); // -30 = close/larger, -100 = far/smaller
            ofFill();
            ofSetColor(getColor(beacons[i].major)); // get beacon color from major id
            ofCircle(0, 0, beaconRadius);
            ofSetColor(0);
            ofDrawBitmapString(estimote->beaconDataToString(beacons[i]), 5, 5);// draw the beacons info
            ofPopStyle();
            ofPopMatrix();
        }

        }
    
    } else {
        
        // draw the single beacon in connectivity mode if activated, in top left somewhere
        if(estimote->isBeaconActivated()) {
        ofxEstimoteData& activatedBeacon = estimote->getActivatedBeacon();
        if(activatedBeacon.connectivityMode) {
            ofPushMatrix();
            ofPushStyle();
            ofTranslate(20, 100);
            ofColor beaconClr = getColor(activatedBeacon.major);
            ofDrawBitmapStringHighlight("CONNECTIVITY MODE ACTIVATED FOR BEACON:\n" + estimote->beaconDataToString(activatedBeacon), 5, 5, beaconClr, ofColor::black);
            ofPopStyle();
            ofPopMatrix();
            }
        }

	}
*/

    stringstream info;
    info << "LAB CONTEXTUAL INTERFACES_________________________" << endl;
    info << endl;
    info << "> Beacons detected: " << beacons.size() << endl;
    
    ofDrawBitmapStringHighlight(_beaconList.str(), 20, 20);
}

//--------------------------------------------------------------
void ofxLabContext::exit(){

}

//--------------------------------------------------------------
void ofxLabContext::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofxLabContext::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofxLabContext::touchUp(ofTouchEventArgs & touch){

    
    vector<ofxEstimoteData>& beacons = estimote->getBeaconsRef();
    for (int i = 0; i < beacons.size(); i++) {
        
        float nDistance = beacons[i].distance / distanceRange; //
        float posY = ofMap(nDistance, 0.0, 1.0, origin.y, ofGetHeight()-origin.y);
        float posX = origin.x;
        
        if(touch.x > posX - beaconRadius && touch.x < posX + beaconRadius && touch.y > posY - beaconRadius && touch.y < posY + beaconRadius) {
            // touched- set this beacon to connectivity mode
            ofLog() << "Touched beacon " <<  beacons[i].major;
            estimote->enableBeaconConnectivityMode(beacons[i].major, beacons[i].minor);
        }
    }
    
    
    
}

//--------------------------------------------------------------
void ofxLabContext::touchDoubleTap(ofTouchEventArgs & touch){

    // disconnect the active beacon and set back to default advertising mode
    estimote->disableBeaconConnectivityMode();
}

//--------------------------------------------------------------
void ofxLabContext::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofxLabContext::lostFocus(){

}

//--------------------------------------------------------------
void ofxLabContext::gotFocus(){

}

//--------------------------------------------------------------
void ofxLabContext::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofxLabContext::deviceOrientationChanged(int newOrientation){

}

/*
void ofxLabContext::newResponse(ofxHttpResponse & response){
	ofToString(response.status) + ": " + (string)response.responseBody;
}
*/

/*
bool ofxLabContext::getBeaconInfo(ofxEstimoteData::beacon _beacon)
{
    string _uuid = "";
    _uuid.append(ofToString(ofxEstimoteData::beacon[_beaconIndex].major));
    _uuid.append(ofToString(beacons[_beaconIndex].minor));
    
    string url = "http://lab.madsci1.havasworldwide.com/context/" + _uuid;
    
	// Now parse the JSON
	bool parsingSuccessful = json.open(url);
	if (parsingSuccessful) {
		cout << json.getRawString(true) << endl;
        
        //cout << "1" << endl;
        //cout << json["fields"];
        
        cout << "2" << endl;
        cout << json[0]["fields"];
        
	} else {
		cout  << "Failed to parse JSON" << endl;
        return false;
	}
}
*/

