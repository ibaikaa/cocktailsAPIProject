//
//  AuthManager.swift
//  cocktailsProject
//
//  Created by ibaikaa on 24/2/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import UIKit


final class AuthManager {
    enum AuthErrors: Error {
        case nilVerificationID
    }
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationID: String?
    
    public func checkPhoneNumberAndSendSMSCode(
        phoneNumber: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                guard let verificationID = verificationID, error == nil else {
                    completion(false, error)
                    return
                }
                
                self?.verificationID = verificationID
                completion(true, nil)
            }
    }
    
    public func verifyCodeAndTryToSignIn(smsCode: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let verificationID = verificationID else {
            completion(false, AuthErrors.nilVerificationID)
            return
        }
        
        let credential = PhoneAuthProvider.provider()
            .credential(
                withVerificationID: verificationID,
                verificationCode: smsCode
            )
        
        
        auth.signIn(with: credential) { [weak self] result, error in
            guard let self = self else { return }
            guard let _ = result, error == nil else {
                completion(false, error)
                return
            }
            
            if let user = self.auth.currentUser {
                // Saving data to UserDefaults
                self.saveDataToUserDefaults(credential: credential, user: user, completion: completion)
                // Saving data to Keychain
                self.saveDataToKeychain(credential: credential, user: user, completion: completion)
            }
            completion(true, nil)
        }
    }
    
    private func saveDataToKeychain(
        credential: PhoneAuthCredential,
        user: User,
        completion: @escaping (Bool, Error?) -> Void
    ){
        do {
            try KeychainManager.shared.save(credential.provider, forKey: AuthKeys.credentialProvider)
            try KeychainManager.shared.save(user.phoneNumber, forKey: AuthKeys.phoneNumber)
            try KeychainManager.shared.save(user.uid, forKey: AuthKeys.uid)
        } catch {
            print("Error saving credentials: \(error)")
            completion(false, error)
        }
    }
    
    // НЕЖЕЛАТЕЛЬНО ТАК СОХРАНЯТЬ ПРИВАТНЫЕ ДАННЫЕ, НО ДЗ ЕСТЬ ДЗ
    private func saveDataToUserDefaults(
        credential: PhoneAuthCredential,
        user: User,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        do {
            try UserDefaultsManager.shared.save(credential.provider, for: AuthKeys.credentialProvider)
            try UserDefaultsManager.shared.save(user.phoneNumber, for: AuthKeys.phoneNumber)
            try UserDefaultsManager.shared.save(user.uid, for: AuthKeys.uid)
        } catch {
            print("Failed to save data. \(error)")
            completion(false, error)
        }
    }
    
    public func signOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try auth.signOut()
            deleteDataFromKeychain(completion: completion)
            deleteDataFromUserDefaults()
            completion(true, nil)
        } catch let signOutError {
            completion(false, signOutError)
        }
    }
    
    private func deleteDataFromKeychain(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try KeychainManager.shared.delete(forKey: AuthKeys.credentialProvider)
            try KeychainManager.shared.delete(forKey: AuthKeys.phoneNumber)
            try KeychainManager.shared.delete(forKey: AuthKeys.uid)
        } catch {
            print("Failed to delete data from kchn. \(error)")
        }
    }
    
    private func deleteDataFromUserDefaults() {
        UserDefaultsManager.shared.delete(for: AuthKeys.credentialProvider)
        UserDefaultsManager.shared.delete(for: AuthKeys.phoneNumber)
        UserDefaultsManager.shared.delete(for: AuthKeys.uid)
    }
}
