//
//  InfoController.swift
//  FingerLock
//
//  Created by David Okun on 5/10/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "© David Okun, 2015, v\(version)"
        }
    }
    
    @IBAction func linkTapped() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/dokun1/FingerLock")!)
    }
    
    @IBAction func dismissButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}