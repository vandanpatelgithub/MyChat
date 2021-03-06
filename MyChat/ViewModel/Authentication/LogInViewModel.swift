//
//  LogInViewModel.swift
//  MyChat
//
//  Created by Vandan Patel on 10/10/20.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LogInViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        guard let email = email, let password = password else { return false }
        return !email.isEmpty && !password.isEmpty
    }
}
