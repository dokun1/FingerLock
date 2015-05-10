//
//  FingerLockTests.swift
//  FingerLockTests
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import XCTest

class FingerLockTests: XCTestCase {
    let dataModel = DataModel()
    let encryptor = Encryptor()
    let testFile = PasswordFile()
    let secondTestFile = PasswordFile()
    let duplicateTestFile = PasswordFile()
    
    override func setUp() {
        super.setUp()
        
        testFile.title = "Testing title"
        testFile.username = encryptor.getEncryptedString("usernameTest")
        testFile.password = encryptor.getEncryptedString("passwordTest")
        testFile.website = encryptor.getEncryptedString("websiteTest")
        testFile.notes = encryptor.getEncryptedString("notesTest")
        
        secondTestFile.title = "Second Testing title"
        secondTestFile.username = encryptor.getEncryptedString("usernameTest2")
        secondTestFile.password = encryptor.getEncryptedString("passwordTest2")
        secondTestFile.website = encryptor.getEncryptedString("websiteTest2")
        secondTestFile.notes = encryptor.getEncryptedString("notesTest2")
        
        duplicateTestFile.title = "Testing title"
        duplicateTestFile.username = encryptor.getEncryptedString("usernameTest")
        duplicateTestFile.password = encryptor.getEncryptedString("passwordTest")
        duplicateTestFile.website = encryptor.getEncryptedString("websiteTest")
        duplicateTestFile.notes = encryptor.getEncryptedString("notesTest")
    }
    
    override func tearDown() {
        super.tearDown()
        dataModel.removeAllPasswords()
    }
    
    func testEmptyDatabase() {
        let passwordArray = dataModel.loadAllPasswords()
        XCTAssertEqual(0, passwordArray.count, "there are pre-existing password files saved, some tests will fail, need to clean the database first")
    }
    
    func testFilesExist() {
        XCTAssertNotNil(testFile, "password file constructor not working")
        XCTAssertNotNil(secondTestFile, "password file constructor not working")
        XCTAssertNotNil(duplicateTestFile, "password file constructor not working")
    }
    
    func testEncryption() {
        let testString = "this is a test"
        let encryptedTestString = encryptor.getEncryptedString(testString)
        XCTAssertNotEqual(testString, encryptedTestString, "encryption not working, the encrypted string is the same as the unencrypted string")
    }
    
    func testDecryption() {
        let testString = "this is a better test"
        let encryptedTestString = encryptor.getEncryptedString(testString)
        let decryptedTestString = encryptor.getDecryptedString(encryptedTestString)
        XCTAssertEqual(testString, decryptedTestString, "decryption not working, encrypting and decrypting a string yields different results")
    }
    
    func testSavingDuplicateFile() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        var secondSave = dataModel.savePasswordFile(secondTestFile, canOverwrite: false)
        var duplicateSave = dataModel.savePasswordFile(duplicateTestFile, canOverwrite: false)
        
        XCTAssertTrue(firstSave, "could not save the first file")
        XCTAssertTrue(secondSave, "could not save the second file")
        XCTAssertFalse(duplicateSave, "was able to save a duplicate file")
    }
    
    func testSavingTwoPasswords() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        var secondSave = dataModel.savePasswordFile(secondTestFile, canOverwrite: false)
        
        let passwordArray = dataModel.loadAllPasswords()
        
        XCTAssertEqual(passwordArray.count, 2, "there are more than 2 files in the data model, only expecting 2")
    }
    
    func testLoadingDiscreteFiles() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        var secondSave = dataModel.savePasswordFile(secondTestFile, canOverwrite: false)
        
        let firstLoad = dataModel.loadPasswordFileByTitle("Testing title")
        let secondLoad = dataModel.loadPasswordFileByTitle("Second Testing title")
        
        XCTAssertNotEqual(firstLoad!, secondLoad!, "files are not being discretely saved")
        XCTAssertNotEqual(firstLoad!.title, secondLoad!.title, "the titles are the same, and the loading mechanism is not working")
    }
    
    func testAttemptingToLoadNonexistentFile() {
        let loadFile = dataModel.loadPasswordFileByTitle("nonexistent file")
        
        XCTAssertNil(loadFile, "something is being loaded in place of a non existent file")
    }
    
    func testFileEqualityAfterSaveAndLoad() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        let firstLoad = dataModel.loadPasswordFileByTitle("Testing title")
        
        XCTAssertEqual(testFile.title, firstLoad!.title, "the title is not the same after being saved")
        XCTAssertEqual(testFile.username, firstLoad!.username, "the username for the file after a save and load is manipulated")
        XCTAssertEqual(testFile.password, firstLoad!.password, "the password for the file after a save and load is manipulated")
        XCTAssertEqual(testFile.website, firstLoad!.website, "the website for the file after a save and load is manipulated")
        XCTAssertEqual(testFile.notes, firstLoad!.notes, "the notes for the file after a save and load are manipulated")
    }
    
    func testFileDecryptionAfterSaveAndLoad() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        let firstLoad = dataModel.loadPasswordFileByTitle("Testing title")
        
        XCTAssertEqual(encryptor.getDecryptedString(testFile.username), encryptor.getDecryptedString(firstLoad!.username), "the username decrypted is not the same after being saved")
        XCTAssertEqual(encryptor.getDecryptedString(testFile.password), encryptor.getDecryptedString(firstLoad!.password), "the password decrypted is not the same after being saved")
        XCTAssertEqual(encryptor.getDecryptedString(testFile.website), encryptor.getDecryptedString(firstLoad!.website), "the website decrypted is not the same after being saved")
        XCTAssertEqual(encryptor.getDecryptedString(testFile.notes), encryptor.getDecryptedString(firstLoad!.notes), "the notes decrypted are not the same after being saved")
    }
    
    func testFileOverwriteWorksCorrectly() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        let firstLoad = dataModel.loadPasswordFileByTitle("Testing title")
        
        let midUsername = firstLoad?.username
        firstLoad?.username = "secondUsernameTest"
        var secondSave = dataModel.savePasswordFile(firstLoad!, canOverwrite: true)
        var secondLoad = dataModel.loadPasswordFileByTitle("Testing title")
        
        XCTAssertNotEqual(testFile.username, secondLoad!.username, "the username is not being overwritten during the second save")
        XCTAssertEqual(testFile.title, secondLoad!.title, "something is happening to the title of the file during overwriting")
        XCTAssertEqual(testFile.fileID, secondLoad!.fileID, "file ID is being changed during overwrite")
        XCTAssertEqual(dataModel.loadAllTitles().count, 1, "there should only be one file saved to the array right now")
    }
    
    func testFileOverwriteWithNewTitleWorksCorrectly() {
        var firstSave = dataModel.savePasswordFile(testFile, canOverwrite: false)
        let firstLoad = dataModel.loadPasswordFileByTitle("Testing title")
        
        let midTitle = firstLoad?.title
        firstLoad?.title = "new testing title"
        var secondSave = dataModel.savePasswordFile(firstLoad!, canOverwrite: true)
        var secondLoad = dataModel.loadPasswordFileByTitle("new testing title")
        var nonexistentLoad = dataModel.loadPasswordFileByTitle(midTitle!)
        
        XCTAssertNotEqual(testFile.title, secondLoad!.title, "the titles should be different")
        XCTAssertNil(nonexistentLoad, "you should not be able to load a file that does not exist")
        XCTAssertEqual(firstLoad!.fileID, secondLoad!.fileID, "the file id for both loads should be the same no matter what other attributes changed")
        XCTAssertEqual(testFile.fileID, secondLoad!.fileID, "the file id for both loads should be the same no matter what other attributes changed")
        XCTAssertEqual(dataModel.loadAllTitles().count, 1, "there should only be one file saved to the array right now")
    }
}