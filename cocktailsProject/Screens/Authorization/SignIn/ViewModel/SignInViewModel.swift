//
//  SignInViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 24/2/23.
//

final class SignInViewModel {
    private var authManager: AuthManager
    
    init () { self.authManager = AuthManager.shared }
    
    public var showAlert: ((
        String,
        String,
        (() -> Void)?
    ) -> Void)?
    public var goToMainPage: (() -> Void)?
    
    public func getSMSCode(phoneNumber: String?) {
        guard
            let phoneNumber = phoneNumber, !phoneNumber.isEmpty,
            Int(phoneNumber) != nil
        else {
            showAlert?(
                "Error!",
                "The field for phone number must be filled and contain only digits!",
                nil
            )
            return
        }
        
        authManager.checkPhoneNumberAndSendSMSCode(phoneNumber: phoneNumber) { [weak self] success, error in
            if let error = error {
                self?.showAlert?(
                    "Error",
                    error.localizedDescription,
                    nil
                )
            }
        }
    }
    
    public func verifyCodeAndTryToSignIn(smsCode: String?) {
        guard
            let smsCode = smsCode, !smsCode.isEmpty
        else {
            showAlert?(
                "Error!",
                "The sms-code field must be filled!",
                nil
            )
            return
        }
        
        authManager.verifyCodeAndTryToSignIn(smsCode: smsCode) { [weak self] success, error in
            if let error = error {
                self?.showAlert?(
                    "Error",
                    error.localizedDescription,
                    nil
                )
            }
            
            if success {
                self?.showAlert?(
                    "Success",
                    "Succesfully signed up with phone number. Getting you to the main page.",
                    self?.goToMainPage
                )
            } else {
                self?.showAlert?(
                    "Error",
                    "Unexpected error occured. Please, try again later",
                    nil
                )
            }
        }
    }
}
