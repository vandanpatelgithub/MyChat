//
//  RegistrationViewModel.swift
//  MyChat
//
//  Created by Vandan Patel on 10/10/20.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullName: String?
    var username: String?
    
    var formIsValid: Bool {
        guard let email = email,
              let password = password,
              let fullName = fullName,
              let username = username else { return false }
        return !email.isEmpty && !password.isEmpty && !fullName.isEmpty && !username.isEmpty
    }
}
