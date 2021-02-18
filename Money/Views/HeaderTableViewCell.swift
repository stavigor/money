//
//  HeaderTableViewCell.swift
//  Money
//
//  Created by Igor Rastegaev on 15.02.2021.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var chevronImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
