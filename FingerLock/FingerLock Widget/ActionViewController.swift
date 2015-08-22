//
//  ActionViewController.swift
//  FingerLock Widget
//
//  Created by David Okun on 6/13/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import LocalAuthentication

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItemForTypeIdentifier(propertyList, options: nil, completionHandler: { (item, error) -> Void in
                let dictionary = item as! NSDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                    let urlString = results["currentUrl"] as? String
                    println(urlString)
                }
            })
        } else {
            println("error")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println(self.extensionContext!.inputItems)
        authorize()
    }
    
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
        println("successfully authorized!")
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

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}
