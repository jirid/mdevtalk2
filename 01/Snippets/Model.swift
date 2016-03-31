//
//  Model.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Model {
    
    private let storage: Storage
    
    var snippets: [Snippet] {
        didSet {
            let json = snippets.map { $0.toDictionary() }
            if let data = try? NSJSONSerialization.dataWithJSONObject(json, options: []) {
                storage.data = data
            }
        }
    }
    
    init(storage: Storage) {
        self.storage = storage
        
        if let data = storage.data, let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [NSDictionary] {
            snippets = json.map { Snippet(dictionary: $0) }.filter { $0 != nil }.map { $0! }
        } else {
            snippets = []
        }
    }
}
