//
//  LoginUiTest.swift
//  JayasekaraJMSD-COBSCComp192p-012UITests
//
//  Created by Dilshan Jayasekara on 2021-04-30.
//

import XCTest

class LoginUiTest: XCTestCase {

    override func setUp() {
         
           // In UI tests it is usually best to stop immediately when a failure occurs.
           continueAfterFailure = false

          
       }
    
    func testLogin(){
           let app = XCUIApplication()
           app.launch()
        
        let emailField = app.textFields["emailtext"]
                let pwdField = app.secureTextFields["pwdtext"]
                let btn = app.buttons["loginbtn"]
               
              
                emailField.tap()
                emailField.typeText("dilshan@gmail.com")
        
            pwdField.tap()
               pwdField.typeText("Test@123")
        btn.tap()
                
               
    }

}
