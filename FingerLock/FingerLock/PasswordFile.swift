//
//  PasswordFile.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class PasswordFile: NSObject, Printable, NSCopying {
    var title = ""
    var username = ""
    var password  = ""
    var website = ""
    var notes = ""
    var fileID = ""
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("Title") as! String
        username = aDecoder.decodeObjectForKey("Username") as! String
        password = aDecoder.decodeObjectForKey("Password") as! String
        website = aDecoder.decodeObjectForKey("Website") as! String
        notes = aDecoder.decodeObjectForKey("Notes") as! String
        fileID = aDecoder.decodeObjectForKey("FileID") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey:"Title")
        aCoder.encodeObject(username, forKey:"Username")
        aCoder.encodeObject(password, forKey:"Password")
        aCoder.encodeObject(website, forKey:"Website")
        aCoder.encodeObject(notes, forKey:"Notes")
        aCoder.encodeObject(fileID, forKey:"FileID")
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        var copyInstance = self.dynamicType()
        copyInstance.fileID = self.fileID
        copyInstance.title = self.title
        copyInstance.username = self.username
        copyInstance.password = self.password
        copyInstance.website = self.website
        copyInstance.notes = self.notes
        return copyInstance
    }
}