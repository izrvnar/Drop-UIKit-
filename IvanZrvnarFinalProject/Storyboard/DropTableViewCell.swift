//
//  DropTableViewCell.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-23.
//

import UIKit

class DropTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var clothingItemImageView: UIImageView!
    

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
