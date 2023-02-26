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
    private let provider = PhoneAuthProvider.provider()
    private var verificationID: String?
    
    // MARK: - Public Methods
    
    func tryToSendSMSCode(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                completion(.failure(error!))
                return
            }
            
            self?.verificationID = verificationID
            completion(.success(()))
        }
    }
    
    func tryToSignIn(smsCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let verificationID = verificationID else {
            completion(.failure(AuthErrors.nilVerificationID))
            return
        }
        
        let credential = provider.credential(withVerificationID: verificationID, verificationCode: smsCode)
        
        auth.signIn(with: credential) { [weak self] result, error in
            guard let self = self else { return }
            guard let _ = result, error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let user = self.auth.currentUser {
                do {
                    try KeychainManager.shared.save(credential.provider, forKey: AuthKeys.credentialProvider)
                    try KeychainManager.shared.save(user.phoneNumber, forKey: AuthKeys.phoneNumber)
                    try KeychainManager.shared.save(user.uid, forKey: AuthKeys.uid)
                    
                    // Вообще, не рекомендуется хранить приватные данные в юзер-дефолтс, но дз есть дз
                    try UserDefaultsManager.shared.save(credential.provider, for: AuthKeys.credentialProvider)
                    try UserDefaultsManager.shared.save(user.phoneNumber, for: AuthKeys.phoneNumber)
                    try UserDefaultsManager.shared.save(user.uid, for: AuthKeys.uid)
                    
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try auth.signOut()
            
            try KeychainManager.shared.delete(forKey: AuthKeys.credentialProvider)
            try KeychainManager.shared.delete(forKey: AuthKeys.phoneNumber)
            try KeychainManager.shared.delete(forKey: AuthKeys.uid)
            
            UserDefaultsManager.shared.delete(for: AuthKeys.credentialProvider)
            UserDefaultsManager.shared.delete(for: AuthKeys.phoneNumber)
            UserDefaultsManager.shared.delete(for: AuthKeys.uid)
            
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
