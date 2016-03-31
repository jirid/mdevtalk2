//
//  Storage.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

protocol KeyValueStorage {
    subscript(idx: String) -> NSData? { get set }
}
