//
//  PreviewViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import Firebase
public struct Food: Codable {
    let foodName :String?
    let foodDesc: String?
    let foodPrice: String?
    let fooddisc: String?
    let foodCategory: String?
    let foodImage: String?
    let status: String?
    enum CodingKeys: String, CodingKey {
        case foodName
        case foodDesc
        case foodPrice
        case fooddisc
        case foodCategory
        case foodImage
        case status
    }
}

class PreviewViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblPreviewView: UITableView!
    var ref = Database.database().reference()
    var foods = [Food]()
    
    struct Details{
        var detail : [String:[String:[String]]]!
    }
    var names = ["Vegetables": ["Tomato":["1000","200"], "Potato":["1000","200"], "Lettuce":["1000","200"]], "Fruits": ["Apple":["1000","200"], "Banana":["1000","200"]]]
      // and continue
    
    struct CategoryObjects {

            var CategoryName : String!
            var FoodDetails  : [String:[String]]!
        }
    struct food {
        var foodName : String!
        var items : [String]!
    }
    var CategoryobjectArray = [CategoryObjects]()
    var fooddem = [food]()
    var details = [Details]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodDetails()
        tblPreviewView.delegate = self;
        tblPreviewView.dataSource = self;
        // Do any additional setup after load ing the view.
        CategoryobjectArray.removeAll()
        
        for (key1, value) in names {
                self.CategoryobjectArray.append(CategoryObjects(CategoryName: key1, FoodDetails: value));
                    for(key2, value1) in value
                    {
                        self.fooddem.append(food(foodName: key2, items: value1))
                    }
               }
        self.tblPreviewView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("CategoryobjectArray.count : \(CategoryobjectArray.count)")
        return CategoryobjectArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CategoryobjectArray[section].CategoryName
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("CategoryobjectArray[section].FoodId.count : \(CategoryobjectArray[section].FoodDetails.count)")
        return CategoryobjectArray[section].FoodDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let previewCell = tblPreviewView.dequeueReusableCell(withIdentifier: "PreviewCell", for: indexPath) as! PreviewTableViewCell
        //previewCell.lblFoodName.text = foods[indexPath.row].foodName ?? "";
       // previewCell.lblFoodName.text = fooddem[indexPath.section].foodName
        //names[indexPath.section].[indexPath.row];
        var count = 0;
        for (key, value) in CategoryobjectArray[indexPath.section].FoodDetails
        {
            if(count == indexPath.row)
            {
                previewCell.lblFoodName.text = key;
                previewCell.lblDescription.text = value[0];
                    
            }
            count = count + 1;
        }
            
        
        return previewCell;
    }
    
    func getFoodDetails() {
        CategoryobjectArray.removeAll()
        ref.child("foods").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let foodItems = data as? [String: Any]{
                    self.foods.removeAll();
                    for itemInfo in foodItems {
                        if let foodInfo = itemInfo.value as? [String: Any]{
                            for(key1, value1) in foodInfo{
                                print("---First---")
                                print("\(key1) -> \(value1)")
                                if let food = value1 as? [String]{
                                       
                                    print("");
                                        
                                    }
                                
                                }
                            
                            //print(itemInfo)
                            //print("\(foodInfo.keys)")
                            //print(foodInfo["CategoryName"] as? String)
                            //print(foodInfo.count)
                            //let value  = ("\(foodInfo.keys)")
                            
                        }
                    }}}
            
           
             })
       // let new = CategoryObjects(CategoryName: "Category", FoodDetails: self.fooddem)
        //self.CategoryobjectArray.append(new);
        //self.tblPreviewView.reloadData()
        
        ref.child("foods").child("6254").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let foodItems = data as? [String: Any]{
                    self.foods.removeAll();
                    for itemInfo in foodItems {
                        if let foodInfo = itemInfo.value as? [String: Any]{
                            let singlefood = Food(foodName: foodInfo["foodName"] as? String, foodDesc: foodInfo["description"] as? String, foodPrice: foodInfo["price"] as? String, fooddisc: foodInfo["discount"] as? String, foodCategory: foodInfo["category"] as? String, foodImage: foodInfo["image"] as? String,status: foodInfo["status"] as? String)
                                print(foodInfo["foodName"] ?? "")
                                    self.foods.append(singlefood)
                                    }
                                }
                                self.tblPreviewView.reloadData()
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
