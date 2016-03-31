//
//  Model.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Model {
    
    private let crypto: Crypto
    private let storage: Storage
    
    var snippets: [Snippet] {
        didSet {
            let data = snippets.map { $0.toDictionary() }
            if let json = try? NSJSONSerialization.dataWithJSONObject(data, options: []),  let encrypted = crypto.encrypt(json) {
                storage.data = encrypted
            }
        }
    }
    
    init(crypto: Crypto, storage: Storage) {
        self.crypto = crypto
        self.storage = storage
        
        if let data = storage.data, let decrypted = crypto.decrypt(data), let json = (try? NSJSONSerialization.JSONObjectWithData(decrypted, options: [])) as? [NSDictionary] {
            snippets = json.map { Snippet(dictionary: $0) }.filter { $0 != nil }.map { $0! }
        } else {
            snippets = []
        }
    }
}
