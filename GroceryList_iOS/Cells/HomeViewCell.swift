//
//  HomeViewCell.swift
//  GroceryList_iOS
//
//  Created by Amandeep Singh on 2022-04-13.
//

import UIKit



class HomeViewCell: UITableViewCell {

    
    @IBOutlet weak var View1: UIView!
    
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var listname_home: UILabel!
    
    @IBOutlet weak var orangeCell: UIView!
    
    @IBOutlet weak var Deletebutton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
