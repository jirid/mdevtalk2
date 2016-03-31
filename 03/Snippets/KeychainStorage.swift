//
//  KeychainStorage.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class KeychainStorage: KeyValueStorage {
    
    subscript(idx: String) -> NSData? {
        get {
            return retrieve(idx)
        }
        set {
            let e = exists(idx)
            if let data = newValue {
                if e {
                    update(idx, data: data)
                } else {
                    insert(idx, data: data)
                }
            } else if e {
                delete(idx)
            }
        }
    }
    
    private func exists(item: String) -> Bool {
        let dict = baseKeychainDictionary(item)
        var result: AnyObject? = nil
        var status = errSecUnimplemented
        withUnsafeMutablePointer(&result) {
            status = SecItemCopyMatching(dict as CFDictionary, $0)
        }
        return status == errSecSuccess
    }
    
    private func retrieve(item: String) -> NSData? {
        var dict = baseKeychainDictionary(item)
        dict[kSecMatchLimit as String] = kSecMatchLimitOne
        dict[kSecReturnData as String] = kCFBooleanTrue
        var result: AnyObject? = nil
        var status = errSecUnimplemented
        withUnsafeMutablePointer(&result) {
            status = SecItemCopyMatching(dict as CFDictionary, $0)
        }
        if status == errSecSuccess, let data = result as? NSData {
            return data
        }
        return nil
    }
    
    private func insert(item: String, data: NSData) -> Bool {
        var dict = baseKeychainDictionary(item)
        dict[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        dict[kSecValueData as String] = data
        var result: AnyObject? = nil
        var status = errSecUnimplemented
        withUnsafeMutablePointer(&result) {
            status = SecItemAdd(dict as CFDictionary, $0)
        }
        return status == errSecSuccess
    }
    
    private func update(item: String, data: NSData) -> Bool {
        let searchDict = baseKeychainDictionary(item)
        let updateDict = [kSecValueData as String : data as AnyObject]
        let status = SecItemUpdate(searchDict as CFDictionary, updateDict as CFDictionary)
        return status == errSecSuccess
    }
    
    private func delete(item: String) -> Bool {
        let dict = baseKeychainDictionary(item)
        let status = SecItemDelete(dict as CFDictionary)
        return status == errSecSuccess
    }
    
    private func baseKeychainDictionary(item: String) -> [String : AnyObject] {
        var dictionary = [String : AnyObject]()
        dictionary[kSecClass as String] = kSecClassGenericPassword
        let name = "Snippets"
        dictionary[kSecAttrAccount as String] = "\(name).\(item)"
        dictionary[kSecAttrService as String] = name
        return dictionary
    }
}
