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
struct MenuItem{
    var name:String
    var desc:String
    var price:Double
    var img:String
    var category:String
    var discount:Int
    var sellType:Bool
    var image:UIImage!
    func getJSON() -> NSMutableDictionary {
           let dict = NSMutableDictionary()
           dict.setValue(name, forKey: "name")
            dict.setValue(desc, forKey: "desc")
            dict.setValue(price, forKey: "price")
            dict.setValue(img, forKey: "img")
            dict.setValue(category, forKey: "category")
            dict.setValue(discount, forKey: "discount")
            dict.setValue(sellType, forKey: "sellType")
           return dict
       }
}

struct GroupMenuItems{
    var key:String
    var item:[MenuItem]
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
    var menuItem: [MenuItem] = [
      
   ]
    
    var groupMenuItems: [GroupMenuItems] = [
    
    ]
    let imageStore = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        //getFoodDetails()
        loadData()
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
        groupMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMenuItems[section].item.count ?? 0
    }
    
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(groupMenuItems.count > 0){
            return groupMenuItems[section].key
        }
        return ""
        
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let previewCell = tblPreviewView.dequeueReusableCell(withIdentifier: "PreviewCell", for: indexPath) as! PreviewTableViewCell
        previewCell.lblFoodName.text = groupMenuItems[indexPath.section].item[indexPath.row].name;
        print("Data :",groupMenuItems);
       // previewCell.lblFoodName.text = fooddem[indexPath.section].foodName
        //names[indexPath.section].[indexPath.row];
            
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
    func loadData(){
        
        
       var dat = MenuItem(name: "Food 01", desc: "This is food", price: 200, img: "test", category: "Category 1", discount: 5, sellType: true)
//
      self.ref.child("MenuItem").child("200").setValue(dat.getJSON())
        
           menuItem.removeAll()
           groupMenuItems.removeAll()
           
           let group = DispatchGroup()
     
        
        ref.child("MenuItem").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let foodItems = data as? [String: Any]{
                   
                    for itemInfo in foodItems {
                        if let val = itemInfo.value as? [String: Any]{
                            let item = MenuItem(name: val["name"] as! String, desc: val["desc"] as! String, price: val["price"] as! Double, img: val["img"] as! String, category: val["category"] as! String, discount: val["discount"] as! Int, sellType: val["sellType"] as! Bool)
                                   // print("test",foodInfo["name"] as!String)
                                
                            self.menuItem.append(item)
                                
                                    }
                                }
                    
                                let groupByCategory = Dictionary(grouping: self.menuItem) { (items) -> String in
                                        return items.category
                                    }
                 
                                    groupByCategory.forEach({(key,val) in
                 
                                        self.groupMenuItems.append(GroupMenuItems.init(key: key, item: val))
                                    })
                    self.tblPreviewView.reloadData()
                          }
                    }
             })
        
//        self.ref.child("MenuItem").getData {  (error, snapshot) in
//               if snapshot.exists() {
//
//                let dataChange = snapshot.value as! [String:Any]
//
//
//
//                  group.wait()
//
//
//               // dataChange.forEach({ (key,val) in
//
//                    print("values",dataChange["name"] as!String)
//
//           // })
//
////
////
////
////                  dataChange.forEach({ (key,val) in
//////
//////                  let items = MenuItem(name: val["name"] as! String, desc: val["desc"] as! String, price: val["price"] as! Double, img: val["img"] as! String, category: val["category"] as! String, discount: val["discount"] as! Int, sellType: val["sellType"] as! Bool)
//////
////
////
////                  /*  let item = MenuItem(name: val["name"] as! String, desc: val["desc"] as! String, price: val["price"] as! Double, img: val["img"] as! String, category: val["category"] as! String, discount: val["discount"] as! Int, val["sellType"] as! Bool)*/
////                    //self.menuItem.append(items)
////                    print(val);
////
////                  })
//
//
//                  group.notify(queue: .main) {
//
//
////                   let groupByCategory = Dictionary(grouping: menuItem) { (items) -> String in
////                       return items.category
////                   }
////
////                   groupByCategory.forEach({(key,val) in
////
////                       groupMenuItems.append(GroupMenuItems.init(key: key, item: val))
////                   })
////
////
////                   for (indexMain,val) in groupMenuItems.enumerated() {
////
////                       for (index,item) in val.item.enumerated() {
////                           self.imageStore.reference(withPath: "/\(item.img).jpg").getData(maxSize: 1 * 1024 * 1024, completion: {data,imageErr in
////
////                               if(imageErr != nil){
////
////                                   switch StorageErrorCode(rawValue: imageErr!._code) {
////                                   case .objectNotFound: break
////                                   default:break
////                                   }
////                               }else{
////                                   //if no error then update the revant cell against the index to with newly fetched food picture
////
////                                   provideImage(index: index, newImage:  UIImage(data: data!),indexMain : indexMain)
////
////                               }
////                           })
////                       }
////
////                   }
//
//
//
//                   self.tblPreviewView.reloadData()
//                  }
//
//               }else{
//                self.tblPreviewView.reloadData()
//               }
//
//           }
       }
    func provideImage(index:Int,newImage:UIImage?,indexMain: Int) {
            if(newImage == nil){
                return
            }
            if(index > groupMenuItems.count){
                return // very rare index out bound exception can occur sometimes
            }
            
            groupMenuItems[indexMain].item[index].image=newImage
            tblPreviewView.reloadData()
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
