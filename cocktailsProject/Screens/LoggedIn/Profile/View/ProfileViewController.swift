//
//  ProfileViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var viewModel: ProfileViewModel = { ProfileViewModel() }()
    
    private func initViewModel() {
        viewModel.showAlert = { [weak self] title, message, completion in
            DispatchQueue.main.async {
                self?.showAlert(
                    title: title,
                    message: message,
                    completion: completion
                )
            }
        }
        viewModel.goToSignInPage = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(
                    withIdentifier: SignInViewController.identifier
                )
                self?.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? ) {
        let alert = UIAlertController(
            title: title, message:
                message, preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: completion)
    }
    
    
    
    @IBOutlet weak var birthDateTextField: UITextField!
    
    @IBAction func logOut(_ sender: Any) {
        print("Sign out")
        viewModel.signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }
}
