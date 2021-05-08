//
//  PreviewTableViewCell.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-27.
//

import UIKit
import Firebase
class PreviewTableViewCell: UITableViewCell {
    var ref = Database.database().reference()
    @IBOutlet weak var imgViewFood: UIImageView!
    
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnClickSwitch(_ sender: UISwitch) {
        print(switchActive.isOn);
        print(sender.tag);
        if(switchActive.isOn){
            self.ref.child("Foods/\(sender.tag)/cellActive").setValue(true);
        }
        else
        {
                self.ref.child("Foods/\(sender.tag)/cellActive").setValue(false);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
