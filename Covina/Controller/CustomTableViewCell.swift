//
//  CustomTableViewCell.swift
//  Covina
//
//  Created by Dimas on 25/07/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
	
	@IBOutlet weak var locationImage: UIImageView!
	@IBOutlet weak var locationLabel: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		
//		contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
//	}
    
}
