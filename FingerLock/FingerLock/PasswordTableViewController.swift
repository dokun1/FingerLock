//
//  PasswordTableViewController.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class PasswordTableViewController: UITableViewController, PasswordDetailViewControllerDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    let detailSegueIdentifier = "passwordDetailSegue"
    
    @IBOutlet weak var addPasswordButton: UIBarButtonItem!
    
    var fileTitles = [String]()
    let dataModel = DataModel()
    var passwordSearchController = UISearchController()
    var searchArray:[String] = [String]() {
        didSet  {
            tableView.reloadData()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fileTitles = dataModel.loadAllTitles()
    }
    
    @IBAction func add() {
        self.performSegueWithIdentifier(detailSegueIdentifier, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        passwordSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Default
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        passwordSearchController.active = false
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            searchArray = fileTitles as [String]
        } else {
            searchArray.removeAll(keepCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
            let array = (fileTitles as NSArray).filteredArrayUsingPredicate(searchPredicate)
            searchArray = array as! [String]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordSearchController.active ? searchArray.count : fileTitles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var sourceArray = [String]()
        if passwordSearchController.active {
            sourceArray = searchArray
        } else {
            sourceArray = fileTitles
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("passwordMainIdentifier", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = sourceArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var selectedFile = PasswordFile()
        if passwordSearchController.active {
            selectedFile = dataModel.loadPasswordFileByTitle(searchArray[indexPath.row])!
        } else {
            selectedFile = dataModel.loadPasswordFileByTitle(fileTitles[indexPath.row])!
        }
        passwordSearchController.active = false
        performSegueWithIdentifier(detailSegueIdentifier, sender: selectedFile)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !passwordSearchController.active
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        passwordSearchController.active = false
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to permanently delete this password?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            let removeAction = UIAlertAction(title: "Yes", style: .Default, handler: { (_) -> Void in
                self.removeFileAtIndexPath(indexPath)
            })
            alert.addAction(cancelAction)
            alert.addAction(removeAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func removeFileAtIndexPath(indexPath: NSIndexPath) {
        let removeTitle = fileTitles[indexPath.row]
        dataModel.removeFileByTitle(removeTitle)
        fileTitles = dataModel.loadAllTitles()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passwordDetailSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.viewControllers.first as! PasswordDetailTableViewController
            controller.delegate = self
            if sender != nil {
                controller.isForEditing = true
                let existingFile = sender as! PasswordFile
                controller.currentFile = existingFile
            }
        }
    }
    
    // MARK: - PasswordDetailViewControllerDelegate Methods
    
    func passwordDetailViewControllerDidCancel(controller: PasswordDetailTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func passwordDetailViewController(controller: PasswordDetailTableViewController, addedPasswordFile passwordFile: PasswordFile) {
        if (dataModel.savePasswordFile(passwordFile, canOverwrite: false) == true) {
            fileTitles = dataModel.loadAllTitles()
            tableView.reloadData()
            controller.dismissViewControllerAnimated(true, completion: nil)
        } else {
            controller.presentViewController(Utilities.getDuplicateFileAlert(), animated: true, completion: nil)
        }
    }
    
    func passwordDetailViewController(controller: PasswordDetailTableViewController, updatedPasswordFile passwordFile: PasswordFile) {
        dataModel.savePasswordFile(passwordFile, canOverwrite: true)
        fileTitles = dataModel.loadAllTitles()
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func passwordDetailViewController(controller: PasswordDetailTableViewController, removedPasswordFile passwordFile: PasswordFile) {
        dataModel.removeFileByTitle(passwordFile.title)
        fileTitles = dataModel.loadAllTitles()
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}