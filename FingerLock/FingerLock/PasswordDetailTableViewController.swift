//
//  PasswordDetailTableViewController.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

protocol PasswordDetailViewControllerDelegate: class {
    func passwordDetailViewControllerDidCancel(controller: PasswordDetailTableViewController)
    func passwordDetailViewController(controller: PasswordDetailTableViewController, updatedPasswordFile passwordFile: PasswordFile)
    func passwordDetailViewController(controller: PasswordDetailTableViewController, removedPasswordFile passwordFile: PasswordFile)
}

class PasswordDetailTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var isForEditing = false
    var currentFile: PasswordFile!
    
    let dataModel = DataModel()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var removeButton: UIButton!
    
    weak var delegate: PasswordDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if isForEditing {
            title = "Edit Password"
            setFields()
        } else {
            title = "Add Password"
            currentFile = PasswordFile()
            removeButton.enabled = false
        }
    }
    
    @IBAction func savePassword() {
        if !checkFields() {
            let alert = UIAlertController(title: "Incomplete", message: "Sorry, you need to fill out every field to save this password.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            delegate?.passwordDetailViewController(self, updatedPasswordFile: currentFile)
        }
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.passwordDetailViewControllerDidCancel(self)
    }
    
    @IBAction func removeButtonTapped() {
//        weak var weakSelf = self
//        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to remove this password? It will be gone forever.", preferredStyle: .Alert)
//
//        let deleteAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (_) -> Void in
//            delegate?.passwordDetailViewController(self, removedPasswordFile: currentFile)
//        }
//        alert.addAction(deleteAction)
//        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
//        alert.addAction(cancelAction)
//        self.presentViewController(alert, animated: true, completion: nil)
    delegate?.passwordDetailViewController(self, removedPasswordFile: currentFile)
    }
    
    func checkFields() -> Bool {
        updateCurrentFile()
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
    
    func updateCurrentFile() {
        currentFile.title = titleField.text
        currentFile.username = usernameField.text
        currentFile.password = passwordField.text
        currentFile.website = websiteField.text
        currentFile.notes = notesView.text
    }
    
    func setFields() {
        titleField.text = currentFile.title
        usernameField.text = currentFile.username
        passwordField.text = currentFile.password
        websiteField.text = currentFile.website
        notesView.text = currentFile.notes
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldDidEndEditing(textField: UITextField) { // after editing the file, always update the one in memory
        updateCurrentFile()
    }
    
    // MARK: UITextViewDelegate Methods

    func textViewDidEndEditing(textView: UITextView) {
        updateCurrentFile()
    }
}
