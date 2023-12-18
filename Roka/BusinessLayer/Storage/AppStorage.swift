//
//  AppStorage.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

private let encryptionKey   = "rokaappstorage22"
private let iv              = "rokaappstorage21"

extension String {
    var aesEncrypted: String {
        let cryptLib = CryptLib()
        return cryptLib.encryptPlainTextRandomIV(withPlainText: self, key: encryptionKey)
    }
    
    var aesDecrypted: String {
        let cryptLib = CryptLib()
        return cryptLib.decryptCipherTextRandomIV(withCipherText: self, key: encryptionKey)
    }
    
    var aesCryptoJS: String {
        // Load only what's necessary
        let AES = CryptoJS.AES()
        
        // AES encryption
        return AES.encrypt(self, password: encryptionKey)
        
//        // AES encryption with custom mode and padding
//        _ = CryptoJS.mode.ECB() // Load custom mode
//        _ = CryptoJS.pad.Iso97971() // Load custom padding scheme
//        return AES.encrypt(self, password: encryptionKey, options:[ "mode": CryptoJS.mode().ECB, "padding": CryptoJS.pad().Iso97971 ])

    }
}

struct AES {
    
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    
    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

class AppStorage: NSObject {
    
    static let shared = AppStorage()
    
    private override init() { }
    
    private let aes128 = AES(key: encryptionKey, iv: iv)

    private func decryptedValueForKey(key: String) -> String {
        if let encryptedData = UserDefaults.standard.value(forKey: key) as? Data,
           let decryptedData = aes128?.decrypt(data: encryptedData) {
            return decryptedData
        } else {
            return ""
        }
    }
    
    private func storeValue(value: String, for key: String) {
        UserDefaults.standard.set(aes128?.encrypt(string: value), forKey: key)
    }
    
    var user: User? {
        get {
            if let rawUser = UserDefaults.standard.data(forKey: "user"),
               let user = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self, NSNumber.self, User.self], from: rawUser) {
                return user as? User
            }
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "user")
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
            }
        }
    }
    
    var fcmToken: String {
        get {
            decryptedValueForKey(key: "fcmToken")
        }
        set(newValue) {
            storeValue(value: newValue, for: "fcmToken")
        }
    }
    
    var isSubcription: String {
        get {
            decryptedValueForKey(key: "isSubcription")
        }
        set(newValue) {
            storeValue(value: newValue, for: "isSubcription")
        }
    }

    var registrationStep: String{
        get {
            decryptedValueForKey(key: "registrationStep")
        }
        set(newValue) {
            storeValue(value: newValue, for: "registrationStep")
        }
    }
    
    var userType: String {
        get {
            decryptedValueForKey(key: "userType")
        }
        set(newValue) {
            storeValue(value: newValue, for: "userType")
        }
    }
    
    var isDeactivate: String {
        get {
            decryptedValueForKey(key: "isDeactivate")
        }
        set(newValue) {
            storeValue(value: newValue, for: "isDeactivate")
        }
    }
    
    var accessToken: String {
        get {
            decryptedValueForKey(key: "accessToken")
        }
        set(newValue) {
            storeValue(value: newValue, for: "accessToken")
        }
    }
    
    var continueAsGuest: Bool {
        get {
            decryptedValueForKey(key: "continueAsGuest") == "Yes"
        }
        set(newValue) {
            storeValue(value: newValue ? "Yes" : "No", for: "continueAsGuest")
        }
    }
    
    var searchBackCheck: Bool? {
        get{
            return UserDefaults.standard.value(forKey: "isProfileTab") as? Bool
        }set{
            UserDefaults.standard.set(newValue, forKey: "isProfileTab")
        }
    }
    
    var searchTab: Bool? {
        get{
            return UserDefaults.standard.value(forKey: "searchTab") as? Bool
        }set{
            UserDefaults.standard.set(newValue, forKey: "searchTab")
        }
    }
    
    var islikeSeleted: String {
        get {
            decryptedValueForKey(key: "islikeSeleted")
        }
        set(newValue) {
            storeValue(value: newValue, for: "islikeSeleted")
        }
    }
    
    var searchTabDetail: Bool? {
        get{
            return UserDefaults.standard.value(forKey: "searchTabDetail") as? Bool
        }set{
            UserDefaults.standard.set(newValue, forKey: "searchTabDetail")
        }
    }
    
    var isWalkthroughShown: String {
        get {
            decryptedValueForKey(key: "isWalkthroughShown")
        }
        set(newValue) {
            storeValue(value: newValue, for: "isWalkthroughShown")
        }
    }
    
    var isLightBoxOpenForChat: String {
        get {
            decryptedValueForKey(key: "isLightBoxOpenForChat")
        }
        set(newValue) {
            storeValue(value: newValue, for: "isLightBoxOpenForChat")
        }
    }
    
    var s3Url: String {
        get {
            decryptedValueForKey(key: "s3Url")
        }
        set(newValue) {
            storeValue(value: newValue, for: "s3Url")
        }
    }
    var userPicDirectoryName: String {
        get {
            decryptedValueForKey(key: "userPicDirectoryName")
        }
        set(newValue) {
            storeValue(value: newValue, for: "userPicDirectoryName")
        }
    }
    
    var isShownLikeDislike: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isShownLikeDislike")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isShownLikeDislike")
            UserDefaults.standard.synchronize()
        }
    }
    
    func clearAll() {
        let defaults = UserDefaults.standard
        defaults.synchronize()
    }
    
    
    var userImages: [UserImages] {
        get {
            if let data = UserDefaults.standard.data(forKey: "userImages") {
                let decoder = JSONDecoder()
                let objects = try? decoder.decode([UserImages].self, from: data)
                return objects ?? []
            } else {
                return []
            }
        }
        set(newValue) {
            let encode = JSONEncoder()
            let encodedValue = try? encode.encode(newValue)
            UserDefaults.standard.set(encodedValue, forKey: "userImages")
        }
    }
    
    
    
}

