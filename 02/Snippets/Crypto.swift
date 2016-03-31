//
//  Crypto.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Crypto {
    
    private let saltLength = 16
    private let challengeLength = 20
    private let encryptor: Encrypting
    private let storage: Storage
    private var key: NSData?
    
    init(encryptor: Encrypting, storage: Storage) {
        self.encryptor = encryptor
        self.storage = storage
    }
    
    //
    
    func encrypt(data: NSData) -> NSData? {
        return key.flatMap {
            encryptor.encrypt(data, key: $0)
        }
    }
    
    func decrypt(data: NSData) -> NSData? {
        return key.flatMap {
            encryptor.decrypt(data, key: $0)
        }
    }
    
    //
    
    var initialized: Bool {
        return storage.encryptedKey != nil && storage.token != nil
    }
    
    var pinEnabled: Bool {
        return initialized && storage.encryptedPin != nil
    }
    
    //
    
    func initialize(password: String) -> Bool {
        guard !initialized else {
            return false
        }
        storage.clear()
        storage.token = NSMutableData(length: 1)
        guard let salt = newSalt(),
            let derived = derive(password, salt),
            let k = newKey(),
            let encKey = encrypt(k, derived) else {
            return false
        }
        storage.encryptedKey = encKey
        storage.saltPassword = salt
        storage.password = password
        key = k
        return true
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> Bool {
        guard oldPassword == storage.password,
            let derived = derive(oldPassword, storage.saltPassword),
            let k = decrypt(storage.encryptedKey, derived),
            let salt = newSalt(),
            let newDerived = derive(newPassword, salt),
            let newEncKey = encrypt(k, newDerived) else {
                return false
        }
        storage.encryptedKey = newEncKey
        storage.saltPassword = salt
        storage.password = newPassword
        return true
    }
    
    func unlockUsingPassword(password: String) -> Bool {
        guard password == storage.password,
            let derived = derive(password, storage.saltPassword),
            let k = decrypt(storage.encryptedKey, derived) else {
                return false
        }
        key = k
        return true
    }
    
    func enablePin(password: String, pin: String) -> Bool {
        guard password == storage.password,
            let derived = derive(password, storage.saltPassword),
            let k = decrypt(storage.encryptedKey, derived),
            let pinSalt = newSalt(),
            let derivedPin = derive(pin, pinSalt),
            let encKey = encrypt(k, derivedPin) else {
                return false
        }
        storage.saltPin = pinSalt
        storage.encryptedPin = encKey
        storage.pin = pin
        return true
    }
    
    func changePin(oldPin: String, newPin: String) -> Bool {
        guard oldPin == storage.pin,
            let derived = derive(oldPin, storage.saltPin),
            let k = decrypt(storage.encryptedPin, derived),
            let pinSalt = newSalt(),
            let derivedPin = derive(newPin, pinSalt),
            let pinEncKey = encrypt(k, derivedPin) else {
                return false
        }
        storage.saltPin = pinSalt
        storage.encryptedPin = pinEncKey
        storage.pin = newPin
        return true
    }
    
    func disablePin() {
        storage.encryptedPin = nil
        storage.saltPin = nil
        storage.pin = nil
    }
    
    func unlockUsingPin(pin: String) -> Bool {
        guard pin == storage.pin,
            let derived = derive(pin, storage.saltPin),
            let k = decrypt(storage.encryptedPin, derived) else {
                return false
        }
        key = k
        return true
    }
    
    func lock() {
        key = nil
    }
    
    //
    
    private func newSalt() -> NSData? {
        return encryptor.randomBytes(saltLength)
    }
    
    private func newKey() -> NSData? {
        return encryptor.generateKey()
    }
    
    private func newChallenge() -> NSData? {
        return encryptor.randomBytes(challengeLength)
    }
    
    private func derive(str: String, _ salt: NSData?) -> NSData? {
        guard let d = str.dataUsingEncoding(NSUTF8StringEncoding), let s = salt else {
            return nil
        }
        return encryptor.deriveKey(d, salt: s)
    }
    
    private func encrypt(data: NSData?, _ key: NSData) -> NSData? {
        return data.flatMap {
            encryptor.encrypt($0, key: key)
        }
    }
    
    private func decrypt(data: NSData?, _ key: NSData) -> NSData? {
        return data.flatMap {
            encryptor.decrypt($0, key: key)
        }
    }
    
    private func verify(key: NSData, _ plaintext: NSData?, _ ciphertext: NSData?) -> Bool {
        guard let p = plaintext, c = ciphertext else {
            return false
        }
        return decrypt(c, key) == p
    }
}
