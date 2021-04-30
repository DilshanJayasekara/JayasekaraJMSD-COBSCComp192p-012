//
//  AccountTableViewCell.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-29.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
