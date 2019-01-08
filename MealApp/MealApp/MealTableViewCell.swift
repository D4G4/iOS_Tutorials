//
//  MealTableViewCell.swift
//  MealApp
//
//  Created by Daksh Gargas on 30/12/18.
//  Copyright © 2018 Daksh Gargas. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    //  MARK: Properites
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingConrol!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
