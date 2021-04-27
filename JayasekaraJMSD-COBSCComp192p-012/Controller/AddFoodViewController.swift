//
//  AddFoodViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-26.
//

import UIKit
import Firebase
import FirebaseStorage
class AddFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var pvCategory: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBAction func btnCheckBoxClick(_ sender: Any) {
            if(btnclick%2 == 1)
            {
                btnAdd.isEnabled = true;
                self.btnAdd.alpha = 1.0
            }
            else{
                btnAdd.isEnabled = false;
                self.btnAdd.alpha = 0.5
            }
        btnclick = btnclick + 1;
    }
    var btnclick = 1;
    
    var foodName    = ""
    var foodDesc    = ""
    var foodDisc    = ""
    var foodPrice   = ""
    var foodCategory = ""
    
    var pickerData: [String] = [String]()
    
    @IBAction func btnClickAdd(_ sender: Any) {
        AddFood();
    }
    //var ref: DatabaseReference!
    var ref = Database.database().reference()
    var randomInt = Int.random(in: 1000..<10000)
    var imageURL = ""
    private let storage = Storage.storage().reference()
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //tab action to Image Viewer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            FoodImage.isUserInteractionEnabled = true
            FoodImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
              self.pvCategory.delegate = self
              self.pvCategory.dataSource = self
        //picker data
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        btnAdd.isEnabled = false;
        self.btnAdd.alpha = 0.5
    }
    
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        // Number of columns of data
        func numberOfComponents(in pickerView: UIPickerView) ->Int {
            return 1
        }
        
        // The number of rows of data
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) ->Int {
            return pickerData.count
        }
        
        // The data to return fopr the row and component (column) that's being passed in
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
               case pvCategory:
        self.foodCategory =  pickerData[row]// This gives only the row value but  need string value*
                break;
        default: break
            
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)

        // Your action
    }
    
    //Add food to database
    func AddFood(){
        foodName    = self.txtName.text ??  "";
        foodDesc    = self.txtDescription.text ?? "";
        foodDisc    = self.txtDiscount.text ?? "";
        foodPrice   = self.txtPrice.text ?? "";
    
        self.ref.child("foods").child("0766414584").child("\(randomInt)").setValue(
            ["foodName": self.foodName,
             "description": self.foodDesc,
             "Price": self.foodPrice,
             "image": self.imageURL,
             "category": self.foodCategory,
            "discount":self.foodDisc])
    }
    
    //Insert Image to fire Store
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
                return
            }
            guard let imageData = image.pngData() else {
                return
            }
        storage.child("foods/0766414584").child("\(self.randomInt)").child("image.png").putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Faild to Upload")
                    return
                }
                print("Upload Success")
                self.storage.child("foods/0766414584").child("\(self.randomInt)").child("image.png").downloadURL(completion: {url, error in
                    guard let url = url, error == nil else{
                        return
                    }
                    let urlString = url.absoluteString
                    DispatchQueue.main.async {
                        self.FoodImage .image = image
                    }
                    self.imageURL = urlString;
                    print("URL: \(urlString)")
                    UserDefaults.standard.set(urlString, forKey: "url")
                })
                
            })
        }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
          picker.dismiss(animated: true, completion: nil)
      }
    func validation()->Bool{
        return true;
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
