//
//  ShowDetailsViewController.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-29.
//
public struct OrderItem: Codable {
    let name : String?
    let qty : String?
    let price : String?
    

    enum CodingKeys: String, CodingKey {
        case name
        case qty
        case price
    }
}
import UIKit
import Firebase
import CoreLocation
import UserNotifications
class ShowDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var btnArriving: UIButton!
    @IBOutlet weak var lblTimeRemain: UILabel!
    @IBOutlet weak var tblItemView: UITableView!
    var ref = Database.database().reference()
    var orderItems = [OrderItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation();
        getDetails();
        tblItemView.delegate = self;
        tblItemView.dataSource = self;
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackCllick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPhoneClick(_ sender: Any) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderItemCell = tblItemView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ShowOrderTableViewCell
        orderItemCell.lblFoodName.text = orderItems[indexPath.row].name;
        orderItemCell.lblQty.text = "\(orderItems[indexPath.row].qty ?? "0 X")";
        orderItemCell.lblFoodPrice.text = orderItems[indexPath.row].price;
       // orderItemCell.lblQty.text = "2 X";
       // orderItemCell.lblFoodPrice.text = "200"
        
        return orderItemCell;
    }
    func getDetails()
    {
        lblCustomerName.text = "\(UserDefaults.standard.string(forKey: "CusName") ?? "") (\(UserDefaults.standard.string(forKey: "OrderId") ?? ""))"
        btnArriving.setTitle(UserDefaults.standard.string(forKey: "Status"), for: .normal)
        let ref = Database.database().reference()
        print("Show = \(UserDefaults.standard.string(forKey: "OrderId") ?? "")")
        ref.child("Orders").child("\(UserDefaults.standard.string(forKey: "OrderId") ?? "")").child("items").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let items = data as? [String: Any]{
                    self.orderItems.removeAll();
                    for item in items {
                        if let itemInfo = item.value as? [String: Any]{
                            self.orderItems.append(OrderItem(name: itemInfo["foodName"] as? String, qty: "\(itemInfo["qty"] ?? 0) X", price: "\(itemInfo["price"] ?? 0)"));
                                    }
                                }
                                self.tblItemView.reloadData()
                          }
                    }
             })
        
    }
    func getLocation()
    {
        let ref = Database.database().reference()
        print("Show = \(UserDefaults.standard.string(forKey: "OrderId") ?? "")")
        ref.child("Orders").child("\(UserDefaults.standard.string(forKey: "OrderId") ?? "")").observe(.value, with:{
            (snapshot) in
            if let data = snapshot.value {
                if let items = data as? [String: Any]{
                    if("READY" == UserDefaults.standard.string(forKey: "Status") || "ARRIVING" == UserDefaults.standard.string(forKey: "Status"))
                    {
                        self.ChangeStatus(lattude: items["latitude"] as! Double , longt: items["longitude"] as! Double)
                    }
                        
                          }
                    }
             })
        
    }
    func ChangeStatus(lattude:Double,longt:Double)
    {
        print(lattude,longt)
        if(1000>calculateDistance(lattude: lattude, longt: longt) && calculateDistance(lattude: lattude, longt: longt) >= 500)
        {
            lblTimeRemain.text = "15 Min";
            self.ref.child("Orders/\(UserDefaults.standard.string(forKey: "OrderId") ?? "")/status").setValue("READY")
            UserDefaults.standard.set("READY", forKey: "Status")
            
        }
        else if(500 > calculateDistance(lattude: lattude, longt: longt) && calculateDistance(lattude: lattude, longt: longt) >= 200)
        {
            lblTimeRemain.text = "5 Min";
            self.ref.child("Orders/\(UserDefaults.standard.string(forKey: "OrderId") ?? "")/status").setValue("READY")
            UserDefaults.standard.set("READY", forKey: "Status")
        }
        else if(200 > calculateDistance(lattude: lattude, longt: longt) && calculateDistance(lattude: lattude, longt: longt) >= 0)
        {
            self.ref.child("Orders/\(UserDefaults.standard.string(forKey: "OrderId") ?? "")/status").setValue("ARRIVING")
            lblTimeRemain.text = "1 Min";
            UserDefaults.standard.set("ARRIVING", forKey: "Status")
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                if success {
                    // schedule test
                    self.notificationSend()
                    
                }
                else if error != nil {
                    print("error occurred")
                }
            })
        }
        else
        {
            lblTimeRemain.text = "Far..";
            self.ref.child("Orders/\(UserDefaults.standard.string(forKey: "OrderId") ?? "")/status").setValue("READY")
            UserDefaults.standard.set("READY", forKey: "Status")
        }
        
        self.getDetails();
      
    }
    func calculateDistance(lattude:Double,longt:Double) -> Int{
        
        let longt1 = Double(79.87084447732048)
        let lattude1 = Double(6.906412208455909 )
            
            
            let coordinate1 = CLLocation(latitude: lattude1, longitude: longt1)
            let coordinate2 = CLLocation(latitude: lattude, longitude:longt)
            let distanceInMeters = coordinate2.distance(from: coordinate1)/1000
        
            print("\(Int(distanceInMeters))");
        
            return Int(distanceInMeters)
        }
    
    
    func notificationSend() {
       let content = UNMutableNotificationContent()
        
       
        content.title = "Customer Arrived..!"
        content.sound = .default
        content.body = "Please continue the Delivery for Order ID : \(UserDefaults.standard.string(forKey: "OrderId") ?? "000")"

        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
    /*
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Override point for customization after application launch.
            
       // Fetch data once an hour.
       UIApplication.shared.setMinimumBackgroundFetchInterval(5)

       // Other initialization…
       return true
    }
        
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
       // Check for location
        getLocation();
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
