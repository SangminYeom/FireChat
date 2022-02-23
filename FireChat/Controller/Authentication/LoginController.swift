//
//  LoginController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/17.
//

import UIKit
import Firebase
import JGProgressHUD

protocol AuthenticationContollerProtocol {
    func checkFormsStatus()
}

class LoginController: UIViewController {
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: InputContainterView = {
        let image = UIImage(named: "ic_mail_outline_white_2x")
        let containerView = InputContainterView(image: image,
                                                textField: emailTextField)
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainterView = {
        let image = UIImage(named: "lock")
        let containerView = InputContainterView(image: image,
                                                textField: passwordTextField)
        return containerView
    }()
    
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.lightGray
        button.setHeight(height: 50)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeHoler: "email")
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(placeHoler: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Sign Up",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        showLoader(true, withText: "Logging in")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: failed to login \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            
            // conversationController에서 loginController를 rootview로 갖는 navigationController를 present 했으니...
            // dismiss로 내려준다.
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignup() {
        let controller = RegistrationController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormsStatus()
    }
    
    // MARK: - Helpers
    func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = .systemPurple
        
        configureGradientLayer()
        
        self.view.addSubview(iconImage)
        iconImage.centerX(inView: self.view)
        iconImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                  passwordContainerView,
                                                  loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        self.view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: self.view.leftAnchor,
                     right: self.view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        self.view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: self.view.leftAnchor,
                                     bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                     right: self.view.rightAnchor,
                                     paddingLeft: 32, paddingRight: 32)
        
        emailTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        passwordTextField.addTarget(self,
                                    action: #selector(textDidChange),
                                    for: .editingChanged)
    }
    
}

extension LoginController: AuthenticationContollerProtocol {
    func checkFormsStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.purple
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.lightGray
        }
    }
}
