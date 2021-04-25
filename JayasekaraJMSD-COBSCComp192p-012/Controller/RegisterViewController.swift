//
//  RegisterViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-22.
//

import UIKit
import Firebase
import SPAlert
class RegisterViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func btnRegisterClick(_ sender: Any) {
        SignUp();
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func  SignUp(){
        if txtMobile.text?.isEmpty == true{
            SPAlert.present(title: "Error", message: "Please Enter Correct Mobile Number", preset: .custom(UIImage.init(named: "Error")!))
            return
        }
        if !isValidEmail(txtEmail.text!){
            SPAlert.present(title: "Error", message: "Email is not allowed..!", preset: .custom(UIImage.init(named: "Error")!))
            return
        }
        if !isValidPassword(txtPassword.text!){
            SPAlert.present(title: "Error", message: "Please Enter Correct Password", preset: .custom(UIImage.init(named: "Error")!))
            return
        }
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { authResult, error in
          // ...
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                  // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    SPAlert.present(title: "Error", message: "Email is not allowed..!", preset: .custom(UIImage.init(named: "Error")!))
                    break
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    SPAlert.present(title: "Error", message: "The email address is already in use by another account.", preset: .custom(UIImage.init(named: "Error")!))
                    break
                case .invalidEmail:
                    SPAlert.present(title: "Error", message: "The email address is badly formatted", preset: .custom(UIImage.init(named: "Error")!))
                    break
                case .weakPassword:
                    SPAlert.present(title: "Error", message: "The password must be 6 characters long or more .", preset: .custom(UIImage.init(named: "Error")!))
                    break
                default:
                    SPAlert.present(title: "Error", message: "Something is wrong please check your networks", preset: .custom(UIImage.init(named: "Error")!))
                }
              } else {
                print("User signs up successfully")
                
        
              }
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
        
    func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
