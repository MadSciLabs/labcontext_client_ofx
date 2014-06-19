//
//  labBeacon.h
//  ofxLabContext
//
//  Created by Adam Lassy on 6/16/14.
//
//

//#ifndef __ofxLabContext__labBeacon__
//#define __ofxLabContext__labBeacon__

#include <iostream>
#include "ofMain.h"
//#include "ofxJSONElement.h"


class labBeacon {
    
public:
    
    string uuid;
    string name;
    string desc;
    string color;
    bool ignore;
    
    ~labBeacon();
    labBeacon();
    labBeacon(string _uuid, string _name, string _desc, bool _ignore);
    
    bool updateInfo();
    
    //ofxJSONElement json;
    
};

//#endif /* defined(__ofxLabContext__labBeacon__) */
