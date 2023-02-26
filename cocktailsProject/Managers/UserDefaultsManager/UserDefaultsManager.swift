//
//  UserDefaultsManager.swift
//  cocktailsProject
//
//  Created by ibaikaa on 26/2/23.
//

import Foundation

struct UserKeys {
    static let name = "UserName"
    static let surname = "UserSurname"
    static let birthDate = "UserBirthDate"
    static let address = "UserAddress"
}

struct AuthKeys {
    static let uid = "UserID"
    static let phoneNumber = "UserPhoneNumber"
    static let credentialProvider = "CredentialProvider"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() { }

    enum UserDefaultsError: Error {
        case noFoundKeyForObject
        case failedToSaveData
    }
    
    func save<T>(_ object: T, for key: String) throws {
        print("Succesfully saved \(object)!")
        defaults.set(object, forKey: key)
        guard defaults.synchronize() else { throw UserDefaultsError.failedToSaveData }
    }
    
    func retrieve(for key: String) throws -> Any {
        guard let object = defaults.object(forKey: key) else {
            throw UserDefaultsError.noFoundKeyForObject
        }
        return object
    }
    
    func deleteValue(for key: String) {
        defaults.removeObject(forKey: key)
    }
}


