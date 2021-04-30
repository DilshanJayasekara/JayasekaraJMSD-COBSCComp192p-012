//
//  ShowOrderTableViewCell.swift
//  JayasekaraJMSD-COBSCComp192p-012
//
//  Created by Dilshan Jayasekara on 2021-04-29.
//

import UIKit

class ShowOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
