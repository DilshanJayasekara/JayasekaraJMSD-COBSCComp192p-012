//
//  CategoryViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//
import UIKit
import Firebase

public struct Category: Codable {
    let CategoryId   :String?
    let CategoryName :String?
    
    enum CodingKeys: String, CodingKey {
        case CategoryId
        case CategoryName
    }
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var tblCategoryView: UITableView!
    
    var ref = Database.database().reference()
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCatogaryDetails()
                tblCategoryView.delegate = self;
                tblCategoryView.dataSource = self;
       // getCatogaryDetails()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func btnClickAdd(_ sender: Any) {
        let randomInt = Int.random(in: 1..<10000)
        if (txtCategory.text == "") {
            let alert = UIAlertController(title: "Failed", message: "Please Enter Category Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        else{
            self.ref.child("Categories").child("\(randomInt)").setValue(["CategoryName": self.txtCategory.text!])
            let alert = UIAlertController(title: "Success", message: "Catogary Added Successfully..!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            txtCategory.text="";
        }
    }
    
    //Category Table View Handle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.categories.count;
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let categoryCell = tblCategoryView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
            categoryCell.lblCategoryName.text = categories[indexPath.row].CategoryName;
            return categoryCell;
}
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if (editingStyle == .delete) {
                let alert = UIAlertController(title: "Confirm", message: "Are you sure want to delete the category?", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.deleteCategory(id: self.categories[indexPath.row].CategoryId ?? "")
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(alert, animated: true, completion: nil)
                
            }
        }
    func deleteCategory(id:String){
        let ref = Database.database().reference()
        ref.child("Categories").removeValue();
        self.tblCategoryView.reloadData()
        }

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
                                self.tblCategoryView.reloadData()
                          }
                    }
             })
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
