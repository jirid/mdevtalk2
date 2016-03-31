//
//  Components.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import Foundation

final class Components {
    
    private lazy var plainStorage: KeyValueStorage = UserDefaultsStorage()
    private lazy var protectedStorage: KeyValueStorage = KeychainStorage()
    private lazy var encryptor: Encrypting = CCEncryptor()
    
    private var pStorage: Storage!
    var storage: Storage {
        if pStorage == nil {
            pStorage = Storage(plainStorage: plainStorage, protectedStorage: protectedStorage)
        }
        return pStorage
    }
    
    private var pCrypto: Crypto!
    var crypto: Crypto {
        if pCrypto == nil {
            pCrypto = Crypto(encryptor: encryptor, storage: storage)
        }
        return pCrypto
    }
    
    var model: Model {
        return Model(crypto: crypto, storage: storage)
    }
}
