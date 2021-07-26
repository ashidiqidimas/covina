//
//  HospitalTableViewCell.swift
//  Covina
//
//  Created by Dimas on 26/07/21.
//

import UIKit

class HospitalTableViewCell: UITableViewCell {

	@IBOutlet weak var hospitalImage: UIImageView!
	@IBOutlet weak var hospitalNameLabel: UILabel!
	@IBOutlet weak var availableBedLabel: UILabel!
	@IBOutlet weak var lastUpdated: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
