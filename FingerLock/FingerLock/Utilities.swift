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
            stringArray = usedRandomStrings? as Array<String>
        }
        if contains(stringArray, randomString) {
            return generateRandomStringOfLength(length)
        } else {
            stringArray.append(randomString)
            defaults.setObject(stringArray, forKey: "usedStrings")
            defaults.synchronize()
            return randomString
        }
    }
    
    class func displaySignUpPendingAlert(controller: UIViewController) -> UIAlertController {
        //create an alert controller
        let pending = UIAlertController(title: "Creating New User", message: nil, preferredStyle: .Alert)
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.userInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        controller.presentViewController(pending, animated: true, completion: nil)
        
        return pending
    }
}