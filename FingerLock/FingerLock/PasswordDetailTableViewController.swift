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
    func passwordDetailViewController(controller: PasswordDetailTableViewController, addedPasswordFile passwordFile: PasswordFile)
    func passwordDetailViewController(controller: PasswordDetailTableViewController, updatedPasswordFile passwordFile: PasswordFile)
    func passwordDetailViewController(controller: PasswordDetailTableViewController, removedPasswordFile passwordFile: PasswordFile)
}

class PasswordDetailTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var isForEditing = false
    var currentFile: PasswordFile!
    var fileToDiff: PasswordFile!
    
    let dataModel = DataModel()
    let encryptor = Encryptor()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var notesView: UITextView!
    @IBOutlet weak var removeButton: UIButton!
    
    weak var delegate: PasswordDetailViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool) {
        customizeAppearance()
        if isForEditing {
            title = "Edit Password"
            setFields()
            fileToDiff = currentFile.copy() as! PasswordFile
        } else {
            title = "Add Password"
            currentFile = PasswordFile()
        }
    }

    
    func handleSavingPasswordDuringEdit() {
        if fileToDiff.title == currentFile.title { // if the file title didnt change, just update it.
            delegate?.passwordDetailViewController(self, updatedPasswordFile: currentFile)
        } else { // if the file title changed, check to see if we might be overwriting
            if dataModel.loadPasswordFileByTitle(currentFile.title) == nil {
                delegate?.passwordDetailViewController(self, updatedPasswordFile: currentFile)
            } else {
                presentViewController(Utilities.getDuplicateFileAlert(), animated: true, completion: nil)
            }
        }
    }
    
    func attemptRemoval() {
        delegate?.passwordDetailViewController(self, removedPasswordFile: currentFile)
    }
    
    func customizeAppearance() {
        titleField.font = UIFont.boldSystemFontOfSize(14)
        usernameField.font = UIFont.systemFontOfSize(13)
        passwordField.font = UIFont.systemFontOfSize(13)
        websiteField.font = UIFont.systemFontOfSize(13)
        notesView.font = UIFont.systemFontOfSize(12)
        
        let orangeAppColor = UIColor(red:0.91, green:0.44, blue:0.09, alpha:1)
        removeButton.backgroundColor = orangeAppColor
        removeButton.titleLabel?.textColor = UIColor.whiteColor()
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
    
    func updateCurrentFile() { // I want this to be the only place where the file attributes are shown unencrypted. even floating around in memory, the file types should be encrypted.
        currentFile.title = titleField.text
        currentFile.username = encryptor.getEncryptedString(usernameField.text)
        currentFile.password = encryptor.getEncryptedString(passwordField.text)
        currentFile.website = encryptor.getEncryptedString(websiteField.text)
        currentFile.notes = encryptor.getEncryptedString(notesView.text)
    }
    
    func setFields() {
        titleField.text = currentFile.title
        usernameField.text = encryptor.getDecryptedString(currentFile.username)
        passwordField.text = encryptor.getDecryptedString(currentFile.password)
        websiteField.text = encryptor.getDecryptedString(currentFile.website)
        notesView.text = encryptor.getDecryptedString(currentFile.notes)
    }
    
    // MARK: IBAction Methods
    
    @IBAction func randomizePassword() {
        let newPassword = Utilities.generateRandomStringOfLength(NSUserDefaults.standardUserDefaults().integerForKey("randomPasswordLength"), shouldBeUnique: false)
        passwordField.text = newPassword
        updateCurrentFile()
    }
    
    @IBAction func savePassword() {
        if !checkFields() { // first check to make sure all the fields are filled out
            let alert = UIAlertController(title: "Incomplete", message: "Sorry, you need to fill out every field to save this password.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            if (isForEditing) { // are we editing an old file?
                handleSavingPasswordDuringEdit()
            } else {
                delegate?.passwordDetailViewController(self, addedPasswordFile: currentFile)
            }
        }
    }
    
    @IBAction func cancelButtonTapped() {
        delegate?.passwordDetailViewControllerDidCancel(self)
    }
    
    @IBAction func removeButtonTapped() {
        if isForEditing == true {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to permanently delete this password?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            let removeAction = UIAlertAction(title: "Yes", style: .Default) { (_) -> Void in
                self.attemptRemoval()
            }
            alert.addAction(cancelAction)
            alert.addAction(removeAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            delegate?.passwordDetailViewControllerDidCancel(self)
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateCurrentFile()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == titleField {
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            websiteField.becomeFirstResponder()
        } else if textField == websiteField {
            notesView.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == websiteField && currentFile.website.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            websiteField.text = "http://"
        }
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if !NSUserDefaults.standardUserDefaults().boolForKey("copyAndPasteEnabled") {
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                UIMenuController.sharedMenuController().setMenuVisible(false, animated: false)
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK: UITextViewDelegate Methods

    func textViewDidEndEditing(textView: UITextView) {
        updateCurrentFile()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}