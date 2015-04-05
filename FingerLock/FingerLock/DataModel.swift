//
//  DataModel.swift
//  FingerLock
//
//  Created by David Okun on 4/5/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    let passwordsKey = "Passwords"
    
    override init() {
        super.init()
        let allfiles = loadAllPasswords()
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("Passwords.plist")
    }
    
    func loadAllPasswords() -> [PasswordFile] {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                let passwordFiles = unarchiver.decodeObjectForKey(passwordsKey) as [PasswordFile]
                unarchiver.finishDecoding()
                return passwordFiles
            }
        }
        return []
    }
    
    func loadPasswordFileByID(fileID: String) -> PasswordFile {
        let allFiles = loadAllPasswords()
        
    }
    
    func saveAllPasswords(allFiles: [PasswordFile]) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(allFiles, forKey: passwordsKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func sortPasswordFiles(allFiles: [PasswordFile]) -> [PasswordFile]{
        var allFilesCopy = allFiles
        allFilesCopy.sort({
            file1, file2 in return file1.title.localizedStandardCompare(file2.title) == NSComparisonResult.OrderedAscending
        })
        return allFilesCopy
    }
}
