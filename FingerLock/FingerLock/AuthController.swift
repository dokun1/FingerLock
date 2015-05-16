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
    
    //MARK: Override functions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if UIDevice.currentDevice().model != "iPhone Simulator" && UIDevice.currentDevice().model != "iPad Simulator" {
            authorize()
        }
    }
    
    //MARK: Authorization functions

    func authorize() {
        if canAuthUser() {
            let context = LAContext()
            var error: NSError?
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate", reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    self.successfulAuthentication()
                    return
                } else {
                    let alert = UIAlertController(title: "Error", message: "Could not authenticate your fingerprint. Tap the logo to try again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })]
        } else {
            let alert = UIAlertController(title: "Incompatible", message: "Sorry, but you need a device with TouchID to use this app!", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func successfulAuthentication() {
        if NSUserDefaults.standardUserDefaults().boolForKey("firstTime") == false {
            self.firstTimeSetup()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.self.moveToPasswords()
            })
        }
    }
    
    func firstTimeSetup() {
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
    
    //MARK: IBAction functions
    
    @IBAction func logoTapped() {
        if UIDevice.currentDevice().model != "iPhone Simulator" && UIDevice.currentDevice().model != "iPad Simulator"  {
            authorize()
        } else {
            successfulAuthentication()
        }
    }
}
