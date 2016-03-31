//
//  SnippetsStorage.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

private enum StorageKeys : String {
    case Token = "token"
    case Data = "data"
    case EncryptedKey = "encrypted_key"
    case EncryptedPin = "encrypted_pin"
    case SaltPassword = "salt_password"
    case SaltPin = "salt_pin"
    case Password = "password"
    case Pin = "pin"
}

final class Storage: NSObject {
    
    var plainStorage: KeyValueStorage
    var protectedStorage: KeyValueStorage
    
    init(plainStorage: KeyValueStorage, protectedStorage: KeyValueStorage) {
        self.plainStorage = plainStorage
        self.protectedStorage = protectedStorage
    }
    
    var token: NSData? {
        get {
            return plainStorage[StorageKeys.Token.rawValue]
        }
        set {
            plainStorage[StorageKeys.Token.rawValue] = newValue
        }
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
    
    var password: String? {
        get {
            return protectedStorage[StorageKeys.Password.rawValue].flatMap {
                NSString(data: $0, encoding: NSUTF8StringEncoding).flatMap {
                    $0 as String
                }
            }
        }
        set {
            protectedStorage[StorageKeys.Password.rawValue] = newValue.flatMap {
                $0.dataUsingEncoding(NSUTF8StringEncoding)
            }
        }
    }
    
    var pin: String? {
        get {
            return protectedStorage[StorageKeys.Pin.rawValue].flatMap {
                NSString(data: $0, encoding: NSUTF8StringEncoding).flatMap {
                    $0 as String
                }
            }
        }
        set {
            protectedStorage[StorageKeys.Pin.rawValue] = newValue.flatMap {
                $0.dataUsingEncoding(NSUTF8StringEncoding)
            }
        }
    }
    
    func clear() {
        token = nil
        data = nil
        encryptedKey = nil
        encryptedPin = nil
        saltPassword = nil
        saltPin = nil
        password = nil
        pin = nil
    }
}
