//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation

class SDUserDefaults: NSObject {
    
    // MARK: - Keys
    private let kIsLoggedIn = "isLoggedIn"
    private let kseenWalkthrough = "seenWalkthrough"
    private let kisOTPVerified = "isOTPVerified"
    private let kIsSignedUp = "IsSignedUp"
    
    static let shared = SDUserDefaults()
    
    // MARK: - Booleans
    var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: kIsLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kIsLoggedIn)
            UserDefaults.standard.synchronize()
        }
    }
    var isSignedUp: Bool {
        get {
            UserDefaults.standard.bool(forKey: kIsSignedUp)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kIsSignedUp)
            UserDefaults.standard.synchronize()
        }
    }
    var seenWalkthrough: Bool {
        get {
            UserDefaults.standard.bool(forKey: kseenWalkthrough)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kseenWalkthrough)
            UserDefaults.standard.synchronize()
        }
    }
    var isOTPVerified: Bool {
        get {
            UserDefaults.standard.bool(forKey: kisOTPVerified)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kisOTPVerified)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Edited By Dhiraj
    var defaultScreen: Int {
        get {
            return(UserDefaults.standard.value(forKey: "defaultScreen") ?? 0) as! Int
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "defaultScreen")
        }
    }

    // MARK: - String
    var apiAccessToken: String {
        get {
            return("\(UserDefaults.standard.value(forKey: "accessToken") ?? "")")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
   
}

extension UserDefaults {
    
   func save<T: Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }
    
   func retrieve<T: Decodable>(object type: T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           } else {
               print("Couldnt decode object")
               return nil
           }
       } else {
           print("Couldnt find key")
           return nil
       }
   }
}
