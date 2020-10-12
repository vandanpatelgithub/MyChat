//
//  RegistrationVC.swift
//  MyChat
//
//  Created by Vandan Patel on 10/4/20.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope") ?? UIImage(), textField: emailTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "person_outline"), textField: fullNameTextField)
    }()
    
    private lazy var usernameContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "person_outline"), textField: usernameTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "lock") ?? UIImage(), textField: passwordTextField)
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50.0)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Selectors
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else {
            viewModel.username = sender.text
        }
        isFormValid()
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullname = fullNameTextField.text,
              let username = usernameTextField.text?.lowercased(),
              let imageData = profileImage?.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: failed to upload the image with error \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG: failed to download the url with error \(error.localizedDescription)")
                    return
                }
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: failed to create the user with error \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email": email, "fullName": fullname, "profileImageURL": profileImageURL, "uid": uid, "username": username] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data) { [weak self] (error) in
                        if let error = error {
                            print("DEBUG: failed to upload the user data with error \(error.localizedDescription)")
                            return
                        }
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   usernameContainerView,
                                                   passwordContainerView,
                                                   signupButton])
        stack.axis = .vertical
        stack.spacing = 16.0
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.centerX(inView: view)
        alreadyHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func isFormValid() {
        if viewModel.formIsValid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}

// MARK: Image Picker Delegate

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2.0
        plusPhotoButton.layer.cornerRadius = 100
        
        dismiss(animated: true, completion: nil)
    }
}
