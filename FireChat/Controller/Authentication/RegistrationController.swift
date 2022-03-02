//
//  RegistrationController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/17.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    // MARK: - Properties
    private var viewModel = RegistrationViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private var profileImage : UIImage?
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        return button
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
    
    private lazy var fullnameContainerView: InputContainterView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let containerView = InputContainterView(image: image,
                                                textField: fullnameTextField)
        return containerView
    }()
    
    private lazy var usernameContainerView: InputContainterView = {
        let image = UIImage(named: "ic_person_outline_white_2x")
        let containerView = InputContainterView(image: image,
                                                textField: usernameTextField)
        return containerView
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
    
    private let fullnameTextField: CustomTextField = {
        let tf = CustomTextField(placeHoler: "full name")
        return tf
    }()
    
    private let usernameTextField: CustomTextField = {
        let tf = CustomTextField(placeHoler: "user name")
        return tf
    }()
    
    private let signupButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.lightGray
        button.setHeight(height: 50)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: " Log In",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - selectors
    @objc func handleRegistration() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname,
                                                  username: username, profileImage: profileImage)
        showLoader(true, withText: "Signing you up")
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error {
                print("DEBUG: failed to create user \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        checkFormsStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        self.view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: self.view)
        plusPhotoButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
        paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                  passwordContainerView,
                                                  fullnameContainerView,
                                                  usernameContainerView,
                                                  signupButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        self.view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: self.view.leftAnchor,
                     right: self.view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        self.view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: self.view.leftAnchor,
                                     bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                     right: self.view.rightAnchor,
                                     paddingLeft: 32, paddingRight: 32)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        passwordTextField.addTarget(self,
                                    action: #selector(textDidChange),
                                    for: .editingChanged)
        fullnameTextField.addTarget(self,
                                 action: #selector(textDidChange),
                                 for: .editingChanged)
        usernameTextField.addTarget(self,
                                    action: #selector(textDidChange),
                                    for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        profileImage = image
        
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController: AuthenticationContollerProtocol {
    func checkFormsStatus() {
        if viewModel.formIsValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.purple
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.lightGray
        }
    }
}
