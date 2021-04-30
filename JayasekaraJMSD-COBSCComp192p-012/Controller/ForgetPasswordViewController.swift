//
//  ForgetPasswordViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import Firebase
class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnClickResetPassword(_ sender: Any) {
        if txtEmail.text?.isEmpty == true{
                        let alert = UIAlertController(title: "Error", message: "Please Enter Your Email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                }
                    else{
                        Auth.auth().sendPasswordReset(withEmail:txtEmail.text! ) {  error in
                            if error != nil {
                                    let alert = UIAlertController(title: "Failed", message: "Please Meet Your Service Provider", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    return
                                }
                            let alertController: UIAlertController = UIAlertController(title: "Success", message: "Please check your Email to reset the password ", preferredStyle: .alert)

                                      let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                                        self.dismiss(animated: true, completion: nil)
                                      }
                                      alertController.addAction(okAction)
                                      self.present(alertController, animated: true, completion: nil)
                            
                            
                        }
                    }
        }
    
    
    @IBAction func btnClickCancle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
