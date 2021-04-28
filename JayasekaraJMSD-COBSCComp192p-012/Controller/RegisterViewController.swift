//
//  RegisterViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnClickRegister(_ sender: Any) {
        SignUp()
    }
    
    @IBAction func btnClickLog(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @IBAction func btnClickForget(_ sender: Any) {
    }
    func SignUp()
    {
            Auth.auth().createUser(withEmail: txtEmail.text!,password: txtPassword.text!) { (authResult, error) in
                if let error = error as NSError? {
                                switch AuthErrorCode(rawValue: error.code) {
                                case .operationNotAllowed:
                                    let alert = UIAlertController(title: "Error", message: "Email is not allowed..!", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                    break
                                case .emailAlreadyInUse:
                                    let alert = UIAlertController(title: "Error", message: "The email address is already in use by another account.", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                    break
                                  
                                case .invalidEmail:
                                    let alert = UIAlertController(title: "Error", message: "The email address is badly formatted. ", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                    break
                                case .weakPassword:
                                    let alert = UIAlertController(title: "Error", message: "The password must be 6 characters long or more . ", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                    break
                                default:
                                    let alert = UIAlertController(title: "Error", message: "Something is wrong", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                }
                              }
                print("User signs up successfully")
              //  let newUserInfo = Auth.auth().currentUser
                self.ref.child("users").child(self.txtMobile.text ?? "0").setValue(["email": self.txtEmail.text!])
                UserDefaults.standard.set(self.txtMobile.text, forKey: "mobile")
                if error != nil {
                    let alert = UIAlertController(title: "Failed", message: "Please Check you network..!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    return
                }
            let alertController: UIAlertController = UIAlertController(title: "Success", message: "User Registration is Successful", preferredStyle: .alert)
                      let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                        self.performSegue(withIdentifier: "SingUpToHome", sender: nil)
                      }

                      alertController.addAction(okAction)
                      self.present(alertController, animated: true, completion: nil)
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
