//
//  PreviewViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import Firebase
import AlamofireImage
struct MenuItem{
    var id:String
    var name:String
    var description:String
    var price:Double
    var image:String
    var category:String
    var discount:Int
    var cellActive:Bool
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case image
        case category
        case discount
        case cellActive
    }
}

struct GroupMenuItems{
    var key:String
    var item:[MenuItem]
}
class PreviewViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblPreviewView: UITableView!
    var ref = Database.database().reference()
    var menuItem: [MenuItem] = [
      
   ]
    
    var groupMenuItems: [GroupMenuItems] = [
    
    ]
    let imageStore = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPreviewView.reloadData()
        getFoodDetails()
        tblPreviewView.delegate = self;
        tblPreviewView.dataSource = self;
        // Do any additional setup after load ing the view.
        self.tblPreviewView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        groupMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMenuItems[section].item.count
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
        previewCell.lblDescription.text = groupMenuItems[indexPath.section].item[indexPath.row].description;
        previewCell.lblPrice.text = String(groupMenuItems[indexPath.section].item[indexPath.row].price);
        previewCell.lblDiscount.text = "\(groupMenuItems[indexPath.section].item[indexPath.row].discount) % off"
        if let url = URL(string: self.groupMenuItems[indexPath.section].item[indexPath.row].image ) {
            previewCell.imgViewFood.af_setImage(withURL: url)
                        }
        previewCell.switchActive.tag = Int(groupMenuItems[indexPath.section].item[indexPath.row].id) ?? 0;
        previewCell.switchActive.isOn = groupMenuItems[indexPath.section].item[indexPath.row].cellActive
        return previewCell;
    }
    
    func getFoodDetails(){
        ref.child("Foods").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let foodItems = data as? [String: Any]{
                    self.menuItem.removeAll()
                    self.groupMenuItems.removeAll()
                    for itemInfo in foodItems {
                        if let val = itemInfo.value as? [String: Any]{
                            let item = MenuItem(id: val["id"] as! String,name: val["name"] as! String, description: val["description"] as! String, price: val["price"] as! Double, image: val["image"] as! String, category: val["category"] as! String, discount: val["discount"] as! Int, cellActive: val["cellActive"] as! Bool)
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
