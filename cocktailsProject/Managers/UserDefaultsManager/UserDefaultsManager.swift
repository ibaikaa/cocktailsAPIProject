//
//  UserDefaultsManager.swift
//  cocktailsProject
//
//  Created by ibaikaa on 26/2/23.
//

import Foundation

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
    
    func delete(for key: String) {
        defaults.removeObject(forKey: key)
    }
}


