//
//  LogInVC.swift
//  MyChat
//
//  Created by Vandan Patel on 10/4/20.
//

import UIKit

class LogInVC: UIViewController {
    
    // MARK: - Properties
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var emailContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.setHeight(height: 50.0)
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = .white
        
        containerView.addSubview(imageView)
        imageView.centerY(inView: containerView)
        imageView.anchor(left: containerView.leftAnchor, paddingLeft: 8)
        imageView.setDimensions(height: 24, width: 28)
        
        containerView.addSubview(emailTextField)
        emailTextField.centerY(inView: containerView)
        emailTextField.anchor(left: imageView.rightAnchor, right: containerView.rightAnchor, paddingLeft: 8)
        
        return containerView
    }()
    
    private lazy var passwordContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock")
        imageView.tintColor = .white
        
        containerView.addSubview(imageView)
        imageView.centerY(inView: containerView)
        imageView.anchor(left: containerView.leftAnchor, paddingLeft: 8)
        imageView.setDimensions(height: 28, width: 28)
        
        containerView.addSubview(passwordTextField)
        passwordTextField.centerY(inView: containerView)
        passwordTextField.anchor(left: imageView.rightAnchor, right: containerView.rightAnchor, paddingLeft: 8)
        
        containerView.setHeight(height: 50.0)
        return containerView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.textColor = .white
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.backgroundColor = .systemRed
        button.setHeight(height: 50.0)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        setupImageViewConstraints()
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16.0
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
    // MARK: - Constraints
    
    fileprivate func setupImageViewConstraints() {
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
    }
}
