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
        
        auth.signIn(with: credential) { result, error in
            guard let result = result, error == nil else {
                completion(false, error)
                return
            }
            let user = result.credential
            completion(true, nil)
        }
    }
    
    public func signOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try auth.signOut()
            completion(true, nil)
        } catch let signOutError {
            completion(false, signOutError)
        }
    }
}
