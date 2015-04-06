//
//  AuthController.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import LocalAuthentication


class AuthController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        authorize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func authorize() {
        if canAuthUser() {
            let context = LAContext()
            var error: NSError?
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate", reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    if NSUserDefaults.standardUserDefaults().boolForKey("firstTime") == false {
                        self.setThingsUp()
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.self.moveToPasswords()
                        })
                    }
                    return
                } else {
                    
                }
            })]
        } else {
            let alert = UIAlertController(
                title: "Incompatible",
                message: "Sorry, but you need a phone with TouchID to use this app!",
                preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setThingsUp() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstTime")
        NSUserDefaults.standardUserDefaults().synchronize()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alert = UIAlertController(title: nil, message: "Setting up encryption. Please wait...", preferredStyle:.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                Encryptor().setUp({ (result) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        self.moveToPasswords()
                    })
                })
            })
        })
    }
    
    func moveToPasswords() {
        self.performSegueWithIdentifier("passwordAuthSegue", sender: nil)
    }
    
    func canAuthUser() -> Bool {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
}
