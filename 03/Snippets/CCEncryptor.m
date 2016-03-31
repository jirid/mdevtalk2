//
//  CCEncryptor.m
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

#import "CCEncryptor.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>

#define KEY_SIZE kCCKeySizeAES256
#define BLOCK_SIZE kCCBlockSizeAES128
#define HASH_SIZE CC_SHA256_DIGEST_LENGTH
#define DERIVE_ITER 10000

@implementation CCEncryptor

- (nullable NSData *)randomBytes:(NSInteger)size
{
    // precondition
    if (size <= 0) {
        return nil;
    }
    
    // initialization
    NSMutableData *data = [NSMutableData dataWithLength:size];
    
    // random data
    CCRNGStatus status = CCRandomGenerateBytes(data.mutableBytes, size);
    
    // postcondition
    if (status != kCCSuccess) {
        return nil;
    }
    
    return data;
}

- (nullable NSData *)generateKey
{
    return [self randomBytes:KEY_SIZE];
}

- (nullable NSData *)deriveKey:(nonnull NSData *)data salt:(nonnull NSData *)salt
{
    // precondition
    if (data == nil || data.length == 0) {
        return nil;
    }
    if (salt == nil || salt.length == 0) {
        return nil;
    }
    
    // initialization
    NSMutableData *key = [[NSMutableData alloc] initWithLength:KEY_SIZE];
    
    // key derivation
    int status = CCKeyDerivationPBKDF(kCCPBKDF2, data.bytes, data.length, salt.bytes, salt.length, kCCPRFHmacAlgSHA256, DERIVE_ITER, key.mutableBytes, KEY_SIZE);
    
    // postcondition
    if (status != kCCSuccess) {
        return nil;
    }
    
    return key;
}

- (nullable NSData *)computeHash:(nonnull NSData *)data
{
    // precondition
    if (data == nil || data.length == 0) {
        return nil;
    }
    
    // initialization
    NSMutableData *hash = [NSMutableData dataWithLength:HASH_SIZE];
    
    // compute digest
    CC_SHA256(data.bytes, (CC_LONG)data.length, hash.mutableBytes);
    
    return hash;
}

- (nullable NSData *)encrypt:(nonnull NSData *)data key:(nonnull NSData *)key
{
    // initialization
    
    // generate random iv
    NSData *iv = [self randomBytes:BLOCK_SIZE];
    if (iv == nil) {
        return nil;
    }
    
    // encryption
    NSData *encrypted = [self aes:kCCEncrypt data:data key:key iv:iv];
    
    // postcondition
    if (encrypted == nil) {
        return nil;
    }
    
    // prepend iv to encrypted data
    NSMutableData *result = [[NSMutableData alloc] initWithCapacity:iv.length+encrypted.length];
    [result appendData:iv];
    [result appendData:encrypted];
    
    return result;
}

- (nullable NSData *)decrypt:(nonnull NSData *)data key:(nonnull NSData *)key
{
    // precondition
    if (data == nil || data.length <= BLOCK_SIZE) {
        return nil;
    }
    
    // initialization
    // split data into iv and encrypted data
    NSData *iv = [NSData dataWithBytes:data.bytes length:BLOCK_SIZE];
    NSData *encrypted = [NSData dataWithBytes:data.bytes+BLOCK_SIZE length:data.length-BLOCK_SIZE];
    
    // decryption
    NSData *result = [self aes:kCCDecrypt data:encrypted key:key iv:iv];
    
    return result;
}

- (nullable NSData *)aes:(CCOperation)operation data:(nonnull NSData *)data key:(nonnull NSData *)key iv:(nonnull NSData *)iv
{
    // precondition
    if (data == nil || data.length == 0) {
        return nil;
    }
    if (key == nil || key.length != KEY_SIZE) {
        return nil;
    }
    if (iv == nil || iv.length != BLOCK_SIZE) {
        return nil;
    }
    
    // initialization
    CCCryptorStatus status;
    
    CCCryptorRef cryptor = nil;
    status = CCCryptorCreate(operation, kCCAlgorithmAES, kCCOptionPKCS7Padding, key.bytes, key.length, iv.bytes, &cryptor);
    if (status != kCCSuccess || cryptor == nil) {
        return nil;
    }
    
    // compute output size
    size_t neededSpace = CCCryptorGetOutputLength(cryptor, data.length, true);
    NSMutableData *result = [NSMutableData dataWithLength:neededSpace];
    
    // encryption/decryption
    size_t writtenDataUpdate = 0;
    status = CCCryptorUpdate(cryptor, data.bytes, data.length, result.mutableBytes, neededSpace, &writtenDataUpdate);
    if (status != kCCSuccess) {
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    // padding
    size_t writtenDataFinal = 0;
    status = CCCryptorFinal(cryptor, result.mutableBytes+writtenDataUpdate, neededSpace-writtenDataUpdate, &writtenDataFinal);
    if (status != kCCSuccess) {
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    CCCryptorRelease(cryptor);
    
    // trim output in case output size calculation overestimated needed space
    return [[NSData alloc] initWithBytes:result.bytes length:writtenDataUpdate+writtenDataFinal];
}

@end
