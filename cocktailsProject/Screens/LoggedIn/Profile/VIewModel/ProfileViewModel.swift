//
//  ProfileViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 25/2/23.
//

final class ProfileViewModel {
    private var authManager: AuthManager
    
    init () { self.authManager = AuthManager.shared }
    
    public var showAlert: ((
        String,
        String,
        (() -> Void)?
    ) -> Void)?
    
    public var goToSignInPage: (() -> Void)?

    public func saveData() {
        // DB.manager.saveData()
        // UserDefaults.saveData()
    }
    
    public func signOut() {
        authManager.signOut { [weak self] success, error in
            guard let strongSelf = self else { return }
            guard success, error == nil else {
                strongSelf.showAlert?(
                    "Error",
                    error!.localizedDescription,
                    nil
                )
                return
            }
            
            if success {
                strongSelf.showAlert? (
                    "Success",
                    "Successfully signed out. Returning you to the Sign-In page",
                    strongSelf.goToSignInPage
                )
            } else {
                strongSelf.showAlert? (
                    "Error",
                    "Unexpected error occured. Please, try again.",
                    nil
                )
            }
        }
    }
}
