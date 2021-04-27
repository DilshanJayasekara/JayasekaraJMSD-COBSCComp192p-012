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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClickLogin(_ sender: Any) {
        if(validateLogin()){
            checkLogin();
        }
    }
    
    @IBAction func btnClickRegister(_ sender: Any) {
        
    }
    @IBAction func btnClickForgetPassword(_ sender: Any) {
        
    }
    
    func validateLogin()-> Bool{
        if txtEmail.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please Check Your Email and Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }else if txtPassword.text == ""{
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
