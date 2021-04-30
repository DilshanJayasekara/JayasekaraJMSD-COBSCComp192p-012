//
//  LoginViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if((UserDefaults.standard.bool(forKey: "Login")))
        {
            self.performSegue(withIdentifier: "SignIntoHome", sender: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClickLogin(_ sender: Any) {
        if(validateLogin()){
            Login();
        }
    }
    
    @IBAction func btnClickRegister(_ sender: Any) {
        
    }
    @IBAction func btnClickForgetPassword(_ sender: Any) {
        
    }
    
    func validateLogin()-> Bool{
        if !isValidateEmail(email: txtEmail.text ?? ""){
            let alert = UIAlertController(title: "Error", message: "Please Check Your Email and Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }else if !isValidPassword(pwd: txtPassword.text ?? ""){
            let alert = UIAlertController(title: "Error", message: "Please Check Your Email and Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
        else
        {
            return true;
        }
    }
    func   checkLogin(){
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] authResult, error in
            guard self != nil else {return}
            if let error = error {
                print(error.localizedDescription)
            }
            if Auth.auth().currentUser != nil {
                print(Auth.auth().currentUser?.uid ?? "")
                self!.performSegue(withIdentifier: "SignIntoHome", sender: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: "Please Check Your Email and Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func Login()
    {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (authResult, error) in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
                let alert = UIAlertController(title: "Error", message: "Email is not allowed..!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            case .userDisabled:
              // Error: The user account has been disabled by an administrator.
                let alert = UIAlertController(title: "Error", message: "The user account has been disabled by an administrator.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            break
            case .invalidEmail:
                let alert = UIAlertController(title: "Error", message: "The email address is badly formatted.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            break
            case .wrongPassword:
              // Error: The password is invalid or the user does not have a password.
                let alert = UIAlertController(title: "Error", message: "The user name or password is invalid", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            break
            
            default:
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error: \(error.localizedDescription)")
            }
          } else {
                
                 UserDefaults.standard.set(true, forKey: "Login")
                self.performSegue(withIdentifier: "SignIntoHome", sender: nil)
          }
        }
    }
    
    func isValidateEmail(email:String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(pwd:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 6 characters total
        let password = pwd.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

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
