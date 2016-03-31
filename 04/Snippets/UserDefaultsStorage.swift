//
//  UserDefaultsStorage.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class UserDefaultsStorage: KeyValueStorage {
    
    let userDefaults: NSUserDefaults
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    init(userDefaults: NSUserDefaults) {
        self.userDefaults = userDefaults
    }
    
    subscript(key: String) -> NSData? {
        get {
            return userDefaults.stringForKey(key).flatMap {
                NSData(base64EncodedString: $0, options: [])
            }
        }
        set {
            if let v = newValue {
                userDefaults.setObject(v.base64EncodedStringWithOptions([]), forKey: key)
                userDefaults.synchronize()
            }
        }
    }
}
