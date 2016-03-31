//
//  main.swift
//  StringDecoder
//
//  Created by Jiri Dutkevic on 13/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

let input = "aGVsbG93b3JsZA=="
let data = NSData(base64EncodedString: input, options: [])!
let str = NSString(data: data, encoding: NSUTF8StringEncoding)!
print(str as String)
