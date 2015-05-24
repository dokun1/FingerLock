//
//  CloudModel.swift
//  FingerLock
//
//  Created by David Okun on 5/24/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import CloudKit

class CloudModel {
    let privateContainer = CKContainer.defaultContainer().privateCloudDatabase
    
    class func shouldAskOneTimeSyncPermission() -> Bool{
        let hasAsked = NSUserDefaults.standardUserDefaults().boolForKey("hasAskedCloudSync")
        if hasAsked {
            return false
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasAskedCloudSync")
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
    }
    
    func currentUserHasPermission() -> Bool {
        return true
    }
    
    func syncAllPasswords(completion : (success : Bool, error : NSError!) -> ()) {
        completion(success: true, error: nil)
    }
}