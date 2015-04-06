//
//  Utilities.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class Utilities {
    
    class func generateRandomString() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString : NSMutableString = NSMutableString(capacity: 12)
        for (var i = 0; i < 12; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var usedRandomStrings: AnyObject? = defaults.objectForKey("usedStrings")
        var stringArray: [String]
        if (usedRandomStrings == nil) {
            stringArray = [String]()
        } else {
            stringArray = usedRandomStrings? as Array<String>
        }
        if contains(stringArray, randomString) {
            return generateRandomString()
        } else {
            stringArray.append(randomString)
            defaults.setObject(stringArray, forKey: "usedStrings")
            defaults.synchronize()
            return randomString
        }
    }
}