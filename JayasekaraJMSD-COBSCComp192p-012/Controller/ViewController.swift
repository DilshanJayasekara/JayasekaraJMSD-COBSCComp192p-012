//
//  ViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        if((UserDefaults.standard.bool(forKey: "Login")))
        {
            self.performSegue(withIdentifier: "LaunchtoHome", sender: nil)
        }
        else{
            self.performSegue(withIdentifier: "LaunchtoLogin", sender: nil)
        }
        })
    }


}

