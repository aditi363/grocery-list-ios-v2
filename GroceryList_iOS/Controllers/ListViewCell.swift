//
//  ListViewCell.swift
//  GroceryList_iOS
//
//  Created by Amandeep Singh on 2022-04-12.
//

import UIKit

class ListViewCell: UITableViewCell {

    
    @IBOutlet weak var ItemView: UIView!
    @IBOutlet weak var Itemname: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
