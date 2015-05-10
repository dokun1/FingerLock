//
//  Utilities.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class Utilities {
    
    class func generateRandomStringOfLength(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString : NSMutableString = NSMutableString(capacity: 12)
        for (var i = 0; i < length; i++){
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
            stringArray = usedRandomStrings as! [String]
        }
        let immutableString = randomString as NSString as String
        if contains(stringArray, immutableString) {
            return generateRandomStringOfLength(length)
        } else {
            stringArray.append(immutableString)
            defaults.setObject(stringArray, forKey: "usedStrings")
            defaults.synchronize()
            return immutableString
        }
    }
    
    class func getDuplicateFileAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Duplicate File", message: "Please use a different title - this one is already being used.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
}