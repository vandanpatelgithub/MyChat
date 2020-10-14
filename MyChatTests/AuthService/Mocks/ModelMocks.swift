//
//  ModelMocks.swift
//  MyChatTests
//
//  Created by Vandan Patel on 10/14/20.
//

import Foundation
@testable import MyChat

class ModelMocks {
    static var registrationCredentials: RegistrationCredentials {
        return RegistrationCredentials(
            email: "email",
            password: "password",
            fullname: "fullname",
            username: "username",
            imageData: Data())
    }
}
