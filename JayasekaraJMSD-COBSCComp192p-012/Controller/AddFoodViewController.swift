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
    var foodCategoryId = "123"
    var categories = [Category]()
    var randomInt = Int.random(in: 1000..<10000);
    @IBAction func btnClickAdd(_ sender: Any) {
        if(Validation())
        {
            AddFood();
        }
    }
    //var ref: DatabaseReference!
    var ref = Database.database().reference()
    var imageURL = ""
    private let storage = Storage.storage().reference()
    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //get Category
        getCatogaryDetails()
        //tab action to Image Viewer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            FoodImage.isUserInteractionEnabled = true
            FoodImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
              self.pvCategory.delegate = self
              self.pvCategory.dataSource = self
        //picker data
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
            return categories.count
        }
        
        // The data to return fopr the row and component (column) that's being passed in
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categories[row].CategoryName;
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
               case pvCategory:
                self.foodCategory = categories[row].CategoryName ?? ""// This gives only the row value but  need string value*
                self.foodCategoryId = categories[row].CategoryId ?? ""
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
    //Get Category Details
    func getCatogaryDetails() {
        
        let ref = Database.database().reference()
        ref.child("Categories").observe(.value, with:{
            (snapshot) in
                        
            if let data = snapshot.value {
                if let categoryItems = data as? [String: Any]{
                    self.categories.removeAll();
                    for itemInfo in categoryItems {
                        if let foodInfo = itemInfo.value as? [String: Any]{
                            let singleCategory = Category(
                                CategoryId: itemInfo.key, CategoryName: foodInfo["CategoryName"] as? String)
                                    self.categories.append(singleCategory)
                                    }
                                }
                    self.pvCategory.reloadAllComponents();
                               
                          }
                    }
             })
}

    
    //Add food to database
    func AddFood(){
        randomInt = Int.random(in: 1000..<10000);
        foodName    = self.txtName.text ??  "";
        foodDesc    = self.txtDescription.text ?? "";
        foodDisc    = self.txtDiscount.text ?? "";
        foodPrice   = self.txtPrice.text ?? "";
        if (txtName.text == "" || txtDescription.text == "" || txtDiscount.text == "" || txtPrice.text == "")
                      {
                    let alert = UIAlertController(title: "Error", message: "Fields Cannot be Empty", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                      }
        
        self.ref.child("Foods").child("\(self.randomInt)").setValue(
            ["id" : "\(self.randomInt)",
             "name": self.foodName,
             "description": self.foodDesc,
             "price": Double(self.foodPrice) ?? 0,
             "image": self.imageURL,
             "category": self.foodCategory,
            "discount": Double(self.foodDisc) ?? 0,
            "cellActive":true])
        let alert = UIAlertController(title: "Success", message: "Item Added Successfully", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
        cleanAll();
    }
    
    //Insert Image to fire Store
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        randomInt = Int.random(in: 1000..<10000);
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
                return
            }
            guard let imageData = image.pngData() else {
                return
            }
        storage.child("foods").child("\(self.randomInt)").child("image.png").putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Faild to Upload")
                    return
                }
                print("Upload Success")
                self.storage.child("foods").child("\(self.randomInt)").child("image.png").downloadURL(completion: {url, error in
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
    func cleanAll(){
        txtName.text = "";
        txtPrice.text = "";
        txtDiscount.text = "";
        txtDescription.text = "";
        FoodImage.image = UIImage(named: "photo.png");
    }
    func Validation()->Bool{
        if(txtName.text  == "" || txtPrice.text == "" || txtDiscount.text == "" || txtDescription.text == "" )
        {
            let alert = UIAlertController(title: "Error", message: "Please Fill All Fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else{
            return true
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
