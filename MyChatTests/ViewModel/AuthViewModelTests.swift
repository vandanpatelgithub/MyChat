//
//  AuthViewModelTests.swift
//  MyChatTests
//
//  Created by Vandan Patel on 10/14/20.
//

import XCTest
@testable import MyChat

class AuthViewModelTests: XCTestCase {
    func testLogInViewModel() {
        let vm = LogInViewModel(email: "email", password: "password")
        XCTAssertTrue(vm.formIsValid)
    }
    
    func testLogInViewModel_InvalidEmail() {
        let vm = LogInViewModel(email: "", password: "password")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testLogInViewModel_InvalidPassword() {
        let vm = LogInViewModel(email: "email", password: "")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testLogInViewModel_InvalidEmailPassword() {
        let vm = LogInViewModel(email: "", password: "")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testRegistrationViewModel() {
        let vm = RegistrationViewModel(email: "email", password: "password", fullName: "fullname", username: "username")
        XCTAssertTrue(vm.formIsValid)
    }
    
    func testRegistrationViewModel_InvalidEmail() {
        let vm = RegistrationViewModel(email: "", password: "password", fullName: "fullname", username: "username")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testRegistrationViewModel_InvalidPassword() {
        let vm = RegistrationViewModel(email: "email", password: "", fullName: "fullname", username: "username")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testRegistrationViewModel_InvalidFullname() {
        let vm = RegistrationViewModel(email: "email", password: "password", fullName: "", username: "username")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testRegistrationViewModel_InvalidUsername() {
        let vm = RegistrationViewModel(email: "email", password: "password", fullName: "fullName", username: "")
        XCTAssertFalse(vm.formIsValid)
    }
    
    func testRegistrationViewModel_InvalidAllFields() {
        let vm = RegistrationViewModel(email: "", password: "", fullName: "", username: "")
        XCTAssertFalse(vm.formIsValid)
    }
}
