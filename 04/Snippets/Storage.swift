//
//  SnippetsStorage.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

private enum StorageKeys : String {
    case Data = "data"
    case EncryptedKey = "encrypted_key"
    case EncryptedPin = "encrypted_pin"
    case SaltPassword = "salt_password"
    case SaltPin = "salt_pin"
    case ChallengePlaintext = "challenge_plaintext"
    case ChallengeCiphertext = "challenge_ciphertext"
}

final class Storage {
    
    var plainStorage: KeyValueStorage
    var protectedStorage: KeyValueStorage
    
    init(plainStorage: KeyValueStorage, protectedStorage: KeyValueStorage) {
        self.plainStorage = plainStorage
        self.protectedStorage = protectedStorage
    }
    
    var data: NSData? {
        get {
            return plainStorage[StorageKeys.Data.rawValue]
        }
        set {
            plainStorage[StorageKeys.Data.rawValue] = newValue
        }
    }
    
    var encryptedKey: NSData? {
        get {
            return protectedStorage[StorageKeys.EncryptedKey.rawValue]
        }
        set {
            protectedStorage[StorageKeys.EncryptedKey.rawValue] = newValue
        }
    }
    
    var encryptedPin: NSData? {
        get {
            return protectedStorage[StorageKeys.EncryptedPin.rawValue]
        }
        set {
            protectedStorage[StorageKeys.EncryptedPin.rawValue] = newValue
        }
    }
    
    var saltPassword: NSData? {
        get {
            return protectedStorage[StorageKeys.SaltPassword.rawValue]
        }
        set {
            protectedStorage[StorageKeys.SaltPassword.rawValue] = newValue
        }
    }
    
    var saltPin: NSData? {
        get {
            return protectedStorage[StorageKeys.SaltPin.rawValue]
        }
        set {
            protectedStorage[StorageKeys.SaltPin.rawValue] = newValue
        }
    }
    
    var challengePlaintext: NSData? {
        get {
            return plainStorage[StorageKeys.ChallengePlaintext.rawValue]
        }
        set {
            plainStorage[StorageKeys.ChallengePlaintext.rawValue] = newValue
        }
    }
    
    var challengeCiphertext: NSData? {
        get {
            return plainStorage[StorageKeys.ChallengeCiphertext.rawValue]
        }
        set {
            plainStorage[StorageKeys.ChallengeCiphertext.rawValue] = newValue
        }
    }
    
    func clear() {
        data = nil
        encryptedKey = nil
        encryptedPin = nil
        saltPassword = nil
        saltPin = nil
        challengePlaintext = nil
        challengeCiphertext = nil
    }
}
