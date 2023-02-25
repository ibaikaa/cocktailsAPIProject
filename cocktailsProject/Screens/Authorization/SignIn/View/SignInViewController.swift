//
//  SignInViewController.swift
//  cocktailsProject
//
//  Created by ibaikaa on 23/2/23.
//

import UIKit

class SignInViewController: UIViewController {
    class var identifier: String { String(describing: self) }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var smsCodeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private lazy var viewModel: SignInViewModel = { SignInViewModel() }()

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
        
        viewModel.goToMainPage = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(
                    withIdentifier: MainTabBarController.identifier
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
    
    private func setupSubviews() {
        getCodeButton.isEnabled = false
        signInButton.isEnabled = false
        smsCodeTextField.isEnabled = false
    }
    
    private func configureTextFields() {
        phoneNumberTextField.delegate = self
        smsCodeTextField.delegate = self
    }

    @IBAction func checkCodeTapped(_ sender: Any) {
        viewModel.getSMSCode(phoneNumber: phoneNumberTextField.text)
        smsCodeTextField.isEnabled = true
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        viewModel.verifyCodeAndTryToSignIn(smsCode: smsCodeTextField.text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupSubviews()
        configureTextFields()
    }
}

// MARK: UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        switch textField {
        case phoneNumberTextField:
            getCodeButton.isEnabled = true
        case smsCodeTextField:
            signInButton.isEnabled = true
        default: ()
        }
    }
    
    
}
