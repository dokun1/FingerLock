//
//  PasswordDetailTableViewController.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class PasswordDetailTableViewController: UITableViewController {
    
    var isForEditing = false
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var notesView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if isForEditing {
            title = "Edit Password"
        } else {
            title = "Add Password"
        }
    }
    
    @IBAction func savePassword() {
        if !checkFields() {
            let alert = UIAlertController(title: "Incomplete", message: "Sorry, you need to fill out every field to save this password.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func checkFields() -> Bool {
        if titleField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            return false
        }
        if usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            return false
        }
        if passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            return false
        }
        return true
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 5
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCellWithIdentifier("passwordTitleCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCellWithIdentifier("passwordPasswordCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCellWithIdentifier("websiteCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCellWithIdentifier("notesCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCellWithIdentifier("nil", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        }
//    }
}
