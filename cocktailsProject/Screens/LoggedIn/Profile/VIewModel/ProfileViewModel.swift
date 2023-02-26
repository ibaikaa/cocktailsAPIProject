//
//  ProfileViewModel.swift
//  cocktailsProject
//
//  Created by ibaikaa on 25/2/23.
//

import UIKit

final class ProfileViewModel {
    private var authManager: AuthManager
    private var defaults: UserDefaultsManager
    
    init () {
        self.authManager = AuthManager.shared
        self.defaults = UserDefaultsManager.shared
    }
    
    public var showAlert: ( ( String, String, ( () -> Void)? ) -> Void)?
    
    public var goToSignInPage: (() -> Void)?
    
    public var setTextToTextField: ( (String?, UITextField) -> Void )?

    public func saveUsersData(
        name: String?,
        surname: String?,
        birthDate: String?,
        address: String?
    ) {
        guard
            let name = name,
            let surname = surname,
            let birthDate = birthDate,
            let address = address
        else {
            showAlert?(
                "Error",
                "Fill all of the fields to save!",
                nil
            )
            return
        }
        do {
            try defaults.save(name, for: UserKeys.name)
            try defaults.save(surname, for: UserKeys.surname)
            try defaults.save(birthDate, for: UserKeys.birthDate)
            try defaults.save(address, for: UserKeys.address)
            showAlert? (
                "Success!",
                "Succefully saved your data!",
                nil
            )
        } catch {
            showAlert?(
                "Error",
                error.localizedDescription,
                nil
            )
        }
    }
    
    public func updateTextField(_ textField: UITextField, for key: String) {
        do {
            let arrivedData = try defaults.retrieve(for: key)
            self.setTextToTextField?(
                arrivedData as? String,
                textField
            )
        } catch {
            showAlert? (
                "Error",
                error.localizedDescription,
                nil
            )
        }
    }
    
    public func signOut() {
        authManager.signOut { [weak self] result in
            switch result {
            case .success():
                self?.showAlert? (
                    "Success",
                    "Successfully signed out. Returning you to the Sign-In page",
                    self?.goToSignInPage
                )
            case .failure(let error):
                self?.showAlert? (
                    "Error",
                    error.localizedDescription,
                    nil
                )
            }
        }
    }
}
