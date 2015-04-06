//
//  PasswordTableViewController.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class PasswordTableViewController: UITableViewController, PasswordDetailViewControllerDelegate {
    let detailSegueIdentifier = "passwordDetailSegue"
    
    @IBOutlet weak var addPasswordButton: UIBarButtonItem!
    
    var fileTitles = [String]()
    let dataModel = DataModel()
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileTitles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("passwordMainIdentifier", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = fileTitles[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile = dataModel.loadPasswordFileByTitle(fileTitles[indexPath.row])
        performSegueWithIdentifier(detailSegueIdentifier, sender: selectedFile)
    }


    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let removeTitle = fileTitles[indexPath.row]
            dataModel.removeFileByTitle(removeTitle)
            fileTitles = dataModel.loadAllTitles()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passwordDetailSegue" {
            let navController = segue.destinationViewController as UINavigationController
            let controller = navController.viewControllers.first as PasswordDetailTableViewController
            controller.delegate = self
            if sender != nil {
                controller.isForEditing = true
                let existingFile = sender as PasswordFile
                controller.currentFile = existingFile
            }
        }
    }
    
    // MARK: - PasswordDetailViewControllerDelegate Methods
    
    func passwordDetailViewControllerDidCancel(controller: PasswordDetailTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func passwordDetailViewController(controller: PasswordDetailTableViewController, updatedPasswordFile passwordFile: PasswordFile) {
        dataModel.savePasswordFile(passwordFile)
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
