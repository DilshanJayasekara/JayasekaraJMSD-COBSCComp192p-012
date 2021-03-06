//
//  LoginFlow.swift
//  JayasekaraJMSD-COBSCComp192p-012Tests
//
//  Created by Dilshan Jayasekara on 2021-04-30.
//

import XCTest

class LoginFlow: XCTestCase {

    let authService = AuthService()
    func testValidEmail(){
        let result = authService.isValidateEmail(email: "dilshan@gmail.com")
        XCTAssertEqual(result, true)
    }
    
    func testInvalidEmail(){
        let result = authService.isValidateEmail(email: "dilshangmail.com.asjdas")
               XCTAssertEqual(result, false)
    }
    
    func testValidPassword(){
        let result = authService.isValidPassword(pwd: "Test@123")
        XCTAssertEqual(result, true)
    }
    
    func  testInvalidPassword(){
        let result = authService.isValidPassword(pwd: "Test123")
               XCTAssertEqual(result, false)
    }

}
