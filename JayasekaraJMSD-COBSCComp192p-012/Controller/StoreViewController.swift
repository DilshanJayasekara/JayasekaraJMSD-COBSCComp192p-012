//
//  StoreViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-23.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var PreviewView: UIView!
    @IBOutlet weak var CategoryView: UIView!
    @IBOutlet weak var MenuView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
              case 0:
                PreviewView.isHidden = false
                CategoryView.isHidden = true
                MenuView.isHidden = true
              case 1:
                PreviewView.isHidden = true
                CategoryView.isHidden = false
                MenuView.isHidden = true
              case 2:
                PreviewView.isHidden = true
                CategoryView.isHidden = true
                MenuView.isHidden = false
              default:
                PreviewView.isHidden = false
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
