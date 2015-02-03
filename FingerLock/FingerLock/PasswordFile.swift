//
//  PasswordFile.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class PasswordFile: NSObject {
    var title = ""
    var username = ""
    var password  = ""
    var website = ""
    var notes = ""
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("Title") as String
        username = aDecoder.decodeObjectForKey("Username") as String
        password = aDecoder.decodeObjectForKey("Password") as String
        website = aDecoder.decodeObjectForKey("Website") as String
        notes = aDecoder.decodeObjectForKey("Notes") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeObject(username, forKey:"Username")
        aCoder.encodeObject(password, forKey:"Password")
        aCoder.encodeObject(website, forKey:"Website")
        aCoder.encodeObject(notes, forKey:"Notes")
    }
}
