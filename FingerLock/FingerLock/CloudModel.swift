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
        sampleBlockReturnMethodWithParameter("hello", success: { (returnedString) -> (Void) in
            
        }) { (error) -> (Void) in
            
        }
        return true
    }
    
    func syncAllPasswords(completion : (success : Bool, error : NSError!) -> (Void)) {
        completion(success: true, error: nil)
    }
    
    func sampleBlockReturnMethodWithParameter(inputParam: String, success: (returnedString: String) -> (Void), failure: (error: NSError) -> (Void)) {
        if inputParam.isEmpty {
            success(returnedString: inputParam)
        } else {
            var error = NSError()
            failure(error: error)
        }
    }
}