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
    
    init() {
        
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("FingerLockPasswords.plist")
    }
    
    func loadAllPasswords() -> [PasswordFile] {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                let passwordFiles = unarchiver.decodeObjectForKey(passwordsKey) as [PasswordFile]
                unarchiver.finishDecoding()
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
    
    func saveAllPasswords(allFiles: [PasswordFile]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(allFiles, forKey: passwordsKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func savePasswordFile(fileToSave: PasswordFile) {
        var allFiles = loadAllPasswords()
        if fileToSave.fileID.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            fileToSave.fileID = Utilities.generateRandomStringOfLength(12)
            //TODO: this is where you encrypt the strings of the file
            allFiles.append(fileToSave)
            saveAllPasswords(allFiles)
        } else {
            for (var i = 0; i < allFiles.count; i++) {
                var thisFile = allFiles[i]
                if fileToSave.fileID == thisFile.fileID {
                    allFiles[i] = fileToSave
                    break
                }
            }
            saveAllPasswords(allFiles)
        }
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
    
    func sortPasswordFiles(allFiles: [PasswordFile]) -> [PasswordFile]{
        var allFilesCopy = allFiles
        allFilesCopy.sort({
            file1, file2 in return file1.title.localizedStandardCompare(file2.title) == NSComparisonResult.OrderedAscending
        })
        return allFilesCopy
    }
}
