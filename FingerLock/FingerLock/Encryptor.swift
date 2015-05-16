//
//  Encryptor.swift
//  FingerLock
//
//  Created by David Okun on 2/2/15.
//  Copyright (c) 2015 David Okun, LLC. All rights reserved.
//

import UIKit
import Security

class Encryptor {
    let cipherKey = "storedCipher"
 
    func getEncryptedString(stringToEncrypt: String) -> String {
        let text = [UInt8](stringToEncrypt.utf8)
        let cipher = [UInt8](getCipher().utf8)
        
        var encrypted = [UInt8]()
        
        for t in enumerate(text) {
            encrypted.append(t.element ^ cipher[t.index])
        }
        
        var encryptedString = String()
        for (var i = 0; i < encrypted.count; i++) {
            encryptedString.append(getCharacterFromAsciiCode(Int(encrypted[i])))
        }
        
        return encryptedString
    }
    
    func getDecryptedString(stringToDecrypt: String) -> String {
        let text = [UInt8](stringToDecrypt.utf8)
        let cipher = [UInt8](getCipher().utf8)
        
        var decrypted = [UInt8]()
        
        for t in enumerate(text) {
            decrypted.append(t.element ^ cipher[t.index])
        }
        
        var decryptedString = String()
        for (var i = 0; i < decrypted.count; i++) {
            decryptedString.append(getCharacterFromAsciiCode(Int(decrypted[i])))
        }
        
        return decryptedString
    }
    
    func setUp(completion: (result: Bool) -> Void) {
        getCipher()
        NSUserDefaults.standardUserDefaults().setInteger(14, forKey: "randomPasswordLength")
        NSUserDefaults.standardUserDefaults().synchronize()
        completion(result: true)
    }
    
    private func getCipher() -> String {
        if !(NSUserDefaults.standardUserDefaults().stringForKey(cipherKey) != nil) {
            NSUserDefaults.standardUserDefaults().setObject(generateNewCipher(), forKey: cipherKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return NSUserDefaults.standardUserDefaults().objectForKey(cipherKey) as! String
    }
    
    private func generateNewCipher() -> String {
        let randomString = Utilities.generateRandomStringOfLength(2000,  shouldBeUnique: true)
        var cipherString = String()
        for (var i = 0; i < count(randomString); i++) {
            let index = advance(randomString.startIndex, i)
            let character = String(randomString[index])
            let code = getAsciiCodeForString(character) as UInt32
            var newCode = Int(code + UInt32(arc4random_uniform(5)))
            let newChar = getCharacterFromAsciiCode(newCode)
            cipherString.append(newChar)
        }
        return randomString
    }
    
    private func getAsciiCodeForString(stringToCodify: String) -> UInt32 {
        let scalars = stringToCodify.unicodeScalars
        return scalars[scalars.startIndex].value
    }
    
    private func getStringFromAsciiCode(code: Int) -> String {
        return String(UnicodeScalar(code))
    }
    
    private func getCharacterFromAsciiCode(code: Int) -> Character {
        return Character(UnicodeScalar(code))
    }
}