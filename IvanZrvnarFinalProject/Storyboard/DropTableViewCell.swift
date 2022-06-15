//
//  DropTableViewCell.swift
//  IvanZrvnarFinalProject
//
//  Created by Ivan Zrvnar on 2022-05-23.
//

import UIKit

protocol CellTapDelegate: AnyObject {
    func buttonTapped(cell: DropTableViewCell)
    func closetButtonTapped(cell: DropTableViewCell)
}

class DropTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var clothingItemImageView: UIImageView!
    @IBOutlet var goToLink: UIButton!
    @IBOutlet var addToCloset: UIButton!
    
    weak var delegate: CellTapDelegate?

    @IBAction func linkButtontapped(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)

    }
    @IBAction func closetButtonTapped(_ sender: Any) {
        self.delegate?.closetButtonTapped(cell: self)
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
