//
//  AccountViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-29.
//

import UIKit
import Firebase

public struct Item: Codable {
    let name : String?
    let price : String?
    

    enum CodingKeys: String, CodingKey {
        case name
        case price
    }
}

public struct Recipt: Codable {
    let date : String?
    let item : String?
    let price : String?
    let total : String?
    

    enum CodingKeys: String, CodingKey {
        case date
        case item
        case price
        case total
    }
}
class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tblAccountView: UITableView!
    var ref = Database.database().reference()
    var items = [Item]()
    var recipts = [Recipt]()
    var cellitem :String!
    var cellprice :String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAccountView.delegate = self;
        tblAccountView.dataSource = self;
        getReciptDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPrintHistoryClick(_ sender: Any) {
        print("History..!")
    }
    
    @IBAction func btnMenuClick(_ sender: Any) {
        print("Menu....!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reciptCell = tblAccountView.dequeueReusableCell(withIdentifier: "ReciptItemCell", for: indexPath) as! AccountTableViewCell
        reciptCell.lblOrderDate.text = recipts[indexPath.row].date;
        reciptCell.lblItems.text = recipts[indexPath.row].item;
        reciptCell.lblPrice.text = recipts[indexPath.row].price;
        reciptCell.lblTotal.text = recipts[indexPath.row].total;
        return reciptCell
        
    }
    func getReciptDetails(){
        items.removeAll();
        recipts.removeAll();
        
        ref.child("Orders").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let orders = data as? [String: Any]{
                    self.recipts.removeAll()
                    for order in orders {
                        if let OrderInfo = order.value as? [String: Any]{
                            self.items.removeAll();
                            print("Inside 01")
                            OrderInfo["items"]
                            self.recipts.append(Recipt(date: "A", item: self.cellitem, price: "C", total: "D"));
                                    }
                                }
                                self.tblAccountView.reloadData()
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
