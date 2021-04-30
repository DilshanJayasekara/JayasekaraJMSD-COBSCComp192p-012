//
//  OrderViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-28.
//

import UIKit
import Firebase
//new Orders
public struct NewOrder: Codable {
    let id : String?
    let cusName : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case id
        case cusName
        case status
    }
}
//new Orders
public struct ReadyOrder: Codable {
    let id : String?
    let cusName : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case id
        case cusName
        case status
    }
}

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblOrderView: UITableView!

    
    var newOrders = [NewOrder]()
    var readyOrder = [ReadyOrder]()
    
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrderView.delegate = self;
        tblOrderView.dataSource = self;
        getOrderDetails()
        self.tblOrderView.reloadData()
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            return "Ready"
        }
        else
        {
            return "New"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(section == 0)
        {
            return readyOrder.count
        }
        else
        {
            return newOrders.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCell = tblOrderView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        if(indexPath.section == 0)
        {
            orderCell.lblOrderId.text = readyOrder[indexPath.row].id;
            orderCell.lblCustomerName.text = readyOrder[indexPath.row].cusName;
            orderCell.btnAccept.tag = Int(readyOrder[indexPath.row].id ?? "0") ?? 0
            orderCell.btnReject.tag = Int(readyOrder[indexPath.row].id ?? "0") ?? 0
            orderCell.btnAccept.backgroundColor = UIColor.orange
            orderCell.btnAccept.setTitle(readyOrder[indexPath.row].status, for: .normal)
            orderCell.btnReject.isHidden = true;
            
        }
        else
        {
            orderCell.btnAccept.tag = Int(newOrders[indexPath.row].id ?? "0") ?? 0
            orderCell.btnReject.tag = Int(newOrders[indexPath.row].id ?? "0") ?? 0
            orderCell.lblOrderId.text = newOrders[indexPath.row].id;
            orderCell.lblCustomerName.text = newOrders[indexPath.row].cusName;
            orderCell.isEditing = false;
        }
        return orderCell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section);
        if(indexPath.section == 0)
        {
            UserDefaults.standard.set(readyOrder[indexPath.row].id, forKey: "OrderId")
            UserDefaults.standard.set(readyOrder[indexPath.row].status, forKey: "Status")
            UserDefaults.standard.set(readyOrder[indexPath.row].cusName, forKey: "CusName")
            UserDefaults.standard.set(readyOrder[indexPath.row].status, forKey: "Status")
            print("Click")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ORDER_SHOW") as! ShowDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "OrderToDetails", sender: nil)
        }
    }
    func getOrderDetails()
    {
        let ref = Database.database().reference()
        ref.child("Orders").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let Orders = data as? [String: Any]{
                    self.newOrders.removeAll();
                    self.readyOrder.removeAll();
                    for item in Orders {
                        if let orderInfo = item.value as? [String: Any]{
                            print(orderInfo)
                                    let status = orderInfo["status"] as? String;
                                        if( "NEW" == status)
                                        {
                                            self.newOrders.append(NewOrder(id: orderInfo["orderId"] as? String,cusName: orderInfo["customer"] as? String, status: orderInfo["status"] as? String));
                                        }
                                        else if("PREPARATION" == status || "READY" == status){
                                            self.readyOrder.append(ReadyOrder(id: orderInfo["orderId"] as? String,cusName: orderInfo["customer"] as? String, status: orderInfo["status"] as? String));
                                        }
                                        else{
                                            
                                        }
                                    }
                                }
                                self.tblOrderView.reloadData()
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

