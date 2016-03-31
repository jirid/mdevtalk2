//
//  Crypto.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Crypto {
    
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    //
    
    var initialized: Bool {
        return storage.password != nil && storage.token != nil
    }
    
    var pinEnabled: Bool {
        return initialized && storage.pin != nil
    }
    
    //
    
    func initialize(password: String) -> Bool {
        if !initialized {
            storage.clear()
            storage.token = NSMutableData(length: 1)
            storage.password = password
            return true
        } else {
            return false
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> Bool {
        let same = oldPassword == storage.password
        if same {
            storage.password = newPassword
        }
        return same
    }
    
    func unlockUsingPassword(password: String) -> Bool {
        return password == storage.password
    }
    
    func enablePin(password: String, pin: String) -> Bool {
        let same = password == storage.password
        if same {
            storage.pin = pin
        }
        return same
    }
    
    func changePin(oldPin: String, newPin: String) -> Bool {
        let same = oldPin == storage.pin
        if same {
            storage.pin = newPin
        }
        return same
    }
    
    func disablePin() {
        storage.pin = nil
    }
    
    func unlockUsingPin(pin: String) -> Bool {
        return pin == storage.pin
    }
}
