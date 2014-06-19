//
//  labBeacon.cpp
//  ofxLabContext
//
//  Created by Adam Lassy on 6/16/14.
//
//

#include "labBeacon.h"


labBeacon::labBeacon(string _uuid, string _name, string _desc, bool _ignore)
{
    uuid = _uuid;
    name = _name;
    desc = _desc;
    ignore = _ignore;
}

labBeacon::labBeacon()
{
    
}

labBeacon::~labBeacon()
{
    
}

/*
bool labBeacon::updateInfo()
{
    string url = "http://lab.madsci1.havasworldwide.com/context/" + uuid;

	// Now parse the JSON
	bool parsingSuccessful = json.open(url);
	if (parsingSuccessful) {
		cout << json.getRawString(true) << endl;
        
        //cout << "1" << endl;
        //cout << json["fields"];
        
        cout << "2" << endl;
        cout << json[0]["fields"];
        
        this->name = ofToString(json[0]["fields"]["name"]);
        this->desc = ofToString(json[0]["fields"]["description"]);

	} else {
		cout  << "Failed to parse JSON" << endl;
	}

    return false;
}
*/