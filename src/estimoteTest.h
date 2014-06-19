//
//  estimoteTest.h
//  ofxLabContext
//
//  Created by Adam Lassy on 6/17/14.
//
//

#ifndef ofxLabContext_estimoteTest_h
#define ofxLabContext_estimoteTest_h

#include <iostream>
#include "ofMain.h"

class estimoteTest {
    
public:
    
    int rssi;
    string minor;
    string major;
    
    ~estimoteTest();
    estimoteTest();
    estimoteTest(int _rssi, string _minor, string _major);
    
};


#endif
