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
        authorize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func authorize() {
        if canAuthUser() {
            println("can do boss")
            let context = LAContext()
            var error: NSError?
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate", reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    println("neat")
                    self.performSegueWithIdentifier("passwordAuthSegue", sender: nil)
                    return
                } else {
                    println("uh oh")
                }
            })]
        } else {
            println("no can do boss")
        }
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
