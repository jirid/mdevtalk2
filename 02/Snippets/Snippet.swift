//
//  Snippet.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Snippet : NSObject, NSCoding, NSSecureCoding {
    
    let name: String
    let content: String
    
    private enum Keys: String {
        case Name = "name"
        case Content = "content"
    }
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObjectOfClass(NSString.self, forKey: Keys.Name.rawValue) as? String,
            let content = aDecoder.decodeObjectOfClass(NSString.self, forKey: Keys.Content.rawValue) as? String else {
                return nil
        }
        self.name = name
        self.content = content
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: Keys.Name.rawValue)
        aCoder.encodeObject(content, forKey: Keys.Content.rawValue)
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    override var description: String {
        return "Snippet: Name: '\(name)', Content: '\(content)'"
    }
    
    init?(dictionary: NSDictionary) {
        if let name = dictionary.objectForKey(Keys.Name.rawValue) as? String, let content = dictionary.objectForKey(Keys.Content.rawValue) as? String {
            self.name = name
            self.content = content
        } else {
            return nil
        }
    }
    
    func toDictionary() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(name, forKey: Keys.Name.rawValue)
        dict.setValue(content, forKey: Keys.Content.rawValue)
        return dict
    }
}
