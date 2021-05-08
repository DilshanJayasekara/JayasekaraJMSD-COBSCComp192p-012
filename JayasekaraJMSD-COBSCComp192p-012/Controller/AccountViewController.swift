//
//  AccountViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-29.
//

import UIKit
import Firebase

public struct Recipt: Codable {
    let id   : String?
    let date : String?
    var food : String?
    var price : Double?
    let total : Double?
    

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case food
        case price
        case total
    }
}

public struct Item: Codable {
    let item : String?
    let price : String?
    
    enum CodingKeys: String, CodingKey {
        case item
        case price
    }
}
class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var tblAccountView: UITableView!
    @IBOutlet weak var dateTimepic: UIDatePicker!
    var ref = Database.database().reference()
    var recipts = [Recipt]()
    var items = [Item]()
    var cellitem :String!
    var cellprice :String!
    var item = "";
    var price = "";
    var total = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAccountView.delegate = self;
        tblAccountView.dataSource = self;
        getReciptDetails()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPrintClick(_ sender: Any) {
        var markuptext=""
             

              
        for value in recipts{
            markuptext += "<tr> <td> \(String(value.date ?? "")) </td> <td> \(String(value.food ?? "")) </td> <td> \(String(value.price ?? 0)) </td> </tr>"
                      
              }
              
              var temp="<center><table><tr><th>Date</th><th>Name</th><th>Price</th></tr>\(markuptext)</table></center>"
                  printRecipt(text: temp)
    }
    @IBAction func btnPrintHistoryClick(_ sender: Any) {
        print("History..!")
        var markuptext=""
        for value in recipts{
            markuptext += "<tr> <td> \(String(value.date ?? "")) </td> <td> \(String(value.food ?? "")) </td> <td> \(String(value.price ?? 0)) </td> </tr>"
                      
              }
              
              var temp="<center><table><tr><th>Date</th><th>Name</th><th>Price</th></tr>\(markuptext)</table></center>"
                  printRecipt(text: temp)
    }
    
    func printRecipt(text:String){
                let printInfo = UIPrintInfo(dictionary:nil)
                printInfo.outputType = UIPrintInfo.OutputType.grayscale
                printInfo.jobName = "Order Details"
                printInfo.orientation = .portrait

                let printController = UIPrintInteractionController.shared
                printController.printInfo = printInfo
                printController.showsNumberOfCopies = false
                    
                let formatter = UIMarkupTextPrintFormatter(markupText: text)
                printController.printFormatter = formatter
                
                printController.present(animated: true, completionHandler: nil)
    }
    
    @IBAction func btnMenuClick(_ sender: Any) {
        print("Menu....!")
        UserDefaults.standard.set(false, forKey: "Login")
        self.performSegue(withIdentifier: "AccountToLogin", sender: nil)
    }
    
    @IBAction func btnSearchClick(_ sender: Any) {
        getReciptDetails();
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reciptCell = tblAccountView.dequeueReusableCell(withIdentifier: "ReciptItemCell", for: indexPath) as! AccountTableViewCell
        reciptCell.lblOrderDate.text = recipts[indexPath.row].date;
        reciptCell.lblItems.text = recipts[indexPath.row].food;
        reciptCell.lblPrice.text = String(recipts[indexPath.row].price ?? 0);
        reciptCell.lblTotal.text = String(recipts[indexPath.row].total ?? 0);
        return reciptCell
    }
    func getReciptDetails(){
        recipts.removeAll();
        self.total = 0.0;
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        var d1=dateFormatter.string(from: dateTimepic.date);
        
        ref.child("Orders").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let orders = data as? [String: Any]{
                    self.recipts.removeAll();
                    self.total = 0.0;
                    for order in orders {
                        if let OrderInfo = order.value as? [String: Any]{
                            print(d1);
                            if(d1 == OrderInfo["date"] as? String && "DONE" == OrderInfo["status"] as? String){
                            self.recipts.append(Recipt(id: OrderInfo["orderId"] as? String, date:  OrderInfo["date"] as? String, food: OrderInfo["foodName"] as? String, price: OrderInfo["price"] as? Double, total: OrderInfo["price"] as? Double))
                                let tot =  OrderInfo["price"] as? Double;
                                self.total = self.total + (tot ?? 0) ;
                                self.lblTotal.text = "Rs. \(self.total as! Double)"
                            }
                            else{
                                self.total = 0.0;
                                self.lblTotal.text = "Rs. 0.00"
                            }
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
