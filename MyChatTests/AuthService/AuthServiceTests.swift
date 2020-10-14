//
//  AuthServiceTests.swift
//  MyChatTests
//
//  Created by Vandan Patel on 10/14/20.
//

import XCTest
@testable import MyChat

class AuthServiceTests: XCTestCase {
    
    let credentials = ModelMocks.registrationCredentials

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testUser() {
        let user = User(credentials: credentials, imageURL: "imageURL", uid: "uid")
        let dict = user.toDict
        XCTAssertEqual(dict["email"] as! String, "email")
        XCTAssertEqual(dict["fullName"] as! String, "fullname")
        XCTAssertEqual(dict["username"] as! String, "username")
        XCTAssertEqual(dict["uid"] as! String, "uid")
        XCTAssertEqual(dict["profileImageURL"] as! String, "imageURL")
    }
}
