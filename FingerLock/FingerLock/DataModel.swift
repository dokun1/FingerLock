//
//  DataModel.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class DataModel {
    let passwordsKey = "FingerLockPasswords"
    let encryptor = Encryptor()
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("FingerLockPasswords.plist")
    }
    
    func loadAllPasswords() -> [PasswordFile] {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            let cacheLock = NSLock()
            cacheLock.lock()
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                let passwordFiles = unarchiver.decodeObjectForKey(passwordsKey) as! [PasswordFile]
                unarchiver.finishDecoding()
                cacheLock.unlock()
                let sortedFiles = sortPasswordFiles(passwordFiles)
                return sortedFiles
            }
        } else {
            saveAllPasswords([])
        }
        return []
    }
    
    func loadAllTitles() -> [String] {
        let passwordFiles = loadAllPasswords()
        var titles = [String]()
        for file in passwordFiles {
            titles.append(file.title)
        }
        return titles
    }
    
    func loadPasswordFileByTitle(title: String) -> PasswordFile? {
        let allFiles = loadAllPasswords()
        var returnFile = PasswordFile?()
        for file in allFiles {
            if file.title == title {
                return file
            }
        }
        return nil
    }
    
    func loadPasswordFileByID(fileID: String) -> PasswordFile? {
        let allFiles = loadAllPasswords()
        var returnFile = PasswordFile?()
        for file in allFiles {
            if file.fileID == fileID {
                return file
            }
        }
        return nil
    }
    
    func saveAllPasswords(allFiles: [PasswordFile]) {
        let cacheLock = NSLock()
        cacheLock.lock()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(allFiles, forKey: passwordsKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
        cacheLock.unlock()
    }
    
    func savePasswordFile(fileToSave: PasswordFile, canOverwrite: Bool) -> Bool {
        let originalCount = loadAllTitles().count
        var willOverwrite = false
        if loadPasswordFileByTitle(fileToSave.title) != nil && canOverwrite == false {
            return false
        }
        if loadPasswordFileByID(fileToSave.fileID) != nil {
            if canOverwrite {
                removeFileByID(fileToSave.fileID)
                willOverwrite = true
            } else {
                return false
            }
        }
        var allFiles = loadAllPasswords()
        if fileToSave.fileID.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            fileToSave.fileID = Utilities.generateRandomStringOfLength(12, shouldBeUnique: true)
        }
        allFiles.append(fileToSave)
        saveAllPasswords(allFiles)
        if willOverwrite == false {
            return originalCount < loadAllTitles().count
        } else {
            return originalCount == loadAllTitles().count
        }
    }
    
    func removeAllPasswords() {
        saveAllPasswords([])
    }
    
    func removeFileByTitle(titleToRemove: String) {
        var allFiles = loadAllPasswords()
        var newFileArray = [PasswordFile]()
        var removingFile: PasswordFile?
        for file in allFiles {
            if file.title != titleToRemove {
                newFileArray.append(file)
            }
        }
        saveAllPasswords(newFileArray)
    }
    
    func removeFileByID(idToRemove: String) {
        var allFiles = loadAllPasswords()
        var newFileArray = [PasswordFile]()
        var removingFile: PasswordFile?
        for file in allFiles {
            if file.fileID != idToRemove {
                newFileArray.append(file)
            }
        }
        saveAllPasswords(newFileArray)
    }
    
    func sortPasswordFiles(allFiles: [PasswordFile]) -> [PasswordFile]{
        var allFilesCopy = allFiles
        allFilesCopy.sort({
            file1, file2 in return file1.title.localizedStandardCompare(file2.title) == NSComparisonResult.OrderedAscending
        })
        return allFilesCopy
    }
}