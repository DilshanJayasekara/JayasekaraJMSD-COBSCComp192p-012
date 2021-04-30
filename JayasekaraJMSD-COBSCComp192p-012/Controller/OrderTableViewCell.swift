//
//  OrderTableViewCell.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-28.
//

import UIKit
import Firebase
class OrderTableViewCell: UITableViewCell {

    var ref = Database.database().reference()
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    @IBAction func btnClickReject(_ sender: UIButton) {
        self.ref.child("Orders/\(sender.tag)/status").setValue("Cancel")
    }
    @IBAction func btnClickAccept(_ sender: UIButton) {
        self.ref.child("Orders/\(sender.tag)/status").setValue("Arriving")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
