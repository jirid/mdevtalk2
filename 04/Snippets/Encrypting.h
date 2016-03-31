//
//  Encrypting.h
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Encrypting <NSObject>

// generate random bytes
- (nullable NSData *)randomBytes:(NSInteger)size;

// generate a random AES256 key
- (nullable NSData *)generateKey;

// derive AES256 key from `data` using `salt`
- (nullable NSData *)deriveKey:(nonnull NSData *)data salt:(nonnull NSData *)salt;

// compute SHA256 from `data`
- (nullable NSData *)computeHash:(nonnull NSData *)data;

// AES encrypt `data` using AES256 `key`, generates random iv and prepends it to return value
- (nullable NSData *)encrypt:(nonnull NSData *)data key:(nonnull NSData *)key;

// AES decrypt `data` using AES256 `key`, assumes that iv is a prefix of `data`
- (nullable NSData *)decrypt:(nonnull NSData *)data key:(nonnull NSData *)key;

@end
